import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../widgets/snackbar.dart';
import 'package:flutter/material.dart';

class TransactionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var transactionId = ''.obs;
  var status_transaction = ''.obs;

  var memberData = {}.obs;
  var bookList = <Map<String, dynamic>>[].obs;
  var quantity = 1.obs;

  Future<Map<String, dynamic>?> fetchTransaction(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('user').doc(userId);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('transaction')
          .where('user_id', isEqualTo: userRef)
          .where('return_date', isEqualTo: null)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        data['transaction_id'] = doc.id;
        return data;
      }

      return null;
    } catch (e) {
      print('Gagal mengambil transaksi: $e');
      return null;
    }
  }

  Future<void> submitTransaction({
    required String userId,
    required Map<String, dynamic> book,
    required int quantity,
  }) async {
    try {
      final now = Timestamp.now();
      final userRef = _firestore.doc('user/$userId');
      final bookRef = _firestore.doc('book/${book['book_id']}');
      final estimateReturn = Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 14)),
      );

      final querySnapshot =
          await _firestore
              .collection('transaction')
              .where('user_id', isEqualTo: userRef)
              .where('return_date', isNull: true)
              .where('status_transaction', isEqualTo: 'draft')
              .limit(1)
              .get();

      DocumentReference transactionRef;

      if (querySnapshot.docs.isNotEmpty) {
        final existingTransaction = querySnapshot.docs.first;
        final existingStatus =
            existingTransaction['status_transaction'] ?? 'draft';

        if (existingStatus != 'draft') {
          MySnackBar.show(
            title: 'Transaksi Aktif',
            message: 'Anda memiliki transaksi aktif yang sedang berjalan.',
            backgroundColor: Colors.orange,
            fontColor: Colors.white,
            icon: Icons.warning,
          );
          return;
        }

        transactionRef = querySnapshot.docs.first.reference;

        final detailSnapshot =
            await transactionRef.collection('transaction_detail').get();
        int currentTotalQuantity = 0;
        DocumentSnapshot? existingDetail;

        for (var doc in detailSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          currentTotalQuantity += (data['quantity'] ?? 0) as int;

          final docBookRef = data['book_id'] as DocumentReference?;
          if (docBookRef?.id == bookRef.id) {
            existingDetail = doc;
          }
        }

        if (currentTotalQuantity + quantity > 3) {
          MySnackBar.show(
            title: 'Maksimal Terlampaui',
            message: 'Total buku tidak boleh lebih dari 3.',
            backgroundColor: Colors.orange,
            fontColor: Colors.white,
            icon: Icons.warning,
          );
          return;
        }

        if (existingDetail != null) {
          final currentQty =
              (existingDetail.data() as Map<String, dynamic>)['quantity'] ?? 0;
          await existingDetail.reference.update({
            'quantity': currentQty + quantity,
          });
        } else {
          await transactionRef.collection('transaction_detail').add({
            'book_id': bookRef,
            'transaction_id': transactionRef,
            'quantity': quantity,
          });
        }
      } else {
        checkUserSuspensionStatus(userId);

        final transactionRef = await _firestore.collection('transaction').add({
          'user_id': userRef,
          'borrow_date': now,
          'estimate_return_date': estimateReturn,
          'return_date': null,
          'status_penalty': false,
          'status_transaction': 'draft',
        });

        final detailRef = await transactionRef
            .collection('transaction_detail')
            .add({
              'book_id': bookRef,
              'transaction_id': transactionRef,
              'quantity': quantity,
            });

        await transactionRef.update({'transaction_id': transactionRef.id});
        await detailRef.update({'detail_id': detailRef.id});
      }

      MySnackBar.show(
        title: 'Sukses',
        message:
            'Permintaan peminjaman dikirim. Menunggu persetujuan pustakawan.',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal mengajukan peminjaman: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error,
      );
    }
  }

  Future<bool> checkUserSuspensionStatus(String userId) async {
    try {
      final now = DateTime.now();

      final transactionQuery =
          await _firestore
              .collection('transaction')
              .where('user_id', isEqualTo: _firestore.doc('users/$userId'))
              .get();

      for (var transactionDoc in transactionQuery.docs) {
        final penaltySnapshot =
            await _firestore
                .collection('transaction')
                .doc(transactionDoc.id)
                .collection('penalty')
                .get();

        for (var penaltyDoc in penaltySnapshot.docs) {
          final data = penaltyDoc.data();

          if (data.containsKey('suspend_until')) {
            final suspendUntil = (data['suspend_until'] as Timestamp).toDate();

            if (now.isBefore(suspendUntil)) {
              MySnackBar.show(
                title: 'Akun Ditangguhkan',
                message:
                    'Anda masih dalam masa suspend akibat keterlambatan pengembalian buku. Silakan coba lagi nanti.',
                backgroundColor: Colors.red,
                fontColor: Colors.white,
                icon: Icons.block,
              );
              return true;
            }
          }
        }
      }

      return false;
    } catch (e) {
      print('Error checking suspension: $e');
      return false;
    }
  }

  Future<void> updateTransactionStatus(
    String transactionId,
    String status,
  ) async {
    final docRef = _firestore.collection('transaction').doc(transactionId);
    final docSnap = await docRef.get();
    final currentData = docSnap.data();
    final previousStatus = currentData?['status_transaction'] ?? '';

    final detailSnap = await docRef.collection('transaction_detail').get();
    for (var detailDoc in detailSnap.docs) {
      final detailData = detailDoc.data();
      final bookRef = detailData['book_id'] as DocumentReference;
      final bookSnap = await bookRef.get();

      if (!bookSnap.exists) continue;

      final bookData = bookSnap.data() as Map<String, dynamic>;
      final bookStock = bookData['stock'] ?? 0;
      final borrowQty = detailData['quantity'] ?? 0;
      final currentStock = bookStock - borrowQty;

      final validTransitions = {
        'waiting for borrow': 'borrowed',
        'waiting for booking': 'booking',
      };

      if (validTransitions[previousStatus] == status) {
        await bookRef.update({'stock': currentStock});
      }
    }

    await docRef.update({'status_transaction': status});

    String message = '';
    switch (status) {
      case 'waiting for borrow':
        message = 'Diajukan untuk peminjaman buku.';
        break;
      case 'waiting for booking':
        message = 'Diajukan untuk booking buku.';
        break;
      case 'take a book':
        message = 'Diajukan untuk mengambil buku yang telah dibooking.';
        break;
      case 'waiting for return':
        message = 'Diajukan untuk mengembalikan buku yang telah dipinjam.';
        break;
      case 'borrowed':
        message = 'Disetujui untuk meminjam buku.';
        break;
      case 'booking':
        message = 'Disetujui untuk dibooking.';
        break;
      default:
        message = 'Status transaksi diperbarui.';
    }

    Get.back();
    MySnackBar.show(
      title: 'Berhasil',
      message: message,
      backgroundColor: Colors.green,
      fontColor: Colors.white,
      icon: Icons.check,
    );
  }

  Future<Map<String, dynamic>> loadTransactionData(
    String id, {
    bool isAdmin = false,
  }) async {
    transactionId.value = id;
    final Map<String, dynamic> result = {};

    try {
      final transactionDoc =
          await _firestore.collection('transaction').doc(id).get();
      final transactionData = transactionDoc.data();
      if (transactionData == null) return {};

      result['transaction'] = transactionData;

      final userRef = transactionData['user_id'] as DocumentReference?;
      if (userRef != null && isAdmin) {
        final userSnapshot = await userRef.get();
        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final accountSnapshot =
              await userRef.collection('account').limit(1).get();
          if (accountSnapshot.docs.isNotEmpty) {
            final accountData = accountSnapshot.docs.first.data();
            final roleRef = accountData['role_id'] as DocumentReference?;

            String roleId = '';
            if (roleRef != null) {
              roleId = roleRef.id;
            }

            final userFormatted = {
              'user_id': userRef.id,
              'nin': userData['nin'] ?? '',
              'name': userData['name'] ?? '',
              'email': accountData['email'] ?? '',
              'phone_number': userData['phone_number'] ?? '',
              'role_id': roleId,
              'barcode': userData['barcode'] ?? '',
            };

            memberData.value = userFormatted;
            result['user'] = userFormatted;
          }
        }
      }

      final detailSnapshot =
          await _firestore
              .collection('transaction')
              .doc(id)
              .collection('transaction_detail')
              .get();

      final books = <Map<String, dynamic>>[];
      for (var detail in detailSnapshot.docs) {
        final data = detail.data();
        final bookRef = data['book_id'] as DocumentReference?;
        if (bookRef == null) continue;

        final bookSnapshot = await bookRef.get();
        if (!bookSnapshot.exists) continue;

        final bookData = bookSnapshot.data() as Map<String, dynamic>;
        books.add({
          'title': bookData['title'],
          'author': bookData['author'],
          'quantity': data['quantity'],
          'detail_id': detail.id,
        });
      }

      result['books'] = books;
      result['detail'] = detailSnapshot;
    } catch (e) {
      print('Error loading transaction data: $e');
    }

    return result;
  }

  Future<void> returnWithPenaltyCheck(
    String transactionId,
    String status,
  ) async {
    final docRef = _firestore.collection('transaction').doc(transactionId);
    final doc = await docRef.get();
    final data = doc.data();

    if (data == null) return;

    final now = Timestamp.now();
    await docRef.update({'return_date': now, 'status_transaction': status});

    if (status == 'returned') {
      final detailSnap = await docRef.collection('transaction_detail').get();

      for (var detailDoc in detailSnap.docs) {
        final detailData = detailDoc.data();
        final bookRef = detailData['book_id'] as DocumentReference;
        final bookSnap = await bookRef.get();

        if (bookSnap.exists) {
          final bookData = bookSnap.data() as Map<String, dynamic>;
          final bookStock = bookData['stock'] ?? 0;
          final borrowQty = detailData['quantity'] ?? 0;
          final currentStock = bookStock + borrowQty;
          await bookRef.update({'stock': currentStock});
        }
      }
    }

    if (data['estimate_return_date'] != null) {
      final estimate = data['estimate_return_date'] as Timestamp;
      final late = now.toDate().isAfter(estimate.toDate());

      await docRef.update({'status_penalty': late});

      if (late) {
        final penaltyRef = await docRef.collection('penalty').add({
          'transaction_id': doc.reference,
          'suspend_until': Timestamp.fromDate(
            now.toDate().add(const Duration(days: 7)),
          ),
        });

        await penaltyRef.update({'penalty_id': penaltyRef.id});

        MySnackBar.show(
          title: 'Pengembalian Terlambat',
          message: 'Anda terkena penalty dan disuspend hingga 7 hari ke depan.',
          backgroundColor: Colors.orange,
          fontColor: Colors.white,
          icon: Icons.warning,
        );
      } else {
        MySnackBar.show(
          title: 'Pengembalian Berhasil',
          message: 'Buku berhasil dikembalikan tepat waktu.',
          backgroundColor: Colors.green,
          fontColor: Colors.white,
          icon: Icons.check,
        );
      }
    } else {
      MySnackBar.show(
        title: 'Berhasil',
        message: (status == 'returned') ? 'Diterima' : 'Ditolak',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check,
      );
    }
  }

  Future<void> removeBookFromTransaction(
    String transactionId,
    String detailId,
  ) async {
    try {
      final detailRef = FirebaseFirestore.instance
          .collection('transaction')
          .doc(transactionId)
          .collection('transaction_detail')
          .doc(detailId);

      await detailRef.delete();

      final remainingDetails =
          await FirebaseFirestore.instance
              .collection('transaction')
              .doc(transactionId)
              .collection('transaction_detail')
              .get();

      if (remainingDetails.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('transaction')
            .doc(transactionId)
            .delete();
        Get.back();
      }

      MySnackBar.show(
        title: 'Berhasil',
        message: 'Buku berhasil dihapus dari transaksi.',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Gagal',
        message: 'Gagal menghapus buku dari transaksi: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.block,
      );
    }
  }
}

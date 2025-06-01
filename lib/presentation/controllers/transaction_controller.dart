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
        DateTime.now().add(const Duration(days: 7)),
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
            bgColor: Colors.orange,
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

          // Cek apakah buku sudah ada dalam detail
          final docBookRef = data['book_id'] as DocumentReference?;
          if (docBookRef?.id == bookRef.id) {
            existingDetail = doc;
          }
        }

        if (currentTotalQuantity + quantity > 3) {
          MySnackBar.show(
            title: 'Maksimal Terlampaui',
            message: 'Total buku tidak boleh lebih dari 3.',
            bgColor: Colors.orange,
            icon: Icons.warning,
          );
          return;
        }

        if (existingDetail != null) {
          final currentQty = (existingDetail.data() as Map<String, dynamic>)['quantity'] ?? 0;
          await existingDetail.reference.update({'quantity': currentQty + quantity});
        } else {
          await transactionRef
              .collection('transaction_detail')
              .add({
                'book_id': bookRef,
                'transaction_id': transactionRef,
                'quantity': quantity,
              });
        }
      } else {
        final transactionRef = await _firestore.collection('transaction').add({
          'user_id': userRef,
          'borrow_date': now,
          'estimate_return_date': estimateReturn,
          'return_date': null,
          'status_penalty': false,
          'status_transaction': 'draft',
        });
        await transactionRef;

        final newDetailRef = await transactionRef
            .collection('transaction_detail')
            .add({
              'book_id': bookRef,
              'transaction_id': transactionRef,
              'quantity': quantity,
            });
        await newDetailRef;

        await transactionRef.update({'transaction_id': transactionRef.id});
        await newDetailRef.update({'detail_id': newDetailRef.id});
      }

      MySnackBar.show(
        title: 'Sukses',
        message:
            'Permintaan peminjaman dikirim. Menunggu persetujuan pustakawan.',
        bgColor: Colors.green,
        icon: Icons.check,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal mengajukan peminjaman: $e',
        bgColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> userUpdateTransactionStatus(String transactionId, String status) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('transaction').doc(transactionId).update({
      'status_transaction': status,
    });

    Get.back();
    Get.snackbar(
      'Berhasil',
      status == 'waiting for borrow'
          ? 'Transaksi diajukan sebagai peminjaman.'
          : 'Transaksi diajukan sebagai booking.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> returnBookWithPenaltyCheck(String id) async {
    final doc = await _firestore.collection('transaction').doc(id).get();
    final data = doc.data();
    final now = Timestamp.now();

    if (data != null && data['estimate_return_date'] != null) {
      final estimate = data['estimate_return_date'] as Timestamp;
      final late = now.toDate().isAfter(estimate.toDate());

      await _firestore.collection('transaction').doc(id).update({
        'return_date': now,
        'status_penalty': late,
      });

      if (late) {
        await _firestore
            .collection('transaction')
            .doc(id)
            .collection('penalty')
            .add({'transaction_id': doc.reference, 'period': now});
      }
    }
  }

  Future<Map<String, dynamic>> loadTransactionData(String id, {bool isAdmin = false}) async {
    transactionId.value = id;
    final Map<String, dynamic> result = {};

    try {
      final transactionDoc = await _firestore.collection('transaction').doc(id).get();
      final transactionData = transactionDoc.data();
      if (transactionData == null) return {};

      result['transaction'] = transactionData;

      final userRef = transactionData['user_id'] as DocumentReference?;
      if (userRef != null && isAdmin) {
        final userSnapshot = await userRef.get();
        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final accountSnapshot = await userRef.collection('account').limit(1).get();
          if (accountSnapshot.docs.isNotEmpty) {
            final accountData = accountSnapshot.docs.first.data();
            final roleRef = accountData['role_id'] as DocumentReference?;

            // Ambil ID role (misal "admin", "member", dll)
            String roleId = '';
            if (roleRef != null) {
              roleId = roleRef.id;
            }

            final userFormatted = {
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

      final detailSnapshot = await _firestore
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
        });
      }

      result['books'] = books;
    } catch (e) {
      print('Error loading transaction data: $e');
    }

    return result;
  }

  Future<void> approveTransaction() async {
    if (transactionId.value.isEmpty) return;

    final detailsRef = _firestore
        .collection('transaction')
        .doc(transactionId.value)
        .collection('transaction_detail');

    final snapshot = await detailsRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'status': 'borrowed'});
    }

    Get.snackbar('Berhasil', 'Transaksi telah disetujui');
    await loadTransactionData(transactionId.value);
  }

  Future<void> returnBooks() async {
    if (transactionId.value.isEmpty) return;

    final detailsRef = _firestore
        .collection('transaction')
        .doc(transactionId.value)
        .collection('transaction_detail');

    final snapshot = await detailsRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'status': 'returned'});
    }

    Get.snackbar('Berhasil', 'Buku berhasil dikembalikan');
    await loadTransactionData(transactionId.value);
  }

  bool get allReturned =>
      bookList.every((book) => book['status'] == 'returned');

  bool get allBorrowed =>
      bookList.every((book) => book['status'] == 'borrowed');
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../widgets/snackbar.dart';
import 'package:flutter/material.dart';

class TransactionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var transactionId = ''.obs;
  var memberData = {}.obs;
  var bookList = <Map<String, dynamic>>[].obs;
  var quantity = 1.obs;
  var isBooking = false.obs;

  Future<void> submitTransaction({
    required String userId,
    required Map<String, dynamic> book,
    required int quantity,
  }) async {
    try {
      final now = Timestamp.now();
      final userRef = _firestore.doc('user/$userId');
      final bookRef = _firestore.doc('book/${book['id']}');

      // Cari transaksi aktif
      final querySnapshot = await _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: userRef)
          .where('return_date', isNull: true)
          .limit(1)
          .get();

      DocumentReference transactionRef;

      if (querySnapshot.docs.isNotEmpty) {
        final existingTransaction = querySnapshot.docs.first;
        final existingIsBooking = existingTransaction['is_booking'] as bool;

        // Cek apakah jenis transaksi sama
        if (existingIsBooking != isBooking.value) {
          MySnackBar.show(
            title: 'Transaksi Aktif',
            message:
            'Anda memiliki transaksi aktif yang berbeda jenis. Selesaikan terlebih dahulu.',
            bgColor: Colors.orange,
            icon: Icons.warning,
          );
          return;
        }

        transactionRef = querySnapshot.docs.first.reference;

        // Ambil semua detail transaksi
        final detailSnapshot = await transactionRef.collection('transaction_detail').get();

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
            message: 'Total buku tidak boleh lebih dari 3',
            bgColor: Colors.orange,
            icon: Icons.warning,
          );
          return;
        }

        if (existingDetail != null) {
          // Jika buku sudah ada → update quantity
          final currentQty = (existingDetail.data() as Map<String, dynamic>)['quantity'] ?? 0;
          await existingDetail.reference.update({'quantity': currentQty + quantity});
        } else {
          // Jika buku belum ada → tambahkan detail baru
          await transactionRef.collection('transaction_detail').add({
            'book_id': bookRef,
            'transaction_id': transactionRef,
            'quantity': quantity,
            'status': 'pending',
          });
        }
      } else {
        // Buat transaksi baru
        transactionRef = await _firestore.collection('transaction').add({
          'user_id': userRef,
          'borrow_date': now,
          'estimate_return_date': null,
          'return_date': null,
          'status_penalty': false,
          'is_booking': isBooking.value,
        });

        // Tambahkan detail pertama
        await transactionRef.collection('transaction_detail').add({
          'book_id': bookRef,
          'transaction_id': transactionRef,
          'quantity': quantity,
          'status': 'pending',
        });
      }

      MySnackBar.show(
        title: 'Sukses',
        message: isBooking.value
            ? 'Buku berhasil dibooking'
            : 'Buku berhasil dipinjam',
        bgColor: isBooking.value ? Colors.blue : Colors.green,
        icon: isBooking.value ? Icons.info : Icons.check,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal ${isBooking.value ? 'booking' : 'meminjam'} buku: $e',
        bgColor: Colors.red,
        icon: Icons.error,
      );
    }
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

  Future<void> loadTransactionData(String id) async {
    transactionId.value = id;
    try {
      final transactionDoc = await _firestore.collection('transaction').doc(id).get();
      final transactionData = transactionDoc.data();

      if (transactionData == null) return;

      final userRef = transactionData['user_id'] as DocumentReference?;
      if (userRef != null) {
        final userSnapshot = await userRef.get();
        if (userSnapshot.exists) {
          memberData.value = {
            'nin': userSnapshot['nin'],
            'name': userSnapshot['name'],
            'email': userSnapshot['email'],
            'phone_number': userSnapshot['phone_number'],
            'role': userSnapshot['role_id'],
            'barcode': userSnapshot['barcode'] ?? '',
          };
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
          'status': data['status'],
        });
      }

      bookList.value = books;
    } catch (e) {
      print('Error loading transaction data: $e');
    }
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

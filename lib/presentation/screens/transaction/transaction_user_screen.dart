import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/data/share_preference.dart';
import 'package:libra_scan/presentation/widgets/button.dart';

class TransactionUserScreen extends StatelessWidget {
  const TransactionUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> selectedBooks =
        Get.arguments ?? []; // Dikirim dari halaman sebelumnya
    final DateTime returnDate = DateTime.now().add(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...selectedBooks.map(
                  (book) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.purple.shade50,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book),
                    ),
                    title: Text(book['title'] ?? 'Tanpa Judul'),
                    subtitle: Text(book['author'] ?? 'Tanpa Penulis'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Harus dikembalikan sebelum ${returnDate.day}/${returnDate.month}/${returnDate.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: MyButton(
          onPressed: () async {
            await _submitTransaction(selectedBooks, returnDate);
          },
          color: ColorConstant.greenColor,
          child: const Text(
            'Ajukan Peminjaman',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _submitTransaction(
      List<Map<String, dynamic>> books, DateTime returnDate) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userData = await LocalStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User tidak ditemukan');
        return;
      }

      final transactionRef = await firestore.collection('transactions').add({
        'user_id': firestore.doc('users/$userId'),
        'created_at': Timestamp.now(),
        'return_date': Timestamp.fromDate(returnDate),
        'status': 'pending',
      });

      for (var book in books) {
        final bookId = book['id'];
        if (bookId != null) {
          await transactionRef.collection('transaction_details').add({
            'book_id': firestore.doc('books/$bookId'),
            'status': 'borrowed',
          });
        }
      }

      Get.snackbar('Sukses', 'Peminjaman diajukan');
      Get.offAllNamed('/home'); // atau arahkan kembali ke halaman utama
    } catch (e) {
      print('Error submit transaction: $e');
      Get.snackbar('Error', 'Gagal mengajukan peminjaman');
    }
  }
}

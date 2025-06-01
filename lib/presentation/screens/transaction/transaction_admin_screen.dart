import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/controllers/transaction_controller.dart';

import '../../../common/constants/color_constans.dart';
import '../../widgets/book_card.dart';
import '../../widgets/button.dart';

class TransactionAdminScreen extends StatefulWidget {
  const TransactionAdminScreen({super.key});

  @override
  State<TransactionAdminScreen> createState() => _TransactionAdminScreenState();
}

class _TransactionAdminScreenState extends State<TransactionAdminScreen> {
  final transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String? transactionId = args['transaction_id'];

    if (transactionId == null) {
      return const Scaffold(
        body: Center(child: Text('ID Transaksi tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: transactionController.loadTransactionData(
          transactionId,
          isAdmin: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Gagal memuat data transaksi.'));
          }

          final data = snapshot.data!;
          final books =
              (data['books'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final transaction =
              (data['transaction'] as Map<String, dynamic>?) ?? {};
          final member = (data['user'] as Map<String, dynamic>?) ?? {};
          final estimateReturn =
              transaction['estimate_return_date'] as Timestamp?;
          final status = transaction['status_transaction'] as String?;
          final barcode = member['barcode'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Anggota + Barcode
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member['nin'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(member['name'] ?? ''),
                                Text(member['email'] ?? ''),
                                Text(member['phone_number'] ?? ''),
                                Text(member['role_id'] ?? ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.white,
                        child: const Center(child: Text('Barcode Image')),
                      ),
                      const SizedBox(height: 4),
                      Text(barcode, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Daftar Buku
                Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/book-detail', arguments: book);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.book),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book['title'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(book['author'] ?? ''),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Estimasi Pengembalian / Denda
                if (estimateReturn != null)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Denda masih ${estimateReturn.toDate().difference(DateTime.now()).inDays} Hari lagi\nHingga tanggal ${estimateReturn.toDate().day}/${(estimateReturn.toDate().month)}/${estimateReturn.toDate().year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Tombol Aksi
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    onPressed: () {
                      if (status == 'waiting for approval') {
                        transactionController.approveTransaction();
                      } else if (status == 'borrowed') {
                        transactionController.returnBooks();
                      }
                    },
                    color: ColorConstant.greenColor,
                    child: const Text(
                      'Pinjam/Tolak/Kembali',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

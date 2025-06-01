import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/button.dart';

import '../../controllers/transaction_controller.dart';
import '../../widgets/book_card.dart';

class TransactionUserScreen extends StatefulWidget {
  const TransactionUserScreen({super.key});

  @override
  State<TransactionUserScreen> createState() => _TransactionUserScreenState();
}

class _TransactionUserScreenState extends State<TransactionUserScreen> {
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
      appBar: AppBar(title: const Text('Detail Transaksi'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: transactionController.loadTransactionData(transactionId),
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
          final books = data['books'] as List<Map<String, dynamic>>;
          final transaction = data['transaction'] as Map<String, dynamic>;
          final Timestamp? estimateReturn = transaction['estimate_return_date'];
          final String? currentStatus = transaction['status_transaction'];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...books.map(
                      (book) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: BookCard(
                          title: book['title'],
                          author: book['author'],
                          onTap: () {
                            Get.toNamed('/book-detail', arguments: book);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (estimateReturn != null)
                      Center(
                        child: Text(
                          'Harus dikembalikan sebelum ${estimateReturn.toDate().day}/${estimateReturn.toDate().month}/${estimateReturn.toDate().year}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (currentStatus != 'borrowed') ...[
                      MyButton(
                        onPressed:
                            () => transactionController.updateTransactionStatus(
                              transactionId,
                              'waiting for borrow',
                            ),
                        color: ColorConstant.greenColor,
                        child: const Text(
                          'Ajukan Peminjaman',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      MyButton(
                        onPressed:
                            () => transactionController.updateTransactionStatus(
                              transactionId,
                              'waiting for booking',
                            ),
                        color: ColorConstant.primaryColor,
                        child: const Text(
                          'Ajukan Booking',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ] else if (currentStatus == 'booking') ...[
                      MyButton(
                        onPressed:
                            () => transactionController.updateTransactionStatus(
                              transactionId,
                              'take a book',
                            ),
                        color: ColorConstant.primaryColor,
                        child: const Text(
                          'Ajukan Pengambilan Buku (Booking)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ] else if (currentStatus == 'borrowed') ...[
                      MyButton(
                        onPressed:
                            () => transactionController.updateTransactionStatus(
                              transactionId,
                              'waiting for return',
                            ),
                        color: ColorConstant.greenColor,
                        child: const Text(
                          'Ajukan Pengembalian',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

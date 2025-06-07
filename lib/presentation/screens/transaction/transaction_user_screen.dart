import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:libra_scan/utils/utils.dart';

import '../../controllers/transaction_controller.dart';
import '../../widgets/request_book_card.dart';

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
      return Scaffold(
        body: Center(
          child: Text(
            'ID Transaksi tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: ColorConstant.fontColor(context),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: transactionController.loadTransactionData(transactionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor(context),
              ),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Gagal memuat data transaksi.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstant.fontColor(context),
                ),
              ),
            );
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
                  children: [
                    ...books.map((book) {
                      return Dismissible(
                        key: Key(book['detail_id']),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Apakah kamu yakin ingin menghapus buku ini dari transaksi?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        onDismissed: (direction) {
                          transactionController.removeBookFromTransaction(
                              transactionId, book['detail_id']
                          );
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: RequestBookCard(
                            name: book['title'],
                            email: book['author'],
                            books: book['quantity'],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    if (estimateReturn != null)
                      Center(
                        child: Text(
                          'Harus dikembalikan sebelum ${formatDate(estimateReturn)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.fontColor(context),
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
                    if (currentStatus == 'draft') ...[
                      MyButton(
                        onPressed:
                            () => transactionController.updateTransactionStatus(
                              transactionId,
                              'waiting for borrow',
                            ),
                        backgroundColor: ColorConstant.primaryColor(context),
                        foregroundColor: Colors.white,
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
                        backgroundColor: ColorConstant.backgroundColor(context),
                        foregroundColor: ColorConstant.primaryColor(context),
                        child: Text(
                          'Ajukan Booking',
                          style: TextStyle(
                            color: ColorConstant.fontColor(context),
                          ),
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
                        backgroundColor: ColorConstant.primaryColor(context),
                        child: Text(
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
                        backgroundColor: ColorConstant.primaryColor(context),
                        child: const Text(
                          'Ajukan Pengembalian',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Menunggu Persetujuan Petugas Perpustakaan',
                        style: TextStyle(
                          color: ColorConstant.fontColor(context),
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

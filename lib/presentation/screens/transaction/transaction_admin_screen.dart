import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/controllers/transaction_controller.dart';
import 'package:libra_scan/presentation/widgets/member_card.dart';

import '../../../common/constants/color_constans.dart';
import '../../../utils/utils.dart';
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
        future: transactionController.loadTransactionData(
          transactionId,
          isAdmin: true,
        ),
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
          final books =
              (data['books'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final transaction =
              (data['transaction'] as Map<String, dynamic>?) ?? {};
          final estimateReturn =
              transaction['estimate_return_date'] as Timestamp?;
          final currentStatus = transaction['status_transaction'] as String?;

          final userData = (data['user'] as Map<String, dynamic>?) ?? {};
          final String userId = userData['user_id'] ?? '-';
          final String nin = userData['nin'] ?? '-';
          final String name = userData['name'] ?? '-';
          final String email = userData['email'] ?? '-';
          final String phoneNumber = userData['phone_number'] ?? '-';
          final String role = userData['role_id']?.toLowerCase() ?? 'anggota';
          final barcode = userData['barcode'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                MemberCard(
                  userId: userId,
                  nin: nin,
                  name: name,
                  email: email,
                  phoneNumber: phoneNumber,
                  role: role,
                  barcode: barcode,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      ...books.map(
                        (book) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
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

                if (currentStatus == 'waiting for borrow' ||
                    currentStatus == 'take a book') ...[
                  MyButton(
                    onPressed:
                        () => transactionController.updateTransactionStatus(
                          transactionId,
                          'borrowed',
                        ),
                    backgroundColor: ColorConstant.primaryColor(context),
                    child: const Text(
                      'Setuju Untuk Peminjaman Buku',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ] else if (currentStatus == 'waiting for booking') ...[
                  MyButton(
                    onPressed:
                        () => transactionController.updateTransactionStatus(
                          transactionId,
                          'booking',
                        ),
                    backgroundColor: ColorConstant.primaryColor(context),
                    child: const Text(
                      'Setuju Untuk Booking Buku',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ] else if (currentStatus == 'waiting for return') ...[
                  MyButton(
                    onPressed:
                        () => transactionController.returnWithPenaltyCheck(
                          transactionId,
                          'returned',
                        ),
                    backgroundColor: ColorConstant.primaryColor(context),
                    child: const Text(
                      'Menerima Pengembalian Buku',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ] else ...[
                  const SizedBox(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

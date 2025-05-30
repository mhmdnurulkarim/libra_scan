import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_user_controller.dart';
import '../../widgets/request_book_card.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  final controller = Get.put(HomeUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed('/scanner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.greenColor,
                minimumSize: const Size(double.infinity, 120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Scan Barcode',
                style: TextStyle(fontSize: 18, color: ColorConstant.whiteColor),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Yang sedang dipinjam/booking:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final transactions = controller.currentTransactions;

              if (transactions.isEmpty) {
                return const Text("Belum ada transaksi aktif.");
              }

              return Column(
                children: transactions.map((tx) {
                  return RequestBookCard(
                    name: 'Transaksi Aktif',
                    email: null,
                    date: tx['created_at'] as Timestamp?,
                    books: tx['book_count'] ?? 0,
                    onTap: () => controller.goToDetail(tx['transaction_id']),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Peminjaman sebelumnya:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final past = controller.pastLoans;

              if (past.isEmpty) {
                return const Text("Belum ada riwayat peminjaman.");
              }

              return Column(
                children: past.map((loan) {
                  return RequestBookCard(
                    name: loan['title'] ?? '',
                    email: loan['author'] ?? '',
                    date: null,
                    books: 1,
                    onTap: () => controller.goToDetail(loan),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

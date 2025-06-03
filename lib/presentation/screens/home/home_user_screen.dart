import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/color_constans.dart';
import '../../controllers/home_user_controller.dart';
import '../../widgets/request_book_card.dart';

class HomeUserScreen extends StatelessWidget {
  HomeUserScreen({super.key});

  final controller = Get.put(HomeUserController());

  String getStatusTitle(String status) {
    switch (status) {
      case 'borrowed':
        return 'Buku sedang dipinjam:';
      case 'waiting for borrow':
        return 'Ingin pinjam buku:';
      case 'waiting for booking':
        return 'Ingin booking buku:';
      case 'booking':
        return 'Buku sedang dibooking:';
      case 'take a book':
        return 'Ingin ambil booking buku:';
      case 'waiting for return':
        return 'Ingin mengembalikan buku:';
      default:
        return 'Daftar Keranjang Buku:';
    }
  }

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

            Obx(() {
              final transactions = controller.currentTransactions;
              if (transactions.isEmpty) return const SizedBox();

              final status = transactions.first['status'];
              final title = getStatusTitle(status);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...transactions.map(
                    (data) => RequestBookCard(
                      name: data['name'] ?? 'User',
                      date: data['created_at'],
                      books: data['book_count'] ?? 0,
                      onTap:
                          () => Get.toNamed(
                            '/transaction-user',
                            arguments: {
                              'transaction_id': data['transaction_id'],
                            },
                          ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 12),

            Obx(() {
              final past = controller.pastLoans;
              if (past.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peminjaman sebelumnya:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...past.map(
                    (data) => RequestBookCard(
                      name: data['name'] ?? 'User',
                      date: data['created_at'],
                      books: data['book_count'] ?? 0,
                      onTap:
                          () => Get.toNamed(
                            '/transaction-user',
                            arguments: {
                              'transaction_id': data['transaction_id'],
                            },
                          ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

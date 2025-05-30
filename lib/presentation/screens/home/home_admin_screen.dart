import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_admin_controller.dart';
import '../../widgets/request_book_card.dart';

class HomeAdminScreen extends StatelessWidget {
  HomeAdminScreen({super.key});

  final HomeAdminController controller = Get.put(HomeAdminController());

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

            // ------------------- PINJAMAN -------------------
            const Text(
              'Permintaan peminjaman buku:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.loanRequests.isEmpty) {
                return const Text('Tidak ada permintaan peminjaman buku.');
              } else {
                return Column(
                  children: controller.loanRequests
                      .map(
                        (member) => RequestBookCard(
                      name: member['name'] ?? '',
                      email: member['email'] ?? '',
                      books: member['book'] ?? 0,
                    ),
                  )
                      .toList(),
                );
              }
            }),

            const SizedBox(height: 24),

            // ------------------- BOOKING -------------------
            const Text(
              'Permintaan booking buku:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.bookingRequests.isEmpty) {
                return const Text('Tidak ada permintaan booking buku.');
              } else {
                return Column(
                  children: controller.bookingRequests
                      .map(
                        (member) => RequestBookCard(
                      name: member['name'] ?? '',
                      email: member['email'] ?? '',
                      books: member['book'] ?? 0,
                    ),
                  )
                      .toList(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

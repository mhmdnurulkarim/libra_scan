import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_user_controller.dart';
import '../../widgets/book_card.dart';

class HomeUserScreen extends StatefulWidget {
  HomeUserScreen({super.key});

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
            Obx(
              () => Column(
                children:
                    controller.currentLoans.map((loan) {
                      return BookCard(
                        title: loan['title'] ?? '',
                        author: loan['author'] ?? '',
                        onTap: () => controller.goToDetail(loan),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Peminjaman sebelumnya:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children:
                    controller.currentLoans.map((loan) {
                      return BookCard(
                        title: loan['title'] ?? '',
                        author: loan['author'] ?? '',
                        onTap: () => controller.goToDetail(loan),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

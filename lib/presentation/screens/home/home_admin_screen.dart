import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_admin_controller.dart';
import '../../widgets/member_request_card.dart';

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
            const Text(
              'Permintaan peminjaman buku:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: controller.loanRequests
                      .map((member) => MemberRequestCard(
                            name: member['name'] ?? '',
                            id: member['id'] ?? '',
                            books: member['books'] ?? 0,
                          ))
                      .toList(),
                )),
            const SizedBox(height: 24),
            const Text(
              'Permintaan booking buku:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: controller.bookingRequests
                      .map((member) => MemberRequestCard(
                            name: member['name'] ?? '',
                            id: member['id'] ?? '',
                            books: member['books'] ?? 0,
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }
}

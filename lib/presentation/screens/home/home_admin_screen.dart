import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_admin_controller.dart';
import '../../widgets/request_book_card.dart';

class HomeAdminScreen extends StatelessWidget {
  HomeAdminScreen({super.key});

  final HomeAdminController controller = Get.put(HomeAdminController());

  String getTitleFromStatus(String status) {
    switch (status) {
      case 'waiting for borrow':
        return 'Permintaan peminjaman buku:';
      case 'take a book':
        return 'Permintaan pengambilan buku:';
      case 'waiting for booking':
        return 'Permintaan booking buku:';
      case 'waiting for return':
        return 'Permintaan pengembalian buku:';
      default:
        return 'Permintaan lainnya:';
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
                backgroundColor: ColorConstant.primaryColor(context),
                minimumSize: const Size(double.infinity, 120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Scan Barcode',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),

            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primaryColor(context),
                  ),
                );
              }

              final grouped = controller.groupedRequests;
              if (grouped.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada permintaan transaksi.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.fontColor(context),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    grouped.entries.map((entry) {
                      final status = entry.key;
                      final requests = entry.value;
                      final title = getTitleFromStatus(status);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.fontColor(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...requests.map(
                            (data) => RequestBookCard(
                              name: data['name'] ?? '',
                              email: data['email'] ?? '',
                              books: data['book'] ?? 0,
                              onTap:
                                  () => Get.toNamed(
                                    '/transaction-admin',
                                    arguments: {
                                      'transaction_id': data['transaction_id'],
                                    },
                                  ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
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

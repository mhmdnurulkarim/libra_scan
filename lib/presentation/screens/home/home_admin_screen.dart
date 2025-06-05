import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/home_admin_controller.dart';
import '../../widgets/request_book_card.dart';

class HomeAdminScreen extends StatefulWidget {
  HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  final HomeAdminController controller = Get.put(HomeAdminController());

  @override
  void initState() {
    super.initState();
    controller.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchRequests();
          },
          color: ColorConstant.primaryColor(context),
          child: Obx(() {
            return ListView(
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

                if (controller.isLoading.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primaryColor(context),
                    ),
                  )
                else ...[
                  if (controller.groupedRequests.isEmpty)
                    Center(
                      child: Text(
                        'Tidak ada permintaan transaksi.',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConstant.fontColor(context),
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          controller.groupedRequests.entries.map((entry) {
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
                                  (data) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    child: RequestBookCard(
                                      name: data['name'] ?? '',
                                      email: data['email'] ?? '',
                                      books: data['book'] ?? 0,
                                      onTap:
                                          () => Get.toNamed(
                                            '/transaction-admin',
                                            arguments: {
                                              'transaction_id':
                                                  data['transaction_id'],
                                            },
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                    ),
                ],
              ],
            );
          }),
        ),
      ),
    );
  }

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
}

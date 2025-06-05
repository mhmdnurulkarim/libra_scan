import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  void initState() {
    super.initState();
    controller.fetchUserTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserTransactions();
          },
          color: ColorConstant.primaryColor(context),
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
                final transactions = controller.currentTransactions;
                if (transactions.isEmpty) {
                  return Text(
                    'Keranjang buku kamu kosong.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.fontColor(context),
                    ),
                  );
                }

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
                      (data) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: RequestBookCard(
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
      ),
    );
  }

  String getStatusTitle(String status) {
    switch (status) {
      case 'waiting for borrow':
        return 'Ingin pinjam buku:';
      case 'borrowed':
        return 'Buku sedang dipinjam:';
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
}

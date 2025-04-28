import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_admin_controller.dart';
import '../widgets/member_request_card.dart';

class HomeAdminScreen extends StatelessWidget {
  HomeAdminScreen({super.key});

  final HomeAdminController controller = Get.put(HomeAdminController());

  void _openScanner(BuildContext context) {
    Get.toNamed('/scanner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Get.toNamed('/home-admin');
          } else if (index == 1) {
            Get.toNamed('/search-admin');
          } else if (index == 2) {
            Get.toNamed('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: () => _openScanner(context),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Center(
                  child: Text(
                    'Fitur Scanner',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
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

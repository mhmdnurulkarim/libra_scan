import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/home_user_controller.dart';
import '../widgets/book_card.dart';

class HomeUserScreen extends StatelessWidget {
  HomeUserScreen({super.key});

  final HomeController controller = Get.put(HomeController());

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
            Get.toNamed('/home-user');
          } else if (index == 1) {
            Get.toNamed('/search-user');
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
              'Yang sedang dipinjam/booking:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: controller.currentLoans
                  .map((loan) => BookCard(
                title: loan['title'] ?? '',
                author: loan['author'] ?? '',
              ))
                  .toList(),
            )),
            const SizedBox(height: 24),
            const Text(
              'Peminjaman sebelumnya:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: controller.pastLoans
                  .map((loan) => BookCard(
                title: loan['title'] ?? '',
                author: loan['author'] ?? '',
              ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }
}

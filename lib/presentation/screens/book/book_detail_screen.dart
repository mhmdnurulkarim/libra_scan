import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/button.dart';

import '../../controllers/main_controller.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;
    final mainController = Get.find<MainScreenController>();

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Data buku tidak tersedia')),
      );
    }

    final String title = data['title'] ?? 'Judul Tidak Diketahui';
    final String isbn = data['isbn'] ?? '-';
    final String author = data['author'] ?? '-';
    final kategoriRef = data['category_id'] as DocumentReference?;
    final int stock = data['stock'] ?? 0;
    final String sinopsis = data['synopsis'] ?? 'Sinopsis tidak tersedia.';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('ISBN $isbn', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 4),
                      Text(author, style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      FutureBuilder<DocumentSnapshot>(
                        future: kategoriRef?.get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Memuat kategori...');
                          }
                          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                            return const Text('Kategori tidak ditemukan');
                          }
                          final kategoriData = snapshot.data!.data() as Map<String, dynamic>?;
                          return Text(
                            kategoriData?['name'] ?? 'Kategori Tidak Diketahui',
                            style: const TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text('$stock Stok Tersedia', style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Sinopsis:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  sinopsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        final role = mainController.role.value;

        if (role == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (role == 'admin') {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyButton(
                  onPressed: () {
                    Get.toNamed('/book-management', arguments: {
                      'book': data,
                      'from': 'detail',
                    });
                  },
                  color: Colors.orange,
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                MyButton(
                  onPressed: () => debugPrint('Hapus ditekan untuk buku: $title'),
                  color: Colors.red,
                  child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyButton(
                  onPressed: () => debugPrint('Pinjam ditekan untuk buku: $title'),
                  color: ColorConstant.greenColor,
                  child: const Text('Pinjam', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                MyButton(
                  onPressed: () => debugPrint('Booking ditekan untuk buku: $title'),
                  color: Colors.blue,
                  child: const Text('Booking', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
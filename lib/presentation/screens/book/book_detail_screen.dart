import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/controllers/transaction_controller.dart';
import 'package:libra_scan/presentation/widgets/button.dart';

import '../../../data/share_preference.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/main_controller.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final bookController = Get.put(BookController());
  final transactionController = Get.put(TransactionController());
  final mainController = Get.find<MainScreenController>();

  String userId = '';
  bool isCheckingData = true;
  Map<String, dynamic>? data;
  int quantity = 1;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _checkArguments();
    quantityController = TextEditingController(text: quantity.toString());
  }

  Future<void> _loadUserId() async {
    final userData = await LocalStorage.getUserData();
    setState(() {
      userId = userData['user_id'] ?? '';
    });
  }

  Future<void> _checkArguments() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      data = Get.arguments as Map<String, dynamic>?;
      isCheckingData = false;
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    if (isCheckingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Data buku tidak tersedia')),
      );
    }

    final String title = data['title'] ?? 'Judul Tidak Diketahui';
    final String isbn = data['isbn'] ?? '-';
    final String author = data['author'] ?? '-';
    final categoriseRef = data['category_id'] as DocumentReference?;
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
                        future: categoriseRef?.get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Memuat kategori...');
                          }
                          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                            return const Text('Kategori tidak ditemukan');
                          }

                          final kategoriData = snapshot.data!.data() as Map<String, dynamic>?;
                          final categoryId = snapshot.data!.id;

                          return Text(
                            '$categoryId - ${kategoriData?['genre'] ?? 'Tidak Diketahui'}',
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

        if (role == null || userId.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (role == 'admin') {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MyButton(
              onPressed: () async {
                final result = await Get.toNamed('/book-management', arguments: {
                  'book': data,
                  'from': 'detail',
                });
                if (result == true) {
                  bookController.fetchBooks();
                }
              },
              color: Colors.green,
              child: const Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                            quantityController.text = quantity.toString();
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final intVal = int.tryParse(value);
                          if (intVal != null && intVal > 0) {
                            setState(() {
                              quantity = intVal.clamp(1, stock < 3 ? stock : 3);
                              quantityController.text = quantity.toString();
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (quantity < 3 && quantity < stock) {
                          setState(() {
                            quantity++;
                            quantityController.text = quantity.toString();
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                MyButton(
                  onPressed: () {
                    transactionController.submitTransaction(
                      userId: userId,
                      book: data!,
                      quantity: quantity,
                    );
                  },
                  color: ColorConstant.greenColor,
                  child: const Text('Ingin Pinjam', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../../data/share_preference.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../widgets/button.dart';

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
      return Center(
        child: CircularProgressIndicator(
          color: ColorConstant.primaryColor(context),
        ),
      );
    }

    if (data == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Data buku tidak tersedia',
            style: TextStyle(color: ColorConstant.fontColor(context)),
          ),
        ),
      );
    }

    final String title = data['title'] ?? 'Judul Tidak Diketahui';
    final String isbn = data['isbn'] ?? '-';
    final String author = data['author'] ?? '-';
    final categoriseRef = data['category_id'] as DocumentReference?;
    final int stock = data['stock'] ?? 0;
    final String sinopsis = data['synopsis'] ?? 'Sinopsis tidak tersedia.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.local_mall),
            onPressed: () {
              Get.toNamed('/transaction-user');
            },
            tooltip: 'Transaksi Saya',
          ),
        ],
      ),
      backgroundColor: ColorConstant.backgroundColor(context),
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
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: ColorConstant.fontColor(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                      const SizedBox(height: 4),
                      Text(
                        'ISBN $isbn',
                        style: TextStyle(
                          color: ColorConstant.fontColor(
                            context,
                          ).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        author,
                        style: TextStyle(
                          color: ColorConstant.fontColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<DocumentSnapshot>(
                        future: categoriseRef?.get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              'Memuat kategori...',
                              style: TextStyle(
                                color: ColorConstant.fontColor(context),
                              ),
                            );
                          }
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Text(
                              'Kategori tidak ditemukan',
                              style: TextStyle(
                                color: ColorConstant.fontColor(context),
                              ),
                            );
                          }

                          final kategoriData =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          final categoryId = snapshot.data!.id;

                          return Text(
                            '$categoryId - ${kategoriData?['genre'] ?? 'Tidak Diketahui'}',
                            style: TextStyle(
                              color: ColorConstant.fontColor(context),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$stock Stok Tersedia',
                        style: TextStyle(
                          color: ColorConstant.fontColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Sinopsis:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstant.fontColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  sinopsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConstant.fontColor(context),
                  ),
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
                final result = await Get.toNamed(
                  '/book-management',
                  arguments: {'book': data, 'from': 'detail'},
                );
                if (result == true) {
                  bookController.fetchBooks();
                }
              },
              backgroundColor: ColorConstant.primaryColor(context),
              foregroundColor: ColorConstant.backgroundColor(context),
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
                      icon: Icon(
                        Icons.remove,
                        color: ColorConstant.fontColor(context),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: ColorConstant.fontColor(context),
                        ),
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
                      icon: Icon(
                        Icons.add,
                        color: ColorConstant.fontColor(context),
                      ),
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
                  backgroundColor: ColorConstant.primaryColor(context),
                  foregroundColor: ColorConstant.backgroundColor(context),
                  child: const Text(
                    'Masukkan ke Keranjang',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

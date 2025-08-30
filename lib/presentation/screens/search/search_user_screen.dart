import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/book_card.dart';

import '../../../common/constants/color_constans.dart';
import '../../../data/share_preference.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/transaction_controller.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchUserScreen> {
  final controller = Get.put(BookController());
  final transactionController = Get.put(TransactionController());
  final mainController = Get.find<MainScreenController>();
  final TextEditingController _searchController = TextEditingController();

  String userId = '';
  String? transactionData;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    controller.fetchBooks();
    _searchController.addListener(() {
      controller.searchBooks(_searchController.text.trim());
    });
  }

  Future<void> _loadUserId() async {
    final userData = await LocalStorage.getUserData();
    final id = userData['user_id'] ?? '';

    final transaction = await transactionController.fetchTransaction(id);

    setState(() {
      userId = id;
      transactionData = transaction?['transaction_id'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = mainController.role.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Buku"),
        centerTitle: true,
        actions: [
          if (role == 'anggota') ...[
            IconButton(
              icon: const Icon(Icons.local_mall),
              onPressed: () {
                Get.toNamed('/transaction-user', arguments: {
                  'transaction_id': transactionData,
                });
              },
              tooltip: 'Transaksi Saya',
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              cursorColor: ColorConstant.primaryColor(context),
              decoration: InputDecoration(
                hintText: 'Mencari Buku Apa?',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: ColorConstant.backgroundColor(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConstant.primaryColor(context),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final books = controller.filteredBooks;

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchBooks();
                },
                color: ColorConstant.primaryColor(context),
                child: books.isEmpty
                    ? ListView(
                  children: [
                    SizedBox(height: 100),
                    Center(
                      child: Text(
                        'Tidak ada buku ditemukan.',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConstant.fontColor(context),
                        ),
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: BookCard(
                        title: book['title'],
                        author: book['author'],
                        onTap: () {
                          Get.toNamed('/book-detail', arguments: book);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

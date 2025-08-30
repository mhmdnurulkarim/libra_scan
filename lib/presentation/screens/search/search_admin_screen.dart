import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/book_controller.dart';
import '../../widgets/book_card.dart';

class SearchAdminScreen extends StatefulWidget {
  const SearchAdminScreen({super.key});

  @override
  State<SearchAdminScreen> createState() => _SearchAdminScreenState();
}

class _SearchAdminScreenState extends State<SearchAdminScreen> {
  final controller = Get.put(BookController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchBooks();
    _searchController.addListener(() {
      controller.searchBooks(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Buku"),
        centerTitle: true,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstant.primaryColor(context),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Get.toNamed(
            '/book-management',
            arguments: {'from': 'search'},
          );
          if (result == true) {
            await controller.fetchBooks();
          }
        },
      ),
    );
  }
}

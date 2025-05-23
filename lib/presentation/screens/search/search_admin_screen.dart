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
      appBar: AppBar(title: const Text('Cari Buku')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Mencari Buku Apa?',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3EFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final books = controller.filteredBooks;

              if (books.isEmpty) {
                return const Center(child: Text('Tidak ada buku ditemukan.'));
              }

              return ListView.builder(
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
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstant.whiteColor,
        child: Icon(Icons.add, color: ColorConstant.blackColor),
        onPressed: () async {
          final result = await Get.toNamed('/book-management', arguments: {
            'from': 'search',
          });
          if (result == true) {
            controller.fetchBooks();
          }
        },
      ),
    );
  }
}

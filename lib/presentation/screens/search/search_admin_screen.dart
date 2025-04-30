import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAdminScreen extends StatefulWidget {
  const SearchAdminScreen({super.key});

  @override
  State<SearchAdminScreen> createState() => _SearchAdminScreenState();
}

class _SearchAdminScreenState extends State<SearchAdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> dummyBooks =
      List.generate(10, (index) => 'Judul Buku $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Buku'),
      ),
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
            child: ListView.builder(
              itemCount: dummyBooks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F0FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image),
                      ),
                      title: Text(dummyBooks[index]),
                      subtitle: const Text('Penulis Buku'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.toNamed('/book-detail');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF3EFFF),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Get.toNamed('/book-management');
        },
      ),
    );
  }
}

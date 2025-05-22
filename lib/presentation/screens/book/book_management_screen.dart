import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/book_controller.dart';
import '../../widgets/snackbar.dart';

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  final controller = Get.put(BookController());
  Map<String, dynamic>? bookData;
  String? bookDocId;
  bool isFromSearch = false;

  final titleController = TextEditingController();
  final isbnController = TextEditingController();
  final authorController = TextEditingController();
  final categoryController = TextEditingController();
  final barcodeController = TextEditingController();
  final stockController = TextEditingController();
  final synopsisController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('book')) {
        bookData = args['book'];
        bookDocId = bookData?['id']; // ambil ID dokumen
      }
      if (args['from'] == 'search') {
        isFromSearch = true;
      }
    }

    if (bookData != null) {
      titleController.text = bookData?['title'] ?? '';
      isbnController.text = bookData?['isbn'] ?? '';
      authorController.text = bookData?['author'] ?? '';
      categoryController.text = bookData?['category_id'] ?? '';
      barcodeController.text = bookData?['barcode'] ?? '';
      stockController.text = bookData?['stock']?.toString() ?? '';
      synopsisController.text = bookData?['synopsis'] ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    isbnController.dispose();
    authorController.dispose();
    categoryController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    synopsisController.dispose();
    super.dispose();
  }

  void _submitBook() async {
    if (titleController.text.isEmpty ||
        isbnController.text.isEmpty ||
        authorController.text.isEmpty ||
        categoryController.text.isEmpty ||
        barcodeController.text.isEmpty ||
        stockController.text.isEmpty) {
      MySnackBar.show(
        title: 'Validasi Gagal',
        message: 'Semua field wajib diisi kecuali sinopsis.',
        bgColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    final book = {
      'title': titleController.text,
      'isbn': isbnController.text,
      'author': authorController.text,
      'category_id': categoryController.text,
      'barcode': barcodeController.text,
      'stock': int.tryParse(stockController.text) ?? 0,
      'synopsis': synopsisController.text,
    };

    if (bookDocId != null) {
      await controller.updateBook(bookDocId!, book);
    } else {
      controller.addBook(book);
    }
  }

  void _deleteBook() async {
    final confirm = await Get.defaultDialog<bool>(
      title: "Konfirmasi",
      middleText: "Yakin ingin menghapus buku ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm == true && bookDocId != null) {
      await controller.deleteBook(bookDocId!);
      Get.back(); // kembali ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Buku')),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  label: "Judul *",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: titleController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "ISBN *",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: isbnController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Penulis *",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: authorController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Kategori *",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: categoryController,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyTextField(
                        label: "Barcode *",
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        controller: barcodeController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.greenColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Get.toNamed(
                          '/scanner',
                          arguments: {'from': 'management'},
                        );
                        if (result != null && result is String) {
                          barcodeController.text = result;
                        }
                      },
                      child: Text(
                        'Scan Barcode',
                        style: TextStyle(color: ColorConstant.whiteColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Stok Buku *",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  controller: stockController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Sinopsis",
                  obscureText: false,
                  keyboardType: TextInputType.multiline,
                  controller: synopsisController,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                MyButton(
                  onPressed: _submitBook,
                  color: ColorConstant.greenColor,
                  child: Text(
                    bookData != null ? 'Edit' : 'Tambah',
                    style: TextStyle(color: ColorConstant.whiteColor),
                  ),
                ),
                const SizedBox(height: 12),
                if (bookData != null && !isFromSearch)
                  MyButton(
                    onPressed: _deleteBook,
                    color: ColorConstant.redColor,
                    child: Text(
                      'Hapus',
                      style: TextStyle(color: ColorConstant.whiteColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/book_controller.dart';

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  final controller = Get.put(BookController());

  final titleController = TextEditingController();
  final isbnController = TextEditingController();
  final authorController = TextEditingController();
  final categoryController = TextEditingController();
  final barcodeController = TextEditingController();
  final stockController = TextEditingController();
  final synopsisController = TextEditingController();

  @override
  void dispose() {
    // Bersihkan semua controller saat screen dihapus
    titleController.dispose();
    isbnController.dispose();
    authorController.dispose();
    categoryController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    synopsisController.dispose();
    super.dispose();
  }

  void _submitBook() {
    final book = {
      'title': titleController.text,
      'isbn': isbnController.text,
      'author': authorController.text,
      'category_id': categoryController.text,
      'barcode': barcodeController.text,
      'stock': int.tryParse(stockController.text) ?? 0,
      'synopsis': synopsisController.text,
    };

    controller.addBook(book);
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
                  label: "Judul",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: titleController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "ISBN",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: isbnController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Penulis",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: authorController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Kategori",
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
                        label: "Barcode",
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
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.toNamed('/scanner'),
                      child: Text(
                        'Scan Barcode',
                        style: TextStyle(color: ColorConstant.whiteColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
                  label: "Stok Buku",
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
                    'Tambah',
                    style: TextStyle(color: ColorConstant.whiteColor),
                  ),
                ),
                const SizedBox(height: 12),
                MyButton(
                  onPressed: () {
                    // Tambahkan konfirmasi atau logika hapus
                  },
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final barcodeController = TextEditingController();
  final stockController = TextEditingController();
  final synopsisController = TextEditingController();

  List<DocumentSnapshot> categories = [];
  DocumentSnapshot? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('book')) {
        bookData = args['book'];
        bookDocId = bookData?['book_id'];
      }
      if (args['from'] == 'search') {
        isFromSearch = true;
      }
    }

    if (bookData != null) {
      titleController.text = bookData?['title'] ?? '';
      isbnController.text = bookData?['isbn'] ?? '';
      authorController.text = bookData?['author'] ?? '';
      barcodeController.text = bookData?['barcode'] ?? '';
      stockController.text = bookData?['stock']?.toString() ?? '';
      synopsisController.text = bookData?['synopsis'] ?? '';
    }
  }

  void _loadCategories() async {
    final selectedRef =
        (bookData != null && bookData!['category_id'] is DocumentReference)
            ? bookData!['category_id'] as DocumentReference
            : null;

    final snapshot = await controller.getAllCategories();
    final docs = snapshot.docs;

    DocumentSnapshot? selected;

    if (selectedRef != null) {
      for (var cat in docs) {
        if (cat.reference.path == selectedRef.path) {
          selected = cat;
          break;
        }
      }
    }

    setState(() {
      categories = docs;
      selectedCategory = selected ?? (docs.isNotEmpty ? docs.first : null);
    });
  }

  void _submitBook() async {
    if (titleController.text.isEmpty ||
        isbnController.text.isEmpty ||
        authorController.text.isEmpty ||
        selectedCategory == null ||
        barcodeController.text.isEmpty ||
        stockController.text.isEmpty) {
      MySnackBar.show(
        title: 'Validasi Gagal',
        message: 'Semua field wajib diisi kecuali sinopsis.',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error,
      );
      return;
    }

    final book = {
      'title': titleController.text,
      'isbn': isbnController.text,
      'author': authorController.text,
      'category_id': selectedCategory!.reference,
      'barcode': barcodeController.text,
      'stock': int.tryParse(stockController.text) ?? 0,
      'synopsis': synopsisController.text,
    };

    controller.submitBook(
      bookDocId: bookDocId,
      book: book,
      isEdit: bookDocId != null,
    );
  }

  void _deleteBook() {
    if (bookDocId != null) {
      controller.deleteBook(bookDocId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Buku'),
        centerTitle: true,
      ),
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
                DropdownButtonFormField<DocumentSnapshot>(
                  value:
                      categories.any(
                            (cat) =>
                                cat.reference.path ==
                                selectedCategory?.reference.path,
                          )
                          ? categories.firstWhere(
                            (cat) =>
                                cat.reference.path ==
                                selectedCategory?.reference.path,
                          )
                          : null,
                  items:
                      categories.map((category) {
                        final id = category.id;
                        final genre = category['genre'];
                        return DropdownMenuItem<DocumentSnapshot>(
                          value: category,
                          child: Text('$id - $genre'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori *',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
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
                        backgroundColor: ColorConstant.primaryColor(context),
                        foregroundColor: ColorConstant.backgroundColor(context),
                        minimumSize: const Size(8, 56),
                        side: BorderSide(color: ColorConstant.secondaryColor(context)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        style: TextStyle(
                          color: ColorConstant.backgroundColor(context),
                        ),
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
                  backgroundColor: ColorConstant.primaryColor(context),
                  child: Text(
                    bookData != null ? 'Edit' : 'Tambah',
                    style: TextStyle(
                      color: ColorConstant.backgroundColor(context),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (bookData != null && !isFromSearch)
                  MyButton(
                    onPressed: _deleteBook,
                    backgroundColor: ColorConstant.dangerColor(context),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        color: ColorConstant.backgroundColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    isbnController.dispose();
    authorController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    synopsisController.dispose();
    super.dispose();
  }
}

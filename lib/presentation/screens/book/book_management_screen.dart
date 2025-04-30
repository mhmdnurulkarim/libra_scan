import 'package:flutter/material.dart';

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController synopsisController = TextEditingController();

  void _scanBarcode() async {
    // logika scan barcode nanti kamu sambungin ke plugin barcode scanner
    setState(() {
      barcodeController.text = '1234567890'; // contoh hasil scan
    });
  }

  void _saveBook() {
    // logika untuk tambah atau edit buku
    debugPrint('Tambah/Edit Buku');
  }

  void _deleteBook() {
    // logika untuk hapus buku
    debugPrint('Hapus Buku');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Judul', titleController),
            _buildTextField('ISBN', isbnController),
            _buildTextField('Penulis', authorController),
            _buildTextField('Kategori', categoryController),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField('Barcode', barcodeController),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _scanBarcode,
                  child: const Text('Scan Barcode'),
                ),
              ],
            ),
            _buildTextField('Stok Buku', stockController, keyboardType: TextInputType.number),
            _buildTextField('Sinopsis', synopsisController, maxLines: 5),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Tambah/Edit'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

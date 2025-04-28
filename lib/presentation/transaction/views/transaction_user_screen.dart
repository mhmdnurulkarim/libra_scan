import 'package:flutter/material.dart';

class TransactionUserScreen extends StatelessWidget {
  const TransactionUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contoh data dummy
    final List<Map<String, String>> books = [
      {
        'title': 'Judul Buku',
        'author': 'Penulis Buku',
      },
      {
        'title': 'Judul Buku',
        'author': 'Penulis Buku',
      },
      {
        'title': 'Judul Buku',
        'author': 'Penulis Buku',
      },
    ];
    final String returnDate = '24 April 2025';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...books.map((book) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.purple.shade50,
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                  title: Text(book['title']!),
                  subtitle: Text(book['author']!),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // bisa diarahkan ke detail buku
                  },
                ),
              ),
            )),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Harus dikembalikan pada $returnDate',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // logika pinjam / booking / kembali
            debugPrint('Pinjam/Booking/Kembali ditekan');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Pinjam/Booking/Kembali'),
        ),
      ),
    );
  }
}

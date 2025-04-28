import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contoh data dummy
    final String title = 'Alpha Girls';
    final String isbn = 'xxxx-xxxx-xxx';
    final String author = 'Hendri Manampiring';
    final String category = 'Self & Improvement';
    final int stock = 14;
    final String synopsis = '''
Excepteur efficient emerging, minim veniam anim aute carefully curated Ginza conversation exquisite perfect nostrud nisi intricate Content. 
Qui international first-class nulla ut. Punctual adipisicing, essential lovely queen tempor eiusmod irure. Exclusive izakaya charming Scandinavian impeccable aute quality of life soft power pariatur Melbourne occaecat discerning. 
Qui wardrobe aliquip, et Porter destination Toto remarkable officia Helsinki excepteur Basset hound. Zürich sleepy perfect consectetur.
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
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
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('ISBN $isbn', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 4),
                      Text(author, style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(category, style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('$stock Stok Tersedia', style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Sinopsis:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  synopsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // logika pinjam/booking/kembali
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

import 'package:flutter/material.dart';

class TransactionAdminScreen extends StatelessWidget {
  const TransactionAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMemberCard(),
            const SizedBox(height: 16),
            _buildBookList(),
            const SizedBox(height: 24),
            const Text(
              'Denda masih 3 Hari lagi\nHingga tanggal 27 April 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('12345679034395', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Muhammad Nurul Karim'),
                    Text('abc@gmail.com'),
                    Text('085769143295'),
                    Text('Anggota'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
            child: Center(child: Text('Barcode Image')),
          ),
          const SizedBox(height: 4),
          const Text('24110900009', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return Column(
      children: List.generate(3, (index) => _buildBookItem()),
    );
  }

  Widget _buildBookItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: const Icon(Icons.book),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Judul Buku', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Penulis Buku'),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Pinjam/Tolak/Kembali',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

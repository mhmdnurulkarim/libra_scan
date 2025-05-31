import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/controllers/transaction_controller.dart';

import '../../../common/constants/color_constans.dart';
import '../../widgets/button.dart';

class TransactionAdminScreen extends StatefulWidget {
  const TransactionAdminScreen({super.key});

  @override
  State<TransactionAdminScreen> createState() => _TransactionAdminScreenState();
}

class _TransactionAdminScreenState extends State<TransactionAdminScreen> {
  final controller = Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    final transactionId = Get.arguments['transactionId'];
    controller.loadTransactionData(transactionId, isAdmin: true);
  }

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
        child: Obx(() => Column(
          children: [
            _buildMemberCard(),
            const SizedBox(height: 16),
            _buildBookList(),
            const SizedBox(height: 24),
            const Text(
              'Denda masih 3 Hari lagi\nHingga tanggal 27 April 2025',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            _buildActionButton(),
          ],
        )),
      ),
    );
  }

  Widget _buildMemberCard() {
    final member = controller.memberData;

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
                  children: [
                    Text(member['nin'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(member['name'] ?? ''),
                    Text(member['email'] ?? ''),
                    Text(member['phone_number'] ?? ''),
                    const Text('Anggota'),
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
            child: const Center(child: Text('Barcode Image')),
          ),
          const SizedBox(height: 4),
          Text(member['barcode'] ?? '',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return Column(
      children: controller.bookList.map((book) {
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
                  children: [
                    Text(book['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(book['author'] ?? ''),
                    Text("Status: ${book['status']}"),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      if (controller.bookList.isEmpty) return const SizedBox();

      String buttonText = '';
      VoidCallback? action;

      if (controller.allReturned) {
        return const Text(
          'Semua buku telah dikembalikan.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
      } else if (controller.allBorrowed) {
        buttonText = 'Kembalikan Buku';
        action = controller.returnBooks;
      } else {
        buttonText = 'Setujui Transaksi';
        action = controller.approveTransaction;
      }

      return SizedBox(
        width: double.infinity,
        child: MyButton(
          onPressed: action,
          color: ColorConstant.greenColor,
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
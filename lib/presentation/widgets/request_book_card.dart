import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestBookCard extends StatelessWidget {
  final String name;
  final String? email;
  final Timestamp? date;
  final int books;
  final VoidCallback? onTap;

  const RequestBookCard({
    super.key,
    required this.name,
    this.email,
    this.date,
    required this.books,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 48,
            height: 48,
            color: Colors.grey[400],
            child: const Icon(Icons.image, color: Colors.white),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email != null)
              Text(
                email!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            if (date != null)
              Text(
                _formatDate(date!),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$books',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Buku',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
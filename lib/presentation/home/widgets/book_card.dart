import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          color: Colors.grey[400],
          child: const Icon(Icons.book, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(author),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

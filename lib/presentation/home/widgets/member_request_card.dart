import 'package:flutter/material.dart';

class MemberRequestCard extends StatelessWidget {
  final String name;
  final String id;
  final int books;

  const MemberRequestCard({
    super.key,
    required this.name,
    required this.id,
    required this.books,
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
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(id),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$books'),
            const Text('Buku', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

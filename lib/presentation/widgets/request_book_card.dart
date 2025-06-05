import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../common/constants/color_constans.dart';

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
    final primary = ColorConstant.primaryColor(context);
    final font = ColorConstant.fontColor(context);

    return Container(
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
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
            child: Icon(Icons.image, color: ColorConstant.fontColor(context)),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: font,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email != null)
              Text(
                email!,
                style: TextStyle(
                  fontSize: 12,
                  color: font.withOpacity(0.7),
                ),
              ),
            if (date != null)
              Text(
                _formatDate(date!),
                style: TextStyle(
                  fontSize: 12,
                  color: font.withOpacity(0.7),
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$books',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: font,
              ),
            ),
            Text(
              'Buku',
              style: TextStyle(fontSize: 12, color: font.withOpacity(0.7)),
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
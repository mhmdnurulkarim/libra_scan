import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../common/constants/color_constans.dart';
import '../../utils/utils.dart';

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
    final backgroundColor = ColorConstant.primaryColor(context);
    final fontColor = Colors.white;
    final borderColor = ColorConstant.secondaryColor(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: ColorConstant.secondaryColor(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: fontColor),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600, color: fontColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email != null)
              Text(email!, style: TextStyle(fontSize: 12, color: fontColor)),
            if (date != null)
              Text(
                formatDate(date!),
                style: TextStyle(fontSize: 12, color: fontColor),
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
                color: fontColor,
              ),
            ),
            Text('Buku', style: TextStyle(fontSize: 12, color: fontColor)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

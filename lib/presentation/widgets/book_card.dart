import 'package:flutter/material.dart';
import '../../common/constants/color_constans.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.onTap,
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
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: fontColor,
          ),
        ),
        subtitle: Text(
          author,
          style: TextStyle(
            fontSize: 12,
            color: fontColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: fontColor),
        onTap: onTap,
      ),
    );
  }
}
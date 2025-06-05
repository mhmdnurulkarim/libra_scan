import 'package:flutter/material.dart';
import '../../common/constants/color_constans.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorConstant.primaryColor(context);
    final fontColor = ColorConstant.backgroundColor(context);
    final borderColor = ColorConstant.secondaryColor(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: fontColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: fontColor.withOpacity(0.8)),
        onTap: onTap,
      ),
    );
  }
}
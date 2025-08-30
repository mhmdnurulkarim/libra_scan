import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnackBar {
  static void show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color fontColor,
    IconData? icon,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(icon ?? Icons.info, color: fontColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: TextStyle(color: fontColor),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      padding: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      shouldIconPulse: true,
    );
  }
}

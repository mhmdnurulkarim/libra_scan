import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnackBar {
  static void show({
    required String title,
    required String message,
    required Color bgColor,
    IconData? icon,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(icon ?? Icons.info, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
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

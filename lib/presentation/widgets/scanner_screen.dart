import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import 'snackbar.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;
          if (code != null) {
            MySnackBar.show(
              title: 'Barcode Terdeteksi',
              message: code,
              bgColor: Colors.green,
              icon: Icons.check,
            );
            Get.toNamed('/book-detail');
          }
        },
      ),
    );
  }
}

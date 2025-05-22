import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import 'snackbar.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (isScanned) return; // hanya ambil satu kali
          isScanned = true;

          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (code != null) {
            await controller.stop(); // stop camera agar tidak terus scan

            // Cek asal halaman
            final from = Get.arguments?['from'];
            if (from == 'management') {
              Get.back(result: code); // kirim balik hasil barcode
            } else {
              Get.offNamed('/book-detail', arguments: {'barcode': code});
            }

            MySnackBar.show(
              title: 'Barcode Terdeteksi',
              message: code,
              bgColor: Colors.green,
              icon: Icons.check,
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

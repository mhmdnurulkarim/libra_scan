import 'package:flutter/material.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/snackbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final bookController = Get.put(BookController());
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (isScanned) return;
          isScanned = true;

          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (code != null) {
            await controller.stop();

            final from = Get.arguments?['from'];
            if (from == 'management') {
              Get.back(result: code);
            } else {
              final bookData = await bookController.getBook(code);

              if (bookData != null) {
                if (mounted) {
                  Get.offNamed('/book-detail', arguments: bookData);
                }
              } else {
                if (mounted) {
                  Get.back();

                  MySnackBar.show(
                    title: 'Buku Tidak Ditemukan',
                    message: 'Buku dengan barcode ini tidak ditemukan.',
                    backgroundColor: ColorConstant.dangerColor(context),
                    fontColor: Colors.white,
                    icon: Icons.close,
                  );
                }
              }
            }
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

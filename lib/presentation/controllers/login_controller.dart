import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan kata sandi wajib diisi',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // Simulasi request login
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi validasi login
      if (emailController.text == "123" && passwordController.text == "123") {
        Get.snackbar('Sukses', 'Berhasil masuk!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/main');
      } else {
        Get.snackbar('Error', 'Email atau kata sandi salah',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan server',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

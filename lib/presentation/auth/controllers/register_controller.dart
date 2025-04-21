import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nikController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;

  void register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nikController.text.isEmpty ||
        nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // Simulasi request register
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi berhasil register
      Get.snackbar('Sukses', 'Pendaftaran berhasil!',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Balik ke login
      await Future.delayed(const Duration(seconds: 1));
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan server',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

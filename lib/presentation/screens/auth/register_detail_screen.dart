import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/text_field.dart';
import '../../widgets/button.dart';

class RegisterDetailScreen extends StatelessWidget {
  const RegisterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      authController.emailController.text = args['email'] ?? '';
      authController.userId = args['user_id'];
      authController.isFromGoogle = true;
    }

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor(context),
      appBar: AppBar(
        title: const Text('Daftar ke LibraScan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            MyTextField(
              label: 'Email',
              controller: authController.emailController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Password',
              controller: authController.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              showPasswordToggle: true,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'NIK',
              controller: authController.ninController,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Nama Lengkap',
              controller: authController.nameController,
              obscureText: false,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Alamat',
              controller: authController.addressController,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Nomor HP',
              controller: authController.phoneController,
              obscureText: false,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            Obx(
                  () => MyButton(
                onPressed: authController.isLoading.value
                    ? null
                    : authController.isFromGoogle
                    ? authController.registerWithGoogle
                    : authController.registerWithEmail,
                backgroundColor: ColorConstant.primaryColor(context),
                foregroundColor: ColorConstant.backgroundColor(context),
                child: authController.isLoading.value
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

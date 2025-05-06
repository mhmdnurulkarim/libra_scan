import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color_constans.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/text_field.dart';
import '../../widgets/button.dart';

class RegisterDetailScreen extends StatelessWidget {
  const RegisterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      controller.emailController.text = args['email'] ?? '';
      controller.userId = args['user_id'];
      controller.isFromGoogle = true;
    }

    return Scaffold(
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
              controller: controller.emailController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Password',
              controller: controller.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              showPasswordToggle: true,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'NIK',
              controller: controller.nikController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Nama Lengkap',
              controller: controller.nameController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Alamat',
              controller: controller.addressController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Nomor HP',
              controller: controller.phoneController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            Obx(
              () => MyButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : controller.isFromGoogle
                        ? controller.registerWithGoogle
                        : controller.registerWithEmail,
                color: ColorConstant.buttonColor,
                child:
                    controller.isLoading.value
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
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

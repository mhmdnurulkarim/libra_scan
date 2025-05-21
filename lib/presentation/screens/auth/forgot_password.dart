import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';
import 'package:libra_scan/common/constants/color_constans.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Masukkan email untuk reset Password."),
            const SizedBox(height: 16),
            MyTextField(
              label: "Email",
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
            const SizedBox(height: 24),
            Obx(
              () => MyButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : controller.forgotPassword,
                color: ColorConstant.buttonColor,
                child:
                    controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Kirim Link Reset",
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

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
    final authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor(context),
      appBar: AppBar(
        title: const Text("Lupa Kata Sandi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Masukkan email untuk reset Password.",
              style: TextStyle(color: ColorConstant.fontColor(context)),
            ),
            const SizedBox(height: 16),
            MyTextField(
              label: "Email",
              controller: authController.emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
            const SizedBox(height: 24),
            Obx(
                  () => MyButton(
                onPressed: authController.isLoading.value
                    ? null
                    : authController.forgotPassword,
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

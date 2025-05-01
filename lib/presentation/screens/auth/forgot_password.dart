import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';

import '../../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotController = Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Masukkan email untuk reset Password."),
            const SizedBox(height: 16),
            TxtFormField(
              label: "Email",
              controller: forgotController.emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed:
                    forgotController.isLoading.value
                        ? null
                        : forgotController.sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    forgotController.isLoading.value
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

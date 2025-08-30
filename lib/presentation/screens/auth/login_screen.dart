import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masuk ke LibraScan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.fontColor(context),
                  ),
                ),
                const SizedBox(height: 24),

                // Login dengan Google
                ElevatedButton.icon(
                  onPressed: authController.loginWithGoogle,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorConstant.primaryColor(context),
                    backgroundColor: ColorConstant.backgroundColor(context),
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: ColorConstant.secondaryColor(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text("Masuk dengan Google"),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "atau masuk dengan email",
                    style: TextStyle(color: ColorConstant.fontColor(context)),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                MyTextField(
                  label: "Email",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(height: 12),

                // Password
                MyTextField(
                  label: "Password",
                  controller: authController.passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  showPasswordToggle: true,
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/forgot-password');
                    },
                    child: Text(
                      "Lupa kata sandi?",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstant.primaryColor(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Tombol Login
                Obx(
                      () => MyButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : authController.loginWithEmail,
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
                      "Masuk",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Navigasi ke Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: TextStyle(color: ColorConstant.fontColor(context)),
                    ),
                    GestureDetector(
                      onTap: () => Get.offNamed('/register'),
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorConstant.primaryColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';

import '../../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Masuk ke LibraScan",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Login dengan Google
                ElevatedButton.icon(
                  onPressed: () async {
                    final user = await loginController.loginWithGoogle();
                    if (user != null) {
                      Get.offAllNamed('/main');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text("Masuk dengan Google"),
                ),
                const SizedBox(height: 16),
                const Center(child: Text("atau masuk dengan email")),
                const SizedBox(height: 16),

                // Email
                TxtFormField(
                  label: "Email",
                  controller: loginController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(height: 12),

                // Password
                TxtFormField(
                  label: "Password",
                  controller: loginController.passwordController,
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
                    child: const Text(
                      "Lupa kata sandi?",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Tombol Login
                Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      final email = loginController.emailController.text.trim();
                      final password =
                          loginController.passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar(
                          'Validasi Gagal',
                          'Email dan kata sandi wajib diisi',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      final user = await loginController.loginWithEmail();
                      if (user != null) {
                        Get.offAllNamed('/main');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        loginController.isLoading.value
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
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
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed('/register');
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(decoration: TextDecoration.underline),
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

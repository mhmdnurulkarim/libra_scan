import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Masuk ke LibraScan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: loginController.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: loginController.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Kata Sandi'),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: loginController.isLoading.value ? null : loginController.login,
              child: loginController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Masuk'),
            )),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Get.toNamed('/register');
              },
              child: const Text('Belum punya akun? Daftar', style: TextStyle(decoration: TextDecoration.underline)),
            )
          ],
        ),
      ),
    );
  }
}

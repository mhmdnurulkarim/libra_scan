import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/text_field.dart';
import '../../controllers/register_controller.dart';

class RegisterDetailScreen extends StatelessWidget {
  const RegisterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerController = Get.put(RegisterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar ke LibraScan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            TxtFormField(
              label: 'Email',
              controller: registerController.emailController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TxtFormField(
              label: 'Password',
              controller: registerController.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              showPasswordToggle: true,
            ),
            const SizedBox(height: 16),
            TxtFormField(
              label: 'NIK',
              controller: registerController.nikController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TxtFormField(
              label: 'Nama Lengkap',
              controller: registerController.nameController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TxtFormField(
              label: 'Alamat',
              controller: registerController.addressController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TxtFormField(
              label: 'Nomor HP',
              controller: registerController.phoneController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                onPressed:
                    registerController.isLoading.value
                        ? null
                        : registerController.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    registerController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
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

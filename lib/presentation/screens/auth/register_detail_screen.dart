import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            _buildTextField('Email', controller: registerController.emailController),
            const SizedBox(height: 16),
            _buildTextField('Kata Sandi', controller: registerController.passwordController, obscureText: true),
            const SizedBox(height: 16),
            _buildTextField('NIK', controller: registerController.nikController),
            const SizedBox(height: 16),
            _buildTextField('Nama Lengkap', controller: registerController.nameController),
            const SizedBox(height: 16),
            _buildTextField('Alamat', controller: registerController.addressController),
            const SizedBox(height: 16),
            _buildTextField('Nomor HP', controller: registerController.phoneController),
            const SizedBox(height: 32),
            Obx(() => ElevatedButton(
              onPressed: registerController.isLoading.value ? null : registerController.register,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(50)),
              child: registerController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Daftar'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

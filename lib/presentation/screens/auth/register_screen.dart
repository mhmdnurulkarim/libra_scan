import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Daftar ke LibraScan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstant.fontColor(context),
              ),
            ),
            const SizedBox(height: 24),
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
              label: const Text('Masuk dengan Google'),
            ),
            const SizedBox(height: 16),
            Text(
              'atau',
              style: TextStyle(color: ColorConstant.fontColor(context)),
            ),
            const SizedBox(height: 16),
            MyButton(
              onPressed: () => Get.toNamed('/register-detail'),
              backgroundColor: ColorConstant.primaryColor(context),
              foregroundColor: ColorConstant.backgroundColor(context),
              child: const Text(
                "Lanjutkan dengan email",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: TextStyle(color: ColorConstant.fontColor(context)),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed('/login');
                  },
                  child: Text(
                    'Masuk',
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
    );
  }
}

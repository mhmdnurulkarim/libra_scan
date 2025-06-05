import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/item_card.dart';
import 'package:libra_scan/presentation/widgets/member_card.dart';

import '../../../common/constants/color_constans.dart';
import '../../../data/share_preference.dart';
import '../../../utils/locale_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/button.dart';
import '../../widgets/snackbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final localeController = Get.find<LocaleController>();

    return FutureBuilder<Map<String, String>>(
      future: LocalStorage.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor(context),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(
              child: Text(
                'Data akun tidak tersedia',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstant.fontColor(context),
                ),
              ),
            ),
          );
        }

        final userData = snapshot.data!;
        final String userId = userData['user_id'] ?? '-';
        final String nin = userData['nin'] ?? '-';
        final String name = userData['name'] ?? '-';
        final String email = userData['email'] ?? '-';
        final String phoneNumber = userData['phone_number'] ?? '-';
        final String role = userData['role_id']?.toLowerCase() ?? 'anggota';
        final barcode = userData['barcode'] ?? '';

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Kartu profil
                MemberCard(
                  userId: userId,
                  nin: nin,
                  name: name,
                  email: email,
                  phoneNumber: phoneNumber,
                  role: role,
                  barcode: barcode,
                ),
                const SizedBox(height: 16),

                // Pengaturan
                ItemCard(
                  title: 'Bahasa Indonesia',
                  onTap: () {
                    MySnackBar.show(
                      title: 'Dalam Pengembangan',
                      message: 'Fitur ini sedang dalam pengembangan',
                      backgroundColor: Colors.orange,
                      fontColor: Colors.white,
                      icon: Icons.warning_amber_rounded,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorConstant.secondaryColor(context),
                      ),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        'Tema Gelap',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      value: localeController.themeMode.value == ThemeMode.dark,
                      onChanged: (val) {
                        localeController.toggleTheme(val);
                      },
                      activeColor: ColorConstant.secondaryColor(context),
                      activeTrackColor: Colors.white60,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ItemCard(
                  title: 'Laporan',
                  onTap: () {
                    MySnackBar.show(
                      title: 'Dalam Pengembangan',
                      message: 'Fitur ini sedang dalam pengembangan',
                      backgroundColor: Colors.orange,
                      fontColor: Colors.white,
                      icon: Icons.warning_amber_rounded,
                    );
                    // Get.toNamed("/report");
                  },
                ),
                const SizedBox(height: 16),
                ItemCard(
                  title: 'Tentang Developer',
                  onTap: () {
                    MySnackBar.show(
                      title: 'Dalam Pengembangan',
                      message: 'Fitur ini sedang dalam pengembangan',
                      backgroundColor: Colors.orange,
                      fontColor: Colors.white,
                      icon: Icons.warning_amber_rounded,
                    );
                    // Get.toNamed("/about");
                  },
                ),
                const SizedBox(height: 16),
                // Tombol keluar
                Obx(
                  () => MyButton(
                    onPressed: () => authController.logout(),
                    backgroundColor: ColorConstant.dangerColor(context),
                    borderColor: Colors.redAccent,
                    child:
                        authController.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Keluar",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

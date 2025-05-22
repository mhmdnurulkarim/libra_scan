import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/button.dart';

import '../../../data/share_preference.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return FutureBuilder<Map<String, String>>(
      future: LocalStorage.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Data akun tidak tersedia')),
          );
        }

        final userData = snapshot.data!;
        final String userId = userData['user_id'] ?? '-';
        final String nin = userData['nin'] ?? '-';
        final String name = userData['name'] ?? '-';
        final String email = userData['email'] ?? '-';
        final String phoneNumber = userData['phone_number'] ?? '-';
        final String role = userData['role_id']?.toLowerCase() ?? 'anggota';

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Kartu profil
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person, size: 48),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nin),
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(email),
                            Text(phoneNumber),
                            Text(role),
                            const SizedBox(height: 12),
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                    child:
                                        Placeholder(), // bisa ganti dengan barcode widget
                                  ),
                                  const SizedBox(height: 4),
                                  Text(userId),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pengaturan
                settingItem('Bahasa Indonesia', onTap: () {}),
                SwitchListTile(
                  title: const Text('Tema Gelap'),
                  value: false,
                  onChanged: (val) {
                    // Tambahkan logika dark mode
                  },
                ),
                settingItem('Laporan', onTap: () {}),
                settingItem('Tentang Developer', onTap: () {}),

                const SizedBox(height: 20),

                // Tombol keluar
                Obx(
                  () => MyButton(
                    onPressed: () => authController.logout(),
                    color: ColorConstant.redColor,
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

  Widget settingItem(String title, {required VoidCallback onTap}) {
    return ListTile(
      tileColor: Colors.pink.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

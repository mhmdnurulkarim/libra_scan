import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:libra_scan/utils/color_constans.dart';

import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    bool isDarkMode = true;

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
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 48),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('12345679034395'),
                        Text('Muhammad Nurul Karim'),
                        Text('abc@gmail.com'),
                        Text('085769143295'),
                        Text('Anggota'),
                        SizedBox(height: 12),
                        Center(
                          child: Column(
                            children: [
                              // Simulasi Barcode
                              SizedBox(height: 40, child: Placeholder()),
                              SizedBox(height: 4),
                              Text('24110900009'),
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

            // Bahasa
            settingItem('Bahasa Indonesia', onTap: () {}),
            // Tema
            SwitchListTile(
              title: const Text('Tema Gelap'),
              value: isDarkMode,
              onChanged: (value) {
                // Ganti tema di sini
              },
            ),
            // Laporan
            settingItem('Laporan', onTap: () {}),
            // Tentang Developer
            settingItem('Tentang Developer', onTap: () {}),

            const SizedBox(height: 20),

            // Tombol keluar
            Obx(
              () => MyButton(
                onPressed: controller.logout,
                color: ColorConstant.redColor,
                child:
                    controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Keluar", style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
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

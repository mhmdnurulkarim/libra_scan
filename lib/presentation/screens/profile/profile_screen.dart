import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .collection('account')
              .limit(1)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Data akun tidak tersedia'));
            }

            final accountData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;

            return ListView(
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
                            Text(accountData['nik'] ?? '-'),
                            Text(
                              accountData['nama'] ?? '-',
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(accountData['email'] ?? '-'),
                            Text(accountData['nomor_hp'] ?? '-'),

                            // Role name
                            FutureBuilder<DocumentSnapshot>(
                              future: (accountData['role'] as DocumentReference)
                                  .get(),
                              builder: (context, roleSnapshot) {
                                if (roleSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Memuat peran...");
                                }
                                final roleName =
                                (roleSnapshot.data?.data() as Map<String, dynamic>?)?['name'];
                                return Text(roleName ?? 'Anggota');
                              },
                            ),

                            const SizedBox(height: 12),
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                    child: Placeholder(), // ganti barcode di sini
                                  ),
                                  const SizedBox(height: 4),
                                  Text(userId ?? '-'),
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
                    // Logika dark mode
                  },
                ),
                settingItem('Laporan', onTap: () {}),
                settingItem('Tentang Developer', onTap: () {}),

                const SizedBox(height: 20),

                // Tombol keluar
                Obx(() => MyButton(
                  onPressed: () => authController.logout(),
                  color: ColorConstant.redColor,
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Keluar",
                      style: TextStyle(color: Colors.white)),
                )),
              ],
            );
          },
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

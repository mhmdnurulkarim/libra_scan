import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/common/constants/color_constans.dart';
import 'package:libra_scan/presentation/screens/search/search_user_screen.dart';

import '../controllers/main_controller.dart';
import 'home/home_admin_screen.dart';
import 'home/home_user_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_admin_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final controller = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.role.value == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: ColorConstant.primaryColor(context),
            ),
          ),
        );
      }

      final isAdmin = controller.role.value == 'admin';

      final children = [
        isAdmin ? HomeAdminScreen() : HomeUserScreen(),
        isAdmin ? SearchAdminScreen() : SearchUserScreen(),
        ProfileScreen(),
      ];

      return Scaffold(
        body: children[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          backgroundColor: ColorConstant.backgroundColor(context),
          selectedItemColor: ColorConstant.primaryColor(context),
          unselectedItemColor: ColorConstant.fontColor(context).withOpacity(0.6),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Pencarian',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      );
    });
  }
}

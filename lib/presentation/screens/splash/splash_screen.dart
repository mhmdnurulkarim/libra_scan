import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/color_constans.dart';
import '../../../data/share_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final userData = await LocalStorage.getUserData();
    final userId = userData['user_id'];

    if (userId != null && userId != '') {
      Get.offNamed('/main');
    } else {
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor(context),
      body: Center(
        child: Text(
          'LibraScan',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ColorConstant.backgroundColor(context),
          ),
        ),
      ),
    );
  }
}
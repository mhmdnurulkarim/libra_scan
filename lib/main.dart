import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/utils/locale_controller.dart';

import 'common/constants/color_constans.dart';
import 'common/routes/app_pages.dart';
import 'common/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final localeController = Get.put(LocaleController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libra Scan',
      themeMode: localeController.themeMode.value,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorConstant.lightPrimaryColor,
        scaffoldBackgroundColor: ColorConstant.lightBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorConstant.lightPrimaryColor,
          foregroundColor: ColorConstant.lightBackgroundColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: ColorConstant.lightFontColor),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: ColorConstant.darkPrimaryColor,
        scaffoldBackgroundColor: ColorConstant.darkBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorConstant.darkPrimaryColor,
          foregroundColor: ColorConstant.lightBackgroundColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: ColorConstant.darkFontColor),
        ),
      ),

      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    ));
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libra_scan/utils/locale_controller.dart';

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
      title: 'LibraScan',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: localeController.themeMode.value,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    ));
  }
}

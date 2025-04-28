import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/routes/app_pages.dart';
import 'common/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LibraScan',
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  // var locale = const Locale('id', 'ID').obs;
  var themeMode = ThemeMode.light.obs;

  // void changeLocale(String languageCode) {
  //   locale.value = Locale(languageCode);
  //   Get.updateLocale(locale.value);
  // }

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

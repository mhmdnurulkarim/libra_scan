import 'package:flutter/material.dart';

class ColorConstant {
  // Light Theme Colors
  static const Color lightPrimaryColor = Color(0xFF2ECC71);
  static const Color lightSecondaryColor = Color(0xFF27AE60);
  static const Color lightBackgroundColor = Color(0xFFF6F8FC);
  static const Color lightFontColor = Colors.black;
  static const Color lightDangerColor = Color(0xFFEF5350);
  static const Color lightWarningColor = Color(0xFFFFA726);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF27AE60);
  static const Color darkSecondaryColor = Color(0xFF1E874B);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkFontColor = Colors.white;
  static const Color darkDangerColor = Color(0xFFE57373);
  static const Color darkWarningColor = Color(0xFFFFB74D);

  // Getters by current theme
  static Color primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkPrimaryColor
          : lightPrimaryColor;

  static Color secondaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSecondaryColor
          : lightSecondaryColor;

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackgroundColor
          : lightBackgroundColor;

  static Color fontColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkFontColor
          : lightFontColor;

  static Color dangerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkDangerColor
          : lightDangerColor;

  static Color warningColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkWarningColor
          : lightWarningColor;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  // Theme Management
  var themeMode = ThemeMode.light.obs;
  ThemeData get lightTheme => ThemeData(
        fontFamily: 'sora',
        cardColor: Colors.blueGrey,
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
          foregroundColor: Colors.white,
        ),
      );
  ThemeData get darkTheme => ThemeData(
        fontFamily: 'sora',
        cardColor: Colors.white,
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          color: Colors.teal,
          foregroundColor: Colors.white,
        ),
      );

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  // Localization Management
  var currentLocale = const Locale('en', 'US').obs;

  void changeLocale(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }
}

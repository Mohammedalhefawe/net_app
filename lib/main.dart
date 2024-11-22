import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web1/constants/app_routes.dart';
import 'package:web1/features/auth/controller/app_controller.dart';
import 'package:web1/features/auth/controller/auth_controller.dart';
import 'package:web1/features/auth/view/login_view.dart';
import 'package:web1/translations/app_translations.dart';
import 'package:web1/bindings/app_bindings.dart';

void main() {
  Get.lazyPut<AppController>(() => AppController());
  Get.lazyPut<AuthController>(() => AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Get.find<AppController>().lightTheme,
      darkTheme: Get.find<AppController>().darkTheme,
      themeMode: Get.find<AppController>().themeMode.value,
      locale: Get.find<AppController>().currentLocale.value,
      translations: AppTranslations(),
      home: LoginView(),
      // initialRoute: AppRoutes.signUp,
      // getPages: AppRoutes.routes,
      initialBinding: AppBindings(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web1/features/home/view/widgets/dashboard_widget.dart';
import '../controller/auth_controller.dart';
import '../controller/app_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find();
  final AppController appController = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final isMobile = MediaQuery.of(context).size.width < 600;
    final double maxWidth = isMobile ? double.infinity : 400.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              appController.changeLocale(
                Get.locale?.languageCode == 'en'
                    ? const Locale('ar', 'AE')
                    : const Locale('en', 'US'),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: appController.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'login'.tr,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr;
                    }
                    if (!value.contains('@') || !value.endsWith('.com')) {
                      return 'invalid_email'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password_required'.tr;
                    }
                    if (value.length < 6) {
                      return 'password_length'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Obx(() {
                  return authController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen()));
                            // if (formKey.currentState!.validate()) {
                            //   authController.signIn(UserModel(
                            //     email: emailController.text,
                            //     password: passwordController.text,
                            //   ));
                            // }
                          },
                          child: Text('login'.tr),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/app_controller.dart';
import 'login_view.dart';
import '../model/user_model.dart';

class SignUpView extends StatelessWidget {
  final AuthController authController = Get.find();
  final AppController appController = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double maxWidth = isMobile ? double.infinity : 400.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('sign_up'.tr),
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
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'create_account'.tr,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'name'.tr,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                  ),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      UserModel user = UserModel(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      authController.signUp(user).then((_) {
                        Get.snackbar(
                          'success'.tr,
                          'sign_up_success'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }).catchError((error) {
                        Get.snackbar(
                          'error'.tr,
                          '$error',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      });
                    }
                  },
                  child: Text('sign_up'.tr),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: TextButton(
                    onPressed: () => Get.to(() => LoginView()),
                    child: Text(
                      'already_have_account'.tr,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

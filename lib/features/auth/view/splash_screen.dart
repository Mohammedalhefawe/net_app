import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/features/auth/view/login_view.dart';
import 'package:web1/features/home/view/widgets/dashboard_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<String?> _getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.data != null) {
            return const DashboardScreen();
          } else {
            return LoginView();
          }
        }
      },
    );
  }
}

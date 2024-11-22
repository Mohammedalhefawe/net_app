import 'package:get/get.dart';
import 'package:web1/features/auth/view/login_view.dart';
import 'package:web1/features/auth/view/sign_up_view.dart';

class AppRoutes {
  static const String signUp = '/signUp';
  static const String login = '/login';

  static List<GetPage> routes = [
    GetPage(
      name: signUp,
      page: () => SignUpView(), 
    ),
    GetPage(
      name: login,
      page: () => LoginView(),
    ),
  ];
}

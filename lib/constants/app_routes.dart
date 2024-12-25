import 'package:get/get.dart';
import 'package:web1/features/auth/view/login_view.dart';
import 'package:web1/features/auth/view/sign_up_view.dart';
import 'package:web1/features/home/view/screens/home_screen.dart';
import 'package:web1/features/home/view/widgets/dashboard_widget.dart';

class AppRoutes {
  static const String SplashScreen = '/';
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String home = '/home';
  static const String Dashboard = '/DashboardScreen';

  static List<GetPage> routes = [
    GetPage(
      name: signUp,
      page: () => SignUpView(),
    ),
    GetPage(
      name: login,
      page: () => LoginView(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Dashboard,
      page: () => const DashboardScreen(),
    ),
  ];
}

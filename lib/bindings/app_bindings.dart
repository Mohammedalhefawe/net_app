import 'package:get/get.dart';
import 'package:web1/features/auth/controller/auth_controller.dart';
import 'package:web1/features/auth/controller/app_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<AppController>(() => AppController());
    //Get.lazyPut<FileController>(() => FileController());
    // Get.put<DashboardController>(DashboardController());
  }
}

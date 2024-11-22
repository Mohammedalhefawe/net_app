import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web1/services/auth_service.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  Future<void> signUp(UserModel user) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signUp(user);
      if (response['status'] == 'success') {
        Fluttertoast.showToast(msg: "Sign up successful!");
        Get.offAllNamed('/login');
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? "Sign up failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(UserModel user) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signIn(user);
      if (response['status'] == 'success') {
        Fluttertoast.showToast(msg: "Login successful!");
        //Get.offAllNamed('/home');
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? "Login failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

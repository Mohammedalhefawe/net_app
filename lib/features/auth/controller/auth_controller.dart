import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/features/auth/view/login_view.dart';
import 'package:web1/services/auth_service.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  Future<String?> signUp(UserModel user) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signUp(user);

      if (response['data'] != null) {
        final token = response['data']['access_token'];
        final userId = response['data']['user']['id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', userId);

        return token; 
      } else {
        Fluttertoast.showToast(
            msg: response['data']['message'] ?? "Sign up failed.");
        return null;
      }
    } catch (e) {
      print(Response);
      Fluttertoast.showToast(msg: "Error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> signIn(UserModel user) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signIn(user);

      if (response['data'] != null) {
        final token = response['data']['access_token'];
        final userId = response['data']['user']['id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', userId);

        return token; 
      } else {
        Fluttertoast.showToast(
            msg: response['data']['message'] ?? "Login failed.");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'No token found.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.logout(token);

      if (response['message'] == 'Successfully logged out') {
        Fluttertoast.showToast(msg: 'Logged out successfully');

        await pref.remove('auth_token');
        await pref.remove('user_id');

        Get.offAll(LoginView());
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? 'Logout failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    isLoading.value = true;
    try {
      final List<UserModel> users = await _apiService.getAllUsers();
      print("Fetched Users: ${users.map((e) => e.name).toList()}");
      return users;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching users: $e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web1/constants/app_urls.dart';
import 'package:web1/features/auth/model/user_model.dart';

class ApiService {
  final String baseUrl = AppUrls.signupUrl;
  final String baseUrl1 = AppUrls.loginUrl;

  Future<Map<String, dynamic>> signUp(UserModel user) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(url, body: user.toJson());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<Map<String, dynamic>> signIn(UserModel user) async {
    final url = Uri.parse(baseUrl1);
    final response = await http.post(url, body: user.toJson());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to log in');
    }
  }
}

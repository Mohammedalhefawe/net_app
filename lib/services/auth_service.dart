import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web1/constants/app_urls.dart';
import 'package:web1/features/auth/model/user_model.dart';

class ApiService {
  final String baseUrl = AppUrls.signupUrl;
  final String baseUrl1 = AppUrls.loginUrl;
  final String logoutUrl = AppUrls.logoutUrl;
  final String showUserUrl = AppUrls.showUserUrl;
  final String showAllUsersUrl = AppUrls.showAllUsersUrl;

  Future<Map<String, dynamic>> signUp(UserModel user) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signIn(UserModel user) async {
    final url = Uri.parse(baseUrl1);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to log in: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse(logoutUrl);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to log out: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(int id, String token) async {
    final url = Uri.parse('$showUserUrl/$id');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user info: ${response.body}');
    }
  }

  Future<List<UserModel>> getAllUsers(String token) async {
    try {
      final url = Uri.parse(showAllUsersUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching users: $e');
    }
  }
}

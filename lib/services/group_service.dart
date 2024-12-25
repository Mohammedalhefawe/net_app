import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web1/constants/app_urls.dart';

class GroupService {
  final String getAllGroupsUrl = AppUrls.getAllGroupsUrl;
  final String createGroupUrl = AppUrls.createGroupUrl;
  final String createUserGroupUrl = AppUrls.createUserGroupUrl;
  final String showGroupUrl = AppUrls.showGroupUrl;
  final String editGroupUrl = AppUrls.editGroupUrl;
  final String deleteGroupUrl = AppUrls.deleteGroupUrl;

  Future<Map<String, dynamic>?> getAllGroups(String token) async {
    final url = Uri.parse(getAllGroupsUrl);

    final response = await http.get(
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
      throw Exception('Failed to load groups: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> createGroup(
      String groupName, String token) async {
    final url = Uri.parse(createGroupUrl);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", 
      },
      body: jsonEncode({'name': groupName}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create group: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> createUserGroup({
    required int userId,
    required int groupId,
    required bool isAdmin,
    required String token,
  }) async {
    final url = Uri.parse(createUserGroupUrl);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        'user_id': userId,
        'group_id': groupId,
        'isAdmin': isAdmin ? 1 : 0,
      }),
    );

    print({
      'user_id': userId,
      'group_id': groupId,
      'isAdmin': isAdmin ? 1 : 0,
    });

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Success: ${response.body}');
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      print('Bad Request: ${response.body}');
      throw Exception('Bad Request: ${response.body}');
    } else if (response.statusCode == 401) {
      print('Unauthorized: ${response.body}');
      throw Exception('Unauthorized. Please check your token.');
    } else if (response.statusCode == 403) {
      print('Forbidden: ${response.body}');
      throw Exception('Forbidden. You do not have permission to access this.');
    } else if (response.statusCode == 404) {
      print('Not Found: ${response.body}');
      throw Exception('Resource not found. Check the URL or resource ID.');
    } else if (response.statusCode == 500) {
      print('Internal Server Error: ${response.body}');
      throw Exception('Server error. Please try again later.');
    } else {
      print('Unexpected Error: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> getGroupDetails({
    required int groupId,
    required String token,
  }) async {
    final url =
        Uri.parse('$showGroupUrl/$groupId'); 

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Group not found.');
    } else {
      throw Exception('Failed to fetch group details: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> editGroup({
    required int groupId,
    required String newName,
    required String token,
  }) async {
    final url =
        Uri.parse('$editGroupUrl/$groupId');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'name': newName}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update group: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> deleteGroup({
    required int groupId,
    required String token,
  }) async {
    final url = Uri.parse(
        '$deleteGroupUrl/$groupId'); 

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete group: ${response.body}');
    }
  }
}

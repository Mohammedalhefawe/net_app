import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; 
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:web1/constants/app_urls.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 

class FileService {
  Future<Map<String, dynamic>?> uploadFile({
    required String token,
    required String groupId,
    required bool status, 
    File? file,
    Uint8List? fileBytes, 
    String? fileName, 
  }) async {
    final url = Uri.parse(AppUrls.uploadFileUrl);

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        })
        ..fields['group_id'] = groupId
        ..fields['status'] = status ? '1' : '0'; 

      if (kIsWeb) {
        if (fileBytes != null && fileName != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              fileBytes,
              filename: fileName,
              contentType: MediaType('application', 'octet-stream'),
            ),
          );
        } else {
          throw Exception("File bytes or file name cannot be null for web");
        }
      } else {
        if (file != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file',
              file.path,
              contentType: MediaType('application', 'octet-stream'),
            ),
          );
        } else {
          throw Exception("File cannot be null for mobile/desktop");
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");

      if (responseBody.isEmpty) {
        throw Exception("Received empty response from server.");
      }

      // التحقق من نوع الاستجابة
      final contentType = response.headers['content-type'];
      print("Content-Type: $contentType");

      if (contentType != null && contentType.contains('application/json')) {
        try {
          return jsonDecode(responseBody); 
        } catch (e) {
          throw FormatException("Failed to parse response as JSON: $e");
        }
      } else {
        throw Exception("Server did not return JSON response.");
      }
    } catch (e) {
      print("Error in uploadFile: $e");
      if (e is FormatException) {
        print("Failed to parse response: $e");
      }
      rethrow;
    }
  }
}

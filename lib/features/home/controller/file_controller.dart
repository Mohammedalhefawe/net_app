import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/features/home/controller/groups_controller.dart';
import 'package:web1/services/file_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileController extends GetxController {
  var isLoading = false.obs;

  Future<void> uploadFileToGroup({
    required String groupId,
    required bool status,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      final response = await FileService().uploadFile(
        token: token,
        groupId: groupId,
        status: status,
        file: file,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      if (response != null && response['message'] == 'Success') {
        Fluttertoast.showToast(msg: 'File uploaded successfully!');
      } else {
        Fluttertoast.showToast(msg: 'Failed to upload file');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadFile(
      String groupId, bool isCheckIn, GroupsController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List fileBytes = result.files.single.bytes!;
          String fileName = result.files.single.name;

          await uploadFileToGroup(
            groupId: groupId,
            status: isCheckIn,
            fileBytes: fileBytes,
            fileName: fileName,
          );
          controller.getFiles();
        } else {
          File file = File(result.files.single.path!);

          await uploadFileToGroup(
            groupId: groupId,
            status: isCheckIn,
            file: file,
          );
        }
      } else {
        Fluttertoast.showToast(msg: "No file selected");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error picking file: $e");
    }
  }
}

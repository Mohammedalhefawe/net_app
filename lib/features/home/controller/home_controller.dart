import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/class/crud.dart';
import 'package:web1/class/handingdatacontroller.dart';
import 'package:web1/class/statusrequest.dart';
import 'package:web1/features/home/data/data_source/files_data.dart';
import 'package:web1/features/home/data/model/files_model.dart';
import 'package:web1/features/home/data/model/groups_model.dart';
import 'package:web1/features/home/view/screens/files_in_group_screen.dart';
import 'package:web1/features/home/view/widgets/custom_drop_down.dart';

class HomeController extends GetxController {
  List<ObjectDropdownFormField> groupsList = [];
  List<TableDataModle> filesList = [];
  bool getFilesCheck = false;
  FilesData filesData = FilesData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;
  ObjectDropdownFormField? selectedGroup;
  UploadFileModel? uploadFileModel;
  GlobalKey<FormState>? formstate = GlobalKey<FormState>();
  List<String> checkFiles = [];

  checkFile(int index, String id, bool value) {
    if (value) {
      checkFiles.add(id);
      filesList[index].check = true;
    } else {
      checkFiles.remove(id);
      filesList[index].check = false;
    }
    update();
  }

  File? pickedFile;
  Uint8List? webFile;
  bool isUploadingImage = false;

  Future<void> pickFile({String? fileId, String? groupId}) async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.isNotEmpty) {
        webFile = result.files.first.bytes;
        pickedFile = File(result.files.first.name);
        isUploadingImage = true;
        update();
        if (fileId != null) {
          addFile(fileId: fileId, groupId: groupId);
        }
      } else {
        Fluttertoast.showToast(msg: "No file selected");
      }
    }
  }

  getGroups() async {
    groupsList.clear();
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    statusRequest = StatusRequest.loading;
    update();
    var response = await filesData.getGroupsData(token);
    ResponseJson responseJson = handlingData(response);
    statusRequest = responseJson.statusRequest;
    update();
    if (StatusRequest.success == statusRequest) {
      List<GroupData> data = GroupsModel.fromJson(response).data;
      for (var element in data) {
        groupsList.add(ObjectDropdownFormField(
          title: element.name,
          id: element.id.toString(),
        ));
      }
    } else {
      print('error');
      Fluttertoast.showToast(msg: 'error');
    }
  }

  deleteFiles({String? id}) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    statusRequest = StatusRequest.loading;
    update();
    String fileId = '';
    if (id == null) {
      for (var i = 0; i < checkFiles.length; i++) {
        if (i < checkFiles.length - 1) {
          fileId += '${checkFiles[i]},';
        } else {
          fileId += checkFiles[i];
        }
      }
    } else {
      fileId = id;
    }
    print("=========== $fileId");
    var response = await filesData.deleteFileData(token, fileId);
    ResponseJson responseJson = handlingData(response);
    statusRequest = responseJson.statusRequest;
    update();
    if (StatusRequest.success == statusRequest) {
      Fluttertoast.showToast(msg: 'deleted file successfully');
      checkFiles.clear();
      getFiles();
    } else {
      print('error');
      Fluttertoast.showToast(msg: 'error');
    }
  }

  downloadFiles({String? id}) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    statusRequest = StatusRequest.loading;
    update();
    String fileId = '';
    if (id == null) {
      for (var i = 0; i < checkFiles.length; i++) {
        if (i < checkFiles.length - 1) {
          fileId += '${checkFiles[i]},';
        } else {
          fileId += checkFiles[i];
        }
      }
    } else {
      fileId = id;
    }
    print("=========== $fileId");
    var response = await filesData.downloadFileData(token, fileId);
    ResponseJson responseJson = handlingData(response);
    statusRequest = responseJson.statusRequest;
    update();
    if (StatusRequest.success == statusRequest) {
      print('downloaded.....');
      checkFiles.clear();
      getFiles();
      Fluttertoast.showToast(msg: 'downloaded file successfully');
    } else {
      print('error');
      Fluttertoast.showToast(msg: 'error');
    }
  }

  getFiles() async {
    filesList.clear();
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    statusRequest = StatusRequest.loading;
    update();
    var response = await filesData.getFilesData(token);

    ResponseJson responseJson = handlingData(response);
    statusRequest = responseJson.statusRequest;
    update();
    if (StatusRequest.success == statusRequest) {
      print(response);
      print('======================');
      getFilesCheck = true;
      update();
      FilesModel data = FilesModel.fromJson(response);

      for (var element in data.data.lastFiles) {
        filesList.add(TableDataModle(
          groupId: element.groups[0].id.toString(),
          logs: element.fileLogs,
          fileName: element.name,
          id: element.id.toString(),
          groupName: element.groups[0].name,
          state: element.status == 0 ? 'open' : 'closed',
          lastEdit:
              element.lastModify == null ? 'null' : element.lastModify!.date,
          overView: element.lastView == null ? 'null' : element.lastView!.date,
        ));
      }
    } else {
      print('error');
      Fluttertoast.showToast(msg: 'error');
    }
  }

  addFile({String? fileId, String? groupId}) async {
    if (fileId != null || formstate!.currentState!.validate()) {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('auth_token') ?? '';
      statusRequest = StatusRequest.loading;
      update();
      uploadFileModel = UploadFileModel(
          file: FileModel(filePath: pickedFile!.path, file: webFile),
          token: token,
          fileId: fileId,
          groupId: groupId ?? selectedGroup!.id);
      var response = await filesData.uploadFileData(uploadFileModel!);
      ResponseJson responseJson = handlingData(response);
      statusRequest = responseJson.statusRequest;
      update();
      if (StatusRequest.success == statusRequest) {
        pickedFile = null;
        webFile = null;
        selectedGroup = null;
        isUploadingImage = false;
        Get.back();
        getFiles();
        Fluttertoast.showToast(msg: 'success');
      } else {
        print('error');
        Fluttertoast.showToast(msg: 'error');
      }
    }
  }
}

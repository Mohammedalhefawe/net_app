import 'package:web1/class/crud.dart';

class FilesData {
  Crud crud;
  FilesData(this.crud);

  uploadFileData(UploadFileModel uoploadFileModel) async {
    Map data = {
      'group_id': uoploadFileModel.groupId,
    };
    if (uoploadFileModel.fileId != null) {
      data.addAll({'fileId': uoploadFileModel.fileId});
    }
    var response = await crud.postFileAndData(
        linkurl: 'http://127.0.0.1:8000/api/file/upload',
        data: data,
        file: uoploadFileModel.file,
        headers: {'authorization': 'Bearer ${uoploadFileModel.token}'});
    return response.fold((l) => l, (r) => r);
  }

  getGroupsData(String token) async {
    var response = await crud.getData(
        linkurl: 'http://127.0.0.1:8000/api/group/all',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }

  getNotificationsData(String token) async {
    var response = await crud.getData(
        linkurl: 'http://127.0.0.1:8000/api/user/notification/all',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }

  getFilesData(String token) async {
    // print('token: $token');
    var response = await crud.getData(
        linkurl: 'http://127.0.0.1:8000/api/user/me',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }

  getFilesInGroupData(String token, String groupId) async {
    // print('token: $token');
    var response = await crud.getData(
        linkurl: 'http://127.0.0.1:8000/api/group/show-by/$groupId',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }

  deleteFileData(String token, String fileId) async {
    var response = await crud.deleteData(
        linkurl: 'http://127.0.0.1:8000/api/file/delete/$fileId',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }

  downloadFileData(String token, String fileId) async {
    var response = await crud.getFiles(
        linkurl: 'http://127.0.0.1:8000/api/file/download/$fileId',
        headers: {'authorization': 'Bearer $token'});
    return response.fold((l) => l, (r) => r);
  }
}

class UploadFileModel {
  final String token, groupId;
  final FileModel file;
  final String? fileId;

  UploadFileModel(
      {required this.token,
      this.fileId,
      required this.groupId,
      required this.file});
}

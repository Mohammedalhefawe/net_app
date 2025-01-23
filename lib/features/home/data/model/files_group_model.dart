import 'package:web1/features/home/data/model/archive_model.dart';
import 'package:web1/features/home/data/model/files_model.dart';

class FilesInGroupModel {
  Data data;
  String message;

  FilesInGroupModel({required this.data, required this.message});

  factory FilesInGroupModel.fromJson(Map<String, dynamic> json) {
    return FilesInGroupModel(
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  int id;
  String name;
  final List<UserData> users;
  List<FileMo> files;

  Data(
      {required this.id,
      required this.name,
      required this.users,
      required this.files});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      users: (json['users'] as List<dynamic>?)
              ?.map((item) => UserData.fromJson(item))
              .toList() ??
          [],
      files:
          List<FileMo>.from(json['files'].map((file) => FileMo.fromJson(file))),
    );
  }
}

class FileMo {
  int id;
  int status;
  String path;
  String name;
  int userId;
  // User user;
  List<FileLog> fileLogs;
  List<Group> groups;
  List<ArchiveData> archives;
  FileLog? lastModify;
  dynamic lastView;

  FileMo({
    required this.id,
    required this.status,
    required this.path,
    required this.name,
    required this.userId,
    // required this.user,
    required this.archives,
    required this.fileLogs,
    required this.groups,
    this.lastModify,
    this.lastView,
  });

  factory FileMo.fromJson(Map<String, dynamic> json) {
    return FileMo(
      id: json['id'],
      status: json['status'],
      path: json['path'],
      name: json['name'],
      userId: json['user_id'],
      archives: (json['archive'] as List<dynamic>)
          .map((item) => ArchiveData.fromJson(item))
          .toList(),
      // user: User.fromJson(json['user']),
      fileLogs: List<FileLog>.from(
          json['file_logs'].map((log) => FileLog.fromJson(log))),
      groups: List<Group>.from(
          json['groups'].map((group) => Group.fromJson(group))),
      lastModify: json['last_modify'] != null
          ? FileLog.fromJson(json['last_modify'])
          : null,
      lastView: json['last_view'],
    );
  }
}

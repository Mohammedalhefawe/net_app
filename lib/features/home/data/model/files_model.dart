import 'package:web1/features/home/data/model/archive_model.dart';

class FilesModel {
  final UserData data;
  final String message;

  FilesModel({required this.data, required this.message});

  factory FilesModel.fromJson(Map<String, dynamic> json) {
    return FilesModel(
      data: UserData.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String number;
  final List<FileData> lastFiles;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.lastFiles,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      lastFiles: json['last_files'] != null
          ? List<FileData>.from(
              json['last_files'].map((x) => FileData.fromJson(x)))
          : [],
    );
  }
}

class FileData {
  final int id;
  final int status;
  final String path;
  final String name;
  final int userId;
  // final User user;
  final List<FileLog> fileLogs;
  final List<Group> groups;
  final List<ArchiveData> archives;
  final FileLog? lastModify;
  final FileLog? lastView;

  FileData({
    required this.id,
    required this.status,
    required this.path,
    required this.name,
    required this.userId,
    // required this.user,
    required this.fileLogs,
    required this.archives,
    required this.groups,
    this.lastModify,
    this.lastView,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'] ?? 0,
      status: json['status'] ?? 0,
      path: json['path'] ?? '',
      name: json['name'] ?? '',
      userId: json['user_id'] ?? 0,
      // user: User.fromJson(json['user']),
      archives: (json['archive'] as List<dynamic>)
          .map((item) => ArchiveData.fromJson(item))
          .toList(),
      fileLogs: json['file_logs'] != null
          ? List<FileLog>.from(
              json['file_logs'].map((x) => FileLog.fromJson(x)))
          : [],
      groups: json['groups'] != null
          ? List<Group>.from(json['groups'].map((x) => Group.fromJson(x)))
          : [],
      lastModify: json['last_modify'] != null
          ? FileLog.fromJson(json['last_modify'])
          : null,
      lastView: json['last_view'] != null
          ? FileLog.fromJson(json['last_view'])
          : null,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String number;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
    );
  }
}

class FileLog {
  final int id;
  final String date;
  final String operation;

  FileLog({
    required this.id,
    required this.date,
    required this.operation,
  });

  factory FileLog.fromJson(Map<String, dynamic> json) {
    return FileLog(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      operation: json['operation'] ?? '',
    );
  }
}

class Group {
  final int id;
  final String name;
  final List<dynamic> users;

  Group({
    required this.id,
    required this.name,
    required this.users,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      users: json['users'] ?? [],
    );
  }
}

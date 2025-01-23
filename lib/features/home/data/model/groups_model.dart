import 'package:web1/features/home/data/model/files_model.dart';

class GroupsModel {
  final List<GroupData> data;
  final String message;

  GroupsModel({
    required this.data,
    required this.message,
  });

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    return GroupsModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => GroupData.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
    };
  }
}

class GroupData {
  final int id;
  final String name;
  final List<UserData> users;

  GroupData({
    required this.id,
    required this.name,
    required this.users,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
   
    return GroupData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      users: (json['users'] as List<dynamic>?)
              ?.map((item) => UserData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

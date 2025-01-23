import 'package:web1/features/home/data/model/files_model.dart';

class GroupModel {
  final int id;
  String name;
  final List<UserData> users;

  GroupModel({required this.id, required this.name, required this.users});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    print('================================');
    print(json['users']);
    return GroupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      users: (json['users'] as List<dynamic>?)
              ?.map((item) => UserData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

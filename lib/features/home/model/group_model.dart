class GroupModel {
  final int id;
  String name;
  final List<dynamic> users;

  GroupModel({required this.id, required this.name, required this.users});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? 0, 
      name: json['name'] ?? 'Unknown', 
      users: json['users'] != null ? List.from(json['users']) : [],
    );
  }
}

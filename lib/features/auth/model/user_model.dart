class UserModel {
  String email;
  String password;
  String? name;  

  UserModel({required this.email, required this.password, this.name});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (name != null) 'name': name, 
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'], 
    );
  }
}

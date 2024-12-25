class UserModel {
  String? email;
  String? password;
  String? name;  
  String? number;
  int? id;    

  UserModel({ this.email,  this.password, this.name, this.number, this.id});

  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (name != null) 'name': name,
      if (number != null) 'number': number,
      if (id != null) 'id': id,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'], 
      number: json['number'], 
      id: json['id'],
    );
  }
}

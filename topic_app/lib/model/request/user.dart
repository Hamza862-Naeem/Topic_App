import 'dart:convert';

class UserRequestModel {
  String id;
  String name;
  String email;
  String password;
  String phoneNumber;
  bool isValidated;
  String role;

  UserRequestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.isValidated,
    required this.role,
  });
  Map<String, dynamic> toMap() => {
    "email": email,
    "uid": id,
    "name": name,
    "password": password,
    "phoneNumber": phoneNumber,
    "isValidated": isValidated,
    "role": role,
  };



  factory UserRequestModel.fromMap(Map<String, dynamic> map) {
    return UserRequestModel(
      email: map['email'],
      id: map['uid'],
      name: map['name'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      isValidated: map['isValidated'] == "true" ? true : false,
      role: map['role'],
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

}
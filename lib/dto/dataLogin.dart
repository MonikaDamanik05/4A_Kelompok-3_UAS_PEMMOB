// ignore_for_file: file_names, camel_case_types

class dataLogin {
  final String message;
  final String roles;
  final int userLogged;

  dataLogin({
    required this.message,
    required this.roles,
    required this.userLogged,
  });

  // From JSON
  factory dataLogin.fromJson(Map<String, dynamic> json) {
    return dataLogin(
      message: json['message'],
      roles: json['roles'],
      userLogged: json['user_logged'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'roles': roles,
      'user_logged': userLogged,
    };
  }
}
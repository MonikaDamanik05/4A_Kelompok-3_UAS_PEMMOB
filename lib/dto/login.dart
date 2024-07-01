class Login {
  final String accessToken;
  final String type;
  final int expiresIn;

  Login({
    required this.accessToken,
    required this.type,
    required this.expiresIn,
  }
  );

  factory Login.fromJson(Map<String, dynamic> json){
    return Login(
      accessToken: json['access_token'] as String,
      type: json['type'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}
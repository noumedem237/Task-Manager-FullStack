class AuthResponseModel {
  const AuthResponseModel({required this.token});

  final String token;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(token: json['token'] as String);
}

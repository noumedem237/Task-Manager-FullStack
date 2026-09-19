class AuthResponseModel {
  const AuthResponseModel({required this.token});

  final String token;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Le jeton reçu est invalide.');
    }
    return AuthResponseModel(token: token);
  }
}

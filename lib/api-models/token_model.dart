class TokenModel {
  TokenModel({
    required this.token,
    required this.refreshToken,
    required this.expiration,
  });
  final String token;
  final String refreshToken;
  final DateTime expiration;

  static TokenModel fromJson(Map<String, Object?> json) {
    return TokenModel(
      token: json["token"] != null ? json["token"] as String : "",
      refreshToken:
          json["refreshToken"] != null ? json["refreshToken"] as String : "",
      expiration: json["expiration"] != null
          ? DateTime.parse(json["expiration"] as String)
          : DateTime.now(),
    );
  }
}

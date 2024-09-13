class AuthTokenModel {
  final String accessToken;
  final int accessTokenExpiresAtInSeconds;
  final String refreshToken;
  final int refreshTokenExpiresAtInSeconds;

  AuthTokenModel({
    required this.accessToken,
    required this.accessTokenExpiresAtInSeconds,
    required this.refreshToken,
    required this.refreshTokenExpiresAtInSeconds,
  });

  // Method to convert the AuthTokenModel to JSON for storing in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'accessTokenExpiresAtInSeconds': accessTokenExpiresAtInSeconds,
      'refreshToken': refreshToken,
      'refreshTokenExpiresAtInSeconds': refreshTokenExpiresAtInSeconds,
    };
  }

  // Method to create an AuthTokenModel object from JSON
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'],
      accessTokenExpiresAtInSeconds: json['accessTokenExpiresAtInSeconds'],
      refreshToken: json['refreshToken'],
      refreshTokenExpiresAtInSeconds: json['refreshTokenExpiresAtInSeconds'],
    );
  }
}

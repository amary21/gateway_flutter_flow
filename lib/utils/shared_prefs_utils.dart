import 'dart:convert';
import 'package:existing_flutter_app/models/auth_token_model.dart';
import 'package:existing_flutter_app/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  static final SharedPrefsUtil _instance = SharedPrefsUtil._internal();
  static late SharedPreferences _prefs;

  // Private constructor for singleton
  SharedPrefsUtil._internal();

  // Singleton getter
  factory SharedPrefsUtil() {
    return _instance;
  }

  // Initialize the SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save UserProfileModel to SharedPreferences
  void saveUserProfile(UserProfileModel userProfile) {
    String userProfileJson = jsonEncode(userProfile.toJson());
    _prefs.setString('userProfile', userProfileJson);
  }

  // Save AuthTokenModel to SharedPreferences
  void saveAuthToken(AuthTokenModel authToken) {
    String authTokenJson = jsonEncode(authToken.toJson());
    _prefs.setString('authToken', authTokenJson);
  }

  // Save deeplink to SharedPreferences
  void saveDeeplink(String deeplink) {
    _prefs.setString('deeplink', deeplink);
  }

  // Get UserProfileModel from SharedPreferences
  UserProfileModel? getUserProfile() {
    String? userProfileJson = _prefs.getString('userProfile');
    if (userProfileJson != null) {
      return UserProfileModel.fromJson(jsonDecode(userProfileJson));
    }
    return null; // Return null if not found
  }

  // Get AuthTokenModel from SharedPreferences
  AuthTokenModel? getAuthToken() {
    String? authTokenJson = _prefs.getString('authToken');
    if (authTokenJson != null) {
      return AuthTokenModel.fromJson(jsonDecode(authTokenJson));
    }
    return null; // Return null if not found
  }

  // Clear the data
  void clearAuthTokenData() {
    _prefs.remove('authToken');
  }

  // Clear the data
  void clearUserProfileData() {
    _prefs.remove('userProfile');
  }
}

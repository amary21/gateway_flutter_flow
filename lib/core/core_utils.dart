import 'package:existing_flutter_app/core/core_constants.dart';
import 'package:existing_flutter_app/models/auth_token_model.dart';
import 'package:existing_flutter_app/models/user_profile_model.dart';
import 'package:existing_flutter_app/utils/shared_prefs_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:suspension_bridge/suspension_bridge.dart';

class CoreService extends ChangeNotifier {
  CoreService._internal();

  static final CoreService _instance = CoreService._internal();

  factory CoreService() {
    return _instance;
  }

  AuthTokenModel? _authTokenData;

  AuthTokenModel? get authTokenData => _authTokenData;

  void setAuthTokenData(
    AuthTokenModel? tokenData, {
    bool refreshCache = false,
  }) {
    _authTokenData = tokenData;
    if (_authTokenData != null) {
      if (refreshCache) {
        SharedPrefsUtil().saveAuthToken(_authTokenData!);
      }
    } else {
      SharedPrefsUtil().clearAuthTokenData();
    }
  }

  UserProfileModel? _userProfileData;

  UserProfileModel? get userProfileData => _userProfileData;

  setUserProfileData(
    UserProfileModel? profileData, {
    bool refreshCache = false,
  }) {
    _userProfileData = profileData;
    if (_userProfileData != null) {
      if (refreshCache) {
        SharedPrefsUtil().saveUserProfile(_userProfileData!);
      }
    } else {
      SharedPrefsUtil().clearUserProfileData();
    }
  }

  bool get isLoggedIn => _userProfileData != null && _authTokenData != null;

  void setAuthDataFromBridge() {
    // Get the AuthTokenData map
    final _authTokenDataMap = SuspensionBridge().getChannelData(
      CoreConstants.coreModuleChannelName,
      CoreConstants.coreAuthTokenDataKey,
    ) as Map<String, dynamic>?;
    if (_authTokenDataMap != null && _authTokenDataMap.isNotEmpty) {
      setAuthTokenData(
        AuthTokenModel.fromJson(
          _authTokenDataMap,
        ),
        refreshCache: true,
      );
    }

    // Get the UserProfileData map
    final _userProfileDataMap = SuspensionBridge().getChannelData(
      CoreConstants.coreModuleChannelName,
      CoreConstants.coreUserProfileDataKey,
    ) as Map<String, dynamic>?;
    if (_userProfileDataMap != null && _userProfileDataMap.isNotEmpty) {
      setUserProfileData(
        UserProfileModel.fromJson(
          _userProfileDataMap,
        ),
        refreshCache: true,
      );
    }

    // Update listeners
    _update();
  }

  void checkAndSetAuthDataOnLaunch() {
    final _storedAuthData = SharedPrefsUtil().getAuthToken();
    final _storedUserData = SharedPrefsUtil().getUserProfile();

    if (_storedUserData != null && _storedAuthData != null) {
      setAuthTokenData(
        _storedAuthData,
        refreshCache: false,
      );
      setUserProfileData(
        _storedUserData,
        refreshCache: false,
      );

      _update();
    }
  }

  void clearAuthData() {
    setAuthTokenData(null);
    setUserProfileData(null);

    _update();
  }

  void _update() {
    notifyListeners();
  }
}

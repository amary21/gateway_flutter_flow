// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:suspension_bridge/suspension_bridge.dart';

Future setLoginDataForExternalConsumption(
  BuildContext context,
  dynamic authTokenData,
  dynamic userProfileData,
) async {
  // Set the auth token data
  SuspensionBridge().addChannelData(
    FFAppConstants.coreModuleChannelName,
    FFAppConstants.authTokenDataKey,
    authTokenData,
  );

  // Set the user profile data
  SuspensionBridge().addChannelData(
    FFAppConstants.coreModuleChannelName,
    FFAppConstants.userProfileDataKey,
    userProfileData,
  );

  // Trigger the onSuccess method
  SuspensionBridge().invokeMethod(
    FFAppConstants.coreModuleChannelName,
    SuspensionBridgeMethod(
      FFAppConstants.coreOnLoginSuccessMethod,
      context: context,
    ),
  );
}

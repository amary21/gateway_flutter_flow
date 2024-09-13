// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:suspension_bridge/suspension_bridge.dart';

Future notifyOnLogout(BuildContext context) async {
  SuspensionBridge().invokeMethod(
    FFAppConstants.coreModuleChannelName,
    SuspensionBridgeMethod(
      FFAppConstants.coreOnLogoutMethod,
      context: context,
    ),
  );
}

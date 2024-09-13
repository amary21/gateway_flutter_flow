import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';

Future login(BuildContext context) async {
  ApiCallResponse? loginResponse;

  // loginAPiCall
  loginResponse = await LoginCall.call();

  if ((loginResponse?.succeeded ?? true)) {
    // pass auth data so that app can set it
    await actions.setLoginDataForExternalConsumption(
      context,
      LoginCall.authTokenData(
        (loginResponse?.jsonBody ?? ''),
      ),
      LoginCall.userProfile(
        (loginResponse?.jsonBody ?? ''),
      ),
    );
    return;
  } else {
    // panic
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text('Login has failed'),
          content: Text('Mayday! Mayday!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: Text('Aaaaaaaaaaaaa'),
            ),
          ],
        );
      },
    );
    // notify externally that login has failed
    await actions.notifyLoginFailed(
      context,
    );
    return;
  }
}

Future logout(BuildContext context) async {
  ApiCallResponse? logoutResponse;

  logoutResponse = await LogoutCall.call();

  // notifyOnLogout
  await actions.notifyOnLogout(
    context,
  );
}

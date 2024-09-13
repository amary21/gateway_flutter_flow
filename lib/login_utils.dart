import 'package:flutter/material.dart';
import 'package:login_module_add_to_flutter/main.dart' as loginMain;
import 'package:login_module_add_to_flutter/flutter_flow/flutter_flow_theme.dart'
    as loginTheme;
import 'package:login_module_add_to_flutter/app_constants.dart'
    as loginConstants;
import 'package:login_module_add_to_flutter/actions/actions.dart'
    as loginActions;

typedef LoginTheme = loginTheme.FlutterFlowTheme;

Widget get loginCoreWidget => loginMain.MyApp();

Future<dynamic> Function(BuildContext) get logout => loginActions.logout;

Future<void> initLoginModule() async {
  // Initialise the login module theme
  await LoginTheme.initialize();
}

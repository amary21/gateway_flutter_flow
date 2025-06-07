import 'package:existing_flutter_app/core/core_constants.dart';
import 'package:existing_flutter_app/core/core_utils.dart';
import 'package:existing_flutter_app/login_utils.dart';
import 'package:existing_flutter_app/utils/deeplink_utils.dart';
import 'package:existing_flutter_app/utils/shared_prefs_utils.dart';
import 'package:existing_flutter_app/workshop_utils.dart';
import 'package:flutter/material.dart';
import 'package:suspension_bridge/suspension_bridge.dart';
import 'screens/post_details_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/logged_in_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the SharedPrefsUtil class before starting the app
  await SharedPrefsUtil.init();

  // Check for stored auth data, this is non-blocking
  CoreService().checkAndSetAuthDataOnLaunch();

  runApp(MyApp());
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple App with Auth Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      navigatorKey: rootNavigatorKey,
      routes: {
        '/': (context) => HomePage(),
        '/loggedInDashboard': (context) => LoggedInDashboardPage(),
        '/postDetails': (context) => PostDetailsPage(),
        '/userProfile': (context) => UserProfilePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    if (CoreService().isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/loggedInDashboard');
    }
  }

  void _onLoginChannelMethodCall(SuspensionBridgeMethod method) {
    switch (method.methodName) {
      case CoreConstants.coreOnLoginSuccessMethod:
        // Set the auth data from bridge
        CoreService().setAuthDataFromBridge();

        // Navigate to logged in state
        Navigator.pushNamedAndRemoveUntil(
          rootNavigatorKey.currentContext!,
          '/loggedInDashboard', // The named route to push
          (Route<dynamic> route) =>
              false, // This condition removes all previous routes
        );
        break;
      case CoreConstants.coreOnLoginFailedMethod:
        if (method.hasContext) {
          Navigator.of(
            method.context!,
            rootNavigator: true,
          ).pop();
        }
        break;
      case CoreConstants.coreOnLogoutMethod:
        // Clear Auth Data
        CoreService().clearAuthData();

        // Navigate to logged out state
        Navigator.pushNamedAndRemoveUntil(
          rootNavigatorKey.currentContext!,
          '/', // The named route to push
          (Route<dynamic> route) =>
              false, // This condition removes all previous routes
        );
        break;
      default:
        print('Method not found: ${method.methodName}');
    }
  }

  Future<void> launchLoginModule() async {
    // Register method call handler to handle incoming triggers from login module
    SuspensionBridge().registerMethodCallHandler(
      CoreConstants.coreModuleChannelName,
      _onLoginChannelMethodCall,
    );
    // Init the login module pre-requisites
    await initLoginModule();

    // Navigate to login module
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => loginCoreWidget,
      ),
    );
  }

  Future<void> launchCaturdayModule() async {
    // Navigate to login module
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => kkWorkShoWidget,
      ),
    );
  }

  Future<void> launcDeeplinkModule() async {
    // Navigate to login module
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => deeplinkDemoWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: launchLoginModule,
              child: const Text('Login to Continue'),
            ),
            ElevatedButton(
              onPressed: launchCaturdayModule,
              child: const Text('Caturday'),
            ),
            ElevatedButton(
              onPressed: launcDeeplinkModule,
              child: const Text('Deeplink Demo'),
            ),
          ],
        ),
      ),
    );
  }
}

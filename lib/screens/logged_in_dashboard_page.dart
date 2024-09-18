import 'package:existing_flutter_app/login_utils.dart';
import 'package:flutter/material.dart';

class LoggedInDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/userProfile');
              },
              child: Text('Go to User Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/postDetails');
              },
              child: Text('Go to Post Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

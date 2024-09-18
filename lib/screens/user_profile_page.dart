import 'package:existing_flutter_app/core/core_utils.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProfile = CoreService().userProfileData!;
    final _authTokenData = CoreService().authTokenData!;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${_userProfile.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('City: ${_userProfile.city}}'),
            SizedBox(height: 10),
            Text('Email: ${_userProfile.email}'),
            SizedBox(height: 10),
            Text('Designation: ${_userProfile.designation}'),
            SizedBox(height: 10),
            Text('Access Token: ${_authTokenData.accessToken}'),
          ],
        ),
      ),
    );
  }
}

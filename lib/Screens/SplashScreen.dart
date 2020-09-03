import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

import 'Auth/LoginPage.dart';
import 'NavBar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    new Future.delayed(Duration(seconds: 3), () async {
      Map<Permission, PermissionState> permission =
          await PermissionsPlugin.requestPermissions([
        Permission.ACCESS_FINE_LOCATION,
      ]);
      FirebaseUser user = await mAuth.currentUser();
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Image.asset('images/supermarket.png'),
        ),
      ),
    );
  }
}

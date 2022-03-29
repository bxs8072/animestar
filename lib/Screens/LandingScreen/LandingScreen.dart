import 'package:animestar/Models/User.dart';
import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:animestar/Screens/AuthScreen/AuthScreen.dart';
import 'package:animestar/Screens/HomeScreen/HomeScreen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final AuthBase authBase = Auth();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUser>(
      stream: authBase.onAuthStateChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AuthScreen();
        } else {
          return HomeScreen(
            user: snapshot.data,
          );
        }
      },
    );
  }
}

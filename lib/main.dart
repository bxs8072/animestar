import 'package:animestar/Screens/LandingScreen/LandingScreen.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

var baseUrl = "https://gogo-anime-7d379.appspot.com";

setNotification() async {
  final _pref = await SharedPreferences.getInstance();
  if (_pref.getBool('all') == null) {
    _pref
        .setBool('all', false)
        .then((value) => FirebaseMessaging().unsubscribeFromTopic('all'));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setNotification();
  runApp(MyApp());
  FacebookAudienceNetwork.init();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: "dark",
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      themes: [
        AppTheme(
            id: "storm", // Id(or name) of the theme(Has to be unique)
            data: ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.red,
                bottomAppBarTheme: BottomAppBarTheme(color: Colors.black)),
            description: "This is my custom theme"),
        AppTheme.dark(id: "dark"),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ThemeConsumer(
          child: LandingScreen(),
        ),
      ),
    );
  }
}

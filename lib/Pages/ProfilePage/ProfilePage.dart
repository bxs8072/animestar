import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/ProfilePage/ProfileHeader.dart';
import 'package:animestar/Pages/ProfilePage/ProfileLogout.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/ThemeTile.dart';
import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:animestar/UIs/HistoryUI/HistoryUI.dart';
import 'package:animestar/UIs/MyCommentsUI/MyCommentsUI.dart';
import 'package:animestar/UIs/NotificationUI/NotificationUI.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final MyUser user;
  ProfilePage({@required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  AuthBase auth = Auth();
  bool allNotification = false;
  getAllNotification() async {
    final _pref = await SharedPreferences.getInstance();
    setState(() {
      allNotification = _pref.getBool('all');
    });
  }

  latestReleaseController() async {
    final _pref = await SharedPreferences.getInstance();
    bool _all = _pref.getBool('all');
    _all
        ? _pref.setBool('all', false).then((value) {
            firebaseMessaging.unsubscribeFromTopic('all').then((value) {
              setState(() {
                allNotification = false;
              });
            });
          })
        : _pref.setBool('all', true).then((value) {
            firebaseMessaging.subscribeToTopic('all').then((value) {
              setState(() {
                allNotification = true;
              });
            });
          });
  }

  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
        child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                ProfileHeader(user: widget.user),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Released Notification'),
                  onTap: () {
                    latestReleaseController();
                  },
                  trailing: Text(allNotification ? "All" : "Favorites"),
                ),
                ThemeTile(),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(MaterialCommunityIcons.star_circle),
                  onTap: () {
                    _inAppReview.requestReview();
                    _inAppReview.openStoreListing();
                  },
                  title: Text("Review"),
                ),
                ListTile(
                  leading: Icon(MaterialCommunityIcons.chat),
                  onTap: () {
                    customNavigator(
                      context: context,
                      widget: MyCommentsUI(user: widget.user),
                    );
                  },
                  title: Text("My Comments"),
                ),
                ListTile(
                  leading: Icon(FlatIcons.notification),
                  onTap: () {
                    customNavigator(
                        context: context, widget: NotificationsUI());
                  },
                  title: Text("Notification Center"),
                ),
                ListTile(
                  leading: Icon(FlatIcons.stopwatch_1),
                  onTap: () {
                    customNavigator(
                        context: context, widget: HistoryUI(user: widget.user));
                  },
                  title: Text("History"),
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: ProfileLogout(
                  auth: auth,
                )),
          ],
        ),
      ),
    ));
  }
}

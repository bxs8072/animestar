import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/MyListPage/MyListPage.dart';
import 'package:animestar/Resources/AnimeDrawer/AnimeDrawerHeader.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/ThemeTile.dart';
import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:animestar/Screens/LandingScreen/LandingScreen.dart';
import 'package:animestar/UIs/HistoryUI/HistoryUI.dart';
import 'package:animestar/UIs/NotificationUI/NotificationUI.dart';
import 'package:animestar/UIs/SearchUI/SearchUI.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class AnimeDrawer extends StatelessWidget {
  final MyUser user;
  AnimeDrawer({@required this.user});

  final AuthBase auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ThemeConsumer(
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            actions: [
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
            backgroundColor: Colors.black,
            title: Text(
              "Anime Ultimate",
              style: GoogleFonts.lato(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AnimeDrawerHeader(user: user),
                    ThemeTile(),
                    ListTile(
                      leading: Icon(FlatIcons.home),
                      onTap: () {
                        customNavigatorAndReplacement(
                            context: context, widget: LandingScreen());
                      },
                      title: Text("Home"),
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
                      leading: Icon(FlatIcons.search),
                      onTap: () {
                        customNavigator(
                            context: context, widget: SearchUI(user: user));
                      },
                      title: Text("Search Anime"),
                    ),
                    ListTile(
                      leading: Icon(FlatIcons.stopwatch_1),
                      onTap: () {
                        customNavigator(
                            context: context, widget: HistoryUI(user: user));
                      },
                      title: Text("History"),
                    ),
                    ListTile(
                      leading: Icon(MaterialCommunityIcons.heart_box),
                      onTap: () {
                        customNavigator(
                            context: context,
                            widget: MyListPage(isNav: true, user: user));
                      },
                      title: Text("Favorites"),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(MaterialCommunityIcons.logout),
                title: Text("Logout"),
                onTap: () {
                  auth.signOut().then((value) => showModalBottomSheet(
                      context: context,
                      builder: (context) => ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(16),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Do you want to logout from Anime Strom?',
                                  style: GoogleFonts.ubuntu(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.check_box,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            auth.signOut().then((value) =>
                                                customNavigatorAndReplacement(
                                                    context: context,
                                                    widget: LandingScreen()));
                                            Navigator.of(context).pop(true);
                                          }),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

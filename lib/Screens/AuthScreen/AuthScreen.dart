import 'dart:ui';

import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:animestar/Screens/AuthScreen/EmailForm/EmailForm.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class AuthScreen extends StatelessWidget {
  static const action_logo =
      "https://scontent-dfw5-2.xx.fbcdn.net/v/t1.0-9/97412218_108559224189194_4146955722183147520_n.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=ME1aeNiHqp0AX9-fNhx&_nc_ht=scontent-dfw5-2.xx&oh=11d310dcade5aa6f2b2dd12d69d0484d&oe=5FBFB782";

  final _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://mangathrill.com/wp-content/uploads/2020/08/fggdsas.jpg",
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Ultimate",
                  style: GoogleFonts.vollkorn(),
                ),
                stretchModes: [
                  StretchMode.blurBackground,
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    ThemeProvider.controllerOf(context).nextTheme();
                    ThemeProvider.controllerOf(context).saveThemeToDisk();
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(action_logo),
                    radius: MediaQuery.of(context).size.height * 0.07,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                margin: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: EmailForm(),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              _auth.signInWithGoogle();
                            },
                            padding: EdgeInsets.all(8),
                            shape: CircleBorder(),
                            child: Icon(
                              FontAwesome.google,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            color: ThemeProvider.controllerOf(context)
                                        .currentThemeId ==
                                    "storm"
                                ? Colors.black87
                                : Colors.white,
                            splashColor: Colors.black,
                          ),
                          SizedBox(width: 20),
                          MaterialButton(
                            onPressed: () {
                              _auth.signInAnonymously();
                            },
                            padding: EdgeInsets.all(8),
                            shape: CircleBorder(),
                            child: Icon(
                              FontAwesome.user,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            color: Colors.blue,
                            splashColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

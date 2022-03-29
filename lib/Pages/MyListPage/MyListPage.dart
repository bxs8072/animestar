import 'package:animestar/Database/FavoriteDatabase.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/MyListPage/CustomBuilder.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class MyListPage extends StatelessWidget {
  final MyUser user;
  final bool isNav;
  MyListPage({@required this.user, @required this.isNav});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    FavoriteDatabase favoriteDatabase = FavoriteDatabase(user: user);
    return ThemeConsumer(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Do you want to clear your list?',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.ubuntu(fontSize: size.height * 0.03),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.check_box,
                                  size: 40,
                                ),
                                onPressed: () {
                                  favoriteDatabase.deleteAll();
                                  Navigator.of(context).pop();
                                }),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 40,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      )
                    ],
                  );
                });
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.delete_sweep, color: Colors.white),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Favorites",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vollkorn(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.034),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Favorites')
                        .doc(user.uid)
                        .collection('Favorites')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center();
                      }
                      List<Anime> _items = snapshot.data.docs
                          .map((e) => Anime.fromDocumentSnapshot(e))
                          .toList();
                      return _items.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        customNavigator(
                                            context: context,
                                            widget: AnimeUI(
                                                genre: "Popular",
                                                type: 'popular',
                                                user: user));
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 80,
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Try Some Popular Animes",
                                      style: GoogleFonts.lato(
                                          fontSize: size.height * 0.035),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : CustomBuilder(items: _items, user: user);
                    }),
              ],
            ),
            Positioned(
                top: 0, left: 0, child: isNav ? PopNavigator() : Center()),
          ],
        )),
      ),
    );
  }
}

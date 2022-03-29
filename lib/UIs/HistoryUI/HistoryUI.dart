import 'package:animestar/Database/HistoryDatabase.dart';
import 'package:animestar/Models/AnimeHistory.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:animestar/UIs/HistoryUI/HistoryBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class HistoryUI extends StatefulWidget {
  final MyUser user;
  HistoryUI({@required this.user});

  @override
  _HistoryUIState createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  bool inverted = false;

  invertManager() {
    setState(() {
      inverted = !inverted;
    });
  }

  @override
  Widget build(BuildContext context) {
    HistoryDatabase historyDatabase = HistoryDatabase(user: widget.user);
    final size = MediaQuery.of(context).size;
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
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Do you want to clear your history list?',
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
                                  historyDatabase.deleteAll();
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "History",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vollkorn(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.034),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Histories')
                        .doc(widget.user.uid)
                        .collection('Histories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center();
                      }
                      List<AnimeHistory> items = snapshot.data.docs
                          .map((e) => AnimeHistory.fromDocumentSnapshot(e))
                          .toList();
                      List<AnimeHistory> _items =
                          inverted ? items.reversed.toList() : items;

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
                                                genre: "New Release",
                                                type: 'newrelease',
                                                user: widget.user));
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
                                      "Try Some New Released Animes",
                                      style: GoogleFonts.lato(
                                          fontSize: size.height * 0.035),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : HistoryBuilder(
                              historyList: _items, user: widget.user);
                    }),
              ],
            ),
            Positioned(top: 0, left: 0, child: PopNavigator()),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                      inverted ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: () {
                    invertManager();
                  },
                ))
          ],
        )),
      ),
    );
  }
}

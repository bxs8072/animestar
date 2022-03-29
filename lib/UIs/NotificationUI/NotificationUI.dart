import 'package:animestar/Resources/PopNavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsUI extends StatefulWidget {
  @override
  _NotificationsUIState createState() => _NotificationsUIState();
}

class _NotificationsUIState extends State<NotificationsUI> {
  @override
  Widget build(BuildContext context) {
    final _mediaSize = MediaQuery.of(context).size;
    return ThemeConsumer(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Notification Center',
                          style: GoogleFonts.vollkorn(
                              fontWeight: FontWeight.bold,
                              fontSize: _mediaSize.height * 0.03),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("AnimeUltimateNotifications")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(child: Center());
                        } else {
                          List<Map<String, dynamic>> _items =
                              snapshot.data.docs.map((e) => e.data()).toList();

                          return SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              Map<String, dynamic> each = _items[i];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          each['title'],
                                          style: GoogleFonts.lato(fontSize: 16),
                                        ),
                                      ),
                                      Image.network(each['image']),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          each['content'],
                                          textAlign: TextAlign.center,
                                          style:
                                              GoogleFonts.allerta(fontSize: 16),
                                        ),
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        color: Colors.blue,
                                        onPressed: () async {
                                          await launch(each['link']);
                                        },
                                        child: Text(
                                          each['btnName'],
                                          style: GoogleFonts.allerta(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }, childCount: _items.length),
                          );
                        }
                      })
                ],
              ),
              Positioned(
                left: 0,
                top: 0,
                child: PopNavigator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

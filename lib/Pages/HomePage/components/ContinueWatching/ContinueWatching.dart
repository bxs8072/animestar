import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContinueWatchingSlider extends StatelessWidget {
  final MyUser user;
  ContinueWatchingSlider({@required this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Continue')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data.exists) {
            return Center();
          }
          Anime anime = Anime.fromMap(snapshot.data.data());
          return Column(
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Continue Watching",
                  style: GoogleFonts.ubuntu(),
                ),
              ),
              Container(
                height: size.height * 0.35,
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    customNavigator(
                        context: context,
                        widget: AnimeDetailUI(user: user, anime: anime));
                  },
                  child: ListTile(
                    title: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        anime.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        anime.title,
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.ubuntu(fontSize: size.height * 0.026),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

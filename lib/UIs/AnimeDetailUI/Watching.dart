import 'package:animestar/Models/Anime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Watching extends StatelessWidget {
  final Anime anime;
  Watching({@required this.anime});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Watching")
          .doc(anime.title
              .replaceAll(new RegExp(r'[^\w\s]+'), "")
              .split(' ')
              .join(''))
          .collection("Watching")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        int length = snapshot.data.docs.length;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              length < 2
                  ? length.toString() + " person watching"
                  : length.toString() + " people watching",
              style: GoogleFonts.ubuntu(
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        );
      },
    );
  }
}

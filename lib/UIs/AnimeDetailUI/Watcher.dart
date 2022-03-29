import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Watcher extends StatelessWidget {
  final Anime anime;
  final MyUser user;
  Watcher({@required this.anime, @required this.user});
  @override
  Widget build(BuildContext context) {
    final id =
        anime.title.replaceAll(new RegExp(r'[^\w\s]+'), "").split(' ').join('');
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Watching")
          .doc(id)
          .collection("Watching")
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        return IconButton(
            icon: Icon(snapshot.data.exists ? Icons.check : Icons.add),
            onPressed: () {
              if (snapshot.data.exists) {
                FirebaseFirestore.instance
                    .collection("Watching")
                    .doc(id)
                    .collection("Watching")
                    .doc(user.uid)
                    .delete();
              } else {
                FirebaseFirestore.instance
                    .collection("Watching")
                    .doc(id)
                    .collection("Watching")
                    .doc(user.uid)
                    .set(user.toMap());
              }
            });
      },
    );
  }
}

import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Liker extends StatelessWidget {
  final String documentId;
  final MyUser user;
  Liker({this.documentId, this.user});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Likes")
          .doc(documentId)
          .collection("Likes")
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        return IconButton(
            icon: Icon(
                snapshot.data.exists ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              if (snapshot.data.exists) {
                FirebaseFirestore.instance
                    .collection("Likes")
                    .doc(documentId)
                    .collection("Likes")
                    .doc(user.uid)
                    .delete();
              } else {
                FirebaseFirestore.instance
                    .collection("Likes")
                    .doc(documentId)
                    .collection("Likes")
                    .doc(user.uid)
                    .set(user.toMap());
              }
            });
      },
    );
  }
}

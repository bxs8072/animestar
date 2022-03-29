import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Likes extends StatelessWidget {
  final String documentId;
  Likes({this.documentId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Likes")
          .doc(documentId)
          .collection("Likes")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        return Text(snapshot.data.docs.length.toString() + " likes");
      },
    );
  }
}

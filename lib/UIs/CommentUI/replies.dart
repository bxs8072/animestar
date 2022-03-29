import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Replies extends StatelessWidget {
  final String docId;
  Replies({this.docId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Replies")
          .doc(docId)
          .collection("Replies")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        return Text(snapshot.data.docs.length.toString() + " replies");
      },
    );
  }
}

import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetDisplayName extends StatelessWidget {
  final String uid;
  GetDisplayName(this.uid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("");
        }
        MyUser user = MyUser.fromDoc(snapshot.data);
        return Text(user.displayName);
      },
    );
  }
}

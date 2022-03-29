import 'package:animestar/Models/AnimeHistory.dart';
import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HistoryDatabase {
  final MyUser user;
  HistoryDatabase({@required this.user});

  delete({String id}) async {
    final historyRef = FirebaseFirestore.instance
        .collection('Histories')
        .doc(user.uid)
        .collection('Histories');
    await historyRef.doc(id).delete();
  }

  deleteAll() async {
    final historyRef = FirebaseFirestore.instance
        .collection('Histories')
        .doc(user.uid)
        .collection('Histories');
    await historyRef.get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future<void> add({String id, AnimeHistory history}) async {
    final historyRef = FirebaseFirestore.instance
        .collection('Histories')
        .doc(user.uid)
        .collection('Histories');
    await historyRef.doc(id).set(history.toMap());
  }
}

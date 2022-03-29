import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WatchedListDatabase {
  final MyUser user;
  WatchedListDatabase({@required this.user});

  Future<List<String>> fetchAll() async {
    final watchedListRef = FirebaseFirestore.instance
        .collection('watchedLists')
        .doc(user.uid)
        .collection('watchedLists');
    List<String> items = [];
    await watchedListRef.get().then((doc) => {
          doc.docs.forEach((data) => {items.add(data['link'])})
        });
    return items;
  }

  Future<void> add({String id, link}) async {
    final watchedListRef = FirebaseFirestore.instance
        .collection('watchedLists')
        .doc(user.uid)
        .collection('watchedLists');
    watchedListRef.doc(id).set({"link": link});
  }

  Future<void> delete({String id}) async {
    final watchedListRef = FirebaseFirestore.instance
        .collection('watchedLists')
        .doc(user.uid)
        .collection('watchedLists');
    watchedListRef.doc(id).delete();
  }

  Future<void> deleteAll() async {
    final watchedListRef = FirebaseFirestore.instance
        .collection('watchedLists')
        .doc(user.uid)
        .collection('watchedLists');
    watchedListRef.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}

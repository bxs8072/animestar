import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoriteDatabase {
  final MyUser user;
  FavoriteDatabase({@required this.user});

  delete({String id}) async {
    final favoriteRef = FirebaseFirestore.instance
        .collection('Favorites')
        .doc(user.uid)
        .collection('Favorites');
    await favoriteRef.doc(id).delete();
  }

  deleteAll() async {
    final favoriteRef = FirebaseFirestore.instance
        .collection('Favorites')
        .doc(user.uid)
        .collection('Favorites');
    await favoriteRef.get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future<void> add({String id, Anime anime}) async {
    final favoriteRef = FirebaseFirestore.instance
        .collection('Favorites')
        .doc(user.uid)
        .collection('Favorites');
    await favoriteRef.doc(id).set(anime.toMap());
  }
}

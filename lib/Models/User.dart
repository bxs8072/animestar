import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String photoUrl;
  final String email;
  final String displayName;
  MyUser({this.uid, this.photoUrl, this.email, this.displayName});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "photoUrl": photoUrl,
      "email": email,
      "displayName": displayName
    };
  }

  factory MyUser.fromDoc(DocumentSnapshot data) {
    return MyUser(
      displayName: data['displayName'],
      email: data["email"],
      photoUrl: data['photoUrl'],
      uid: data['uid'],
    );
  }

  factory MyUser.fromDyn(dynamic data) {
    return MyUser(
      displayName: data['displayName'],
      email: data["email"],
      photoUrl: data['photoUrl'],
      uid: data['uid'],
    );
  }

  factory MyUser.fromMap(Map<String, dynamic> data) {
    return MyUser(
      displayName: data['displayName'],
      email: data["email"],
      photoUrl: data['photoUrl'],
      uid: data['uid'],
    );
  }
}

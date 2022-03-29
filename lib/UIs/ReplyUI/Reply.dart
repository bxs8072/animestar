import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  final MyUser user;
  final String reply;
  final Timestamp timestamp;

  Reply({this.reply, this.timestamp, this.user});

  Map<String, dynamic> get toMap => {
        "user": user.toMap(),
        "reply": reply,
        "timestamp": timestamp,
      };

  factory Reply.fromDoc(DocumentSnapshot data) => Reply(
        reply: data['reply'],
        timestamp: data['timestamp'],
        user: MyUser.fromDyn(data['user']),
      );
}

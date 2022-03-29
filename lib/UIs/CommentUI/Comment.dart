import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final MyUser user;
  final String comment;
  final Timestamp timestamp;
  final Episode episode;
  final Anime anime;
  final String link;

  Comment(
      {this.comment,
      this.timestamp,
      this.link,
      this.user,
      this.episode,
      this.anime});

  Map<String, dynamic> toMap() {
    return {
      "user": user.toMap(),
      "comment": comment,
      "link": link,
      "timestamp": timestamp,
      "episode": episode.toMap,
      "anime": anime.toMap()
    };
  }

  factory Comment.fromDoc(DocumentSnapshot data) {
    return Comment(
      comment: data['comment'],
      link: data['link'],
      anime: Anime.fromDynamic(data['anime']),
      episode: Episode.fromDynamic(data['episode']),
      user: MyUser.fromDyn(data['user']),
      timestamp: data['timestamp'],
    );
  }
}

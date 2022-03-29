import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:animestar/UIs/CommentUI/liker.dart';
import 'package:animestar/UIs/CommentUI/likes.dart';
import 'package:animestar/UIs/ReplyUI/reply_builder.dart';
import 'package:animestar/UIs/ReplyUI/reply_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class ReplyUI extends StatelessWidget {
  final MyUser user;
  final String docId;
  final Anime anime;
  final Episode episode;
  final Comment comment;
  ReplyUI(
      {@required this.anime,
      @required this.docId,
      @required this.comment,
      @required this.episode,
      @required this.user});
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(episode.title),
            actions: [
              GestureDetector(
                onTap: () {
                  customNavigator(
                    context: context,
                    widget: AnimeDetailUI(user: user, anime: anime),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(anime.image),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment.user.photoUrl),
                  ),
                  title: Text(comment.comment),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text("@ " + comment.user.displayName),
                      SizedBox(height: 5),
                      Text(
                        DateFormat("M/d/y")
                            .add_jm()
                            .format(comment.timestamp.toDate()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Liker(
                            documentId: docId,
                            user: user,
                          ),
                          Likes(
                            documentId: docId,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("REPLIES"),
              ),
              Expanded(
                  child: ReplyBuilder(
                      episode: episode,
                      docId: docId,
                      user: user,
                      anime: anime)),
              ReplyTextField(docId: docId, user: user),
            ],
          ),
        ),
      ),
    );
  }
}

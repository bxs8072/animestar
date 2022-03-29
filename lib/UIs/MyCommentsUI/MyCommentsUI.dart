import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:animestar/UIs/CommentUI/comment_ui.dart';
import 'package:animestar/UIs/CommentUI/liker.dart';
import 'package:animestar/UIs/CommentUI/likes.dart';
import 'package:animestar/UIs/CommentUI/replies.dart';
import 'package:animestar/UIs/ReplyUI/reply_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class MyCommentsUI extends StatelessWidget {
  final MyUser user;
  MyCommentsUI({@required this.user});
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Comments"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Comments")
              .where("user.uid", isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading comments...."),
              );
            }
            List<Comment> comments =
                snapshot.data.docs.map((e) => Comment.fromDoc(e)).toList();
            List<String> docIdList =
                snapshot.data.docs.map((e) => e.id).toList();
            return comments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            MaterialCommunityIcons.chat,
                            size: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "You do not have posted any comments yet!!!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: comments.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            customNavigator(
                              context: context,
                              widget: CommentUI(
                                  episode: comments[i].episode,
                                  user: comments[i].user,
                                  anime: comments[i].anime),
                            );
                          },
                          isThreeLine: true,
                          leading: GestureDetector(
                            onTap: () {
                              customNavigator(
                                context: context,
                                widget: AnimeDetailUI(
                                  user: user,
                                  anime: comments[i].anime,
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comments[i].anime.image),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comments[i].anime.title +
                                  " " +
                                  comments[i].episode.title),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat("M/d/y")
                                      .add_jm()
                                      .format(comments[i].timestamp.toDate()),
                                ),
                              ),
                              Row(
                                children: [
                                  Liker(
                                    documentId: docIdList[i],
                                    user: user,
                                  ),
                                  Likes(
                                    documentId: docIdList[i],
                                  ),
                                  IconButton(
                                    icon: Icon(MaterialCommunityIcons.reply),
                                    onPressed: () {
                                      customNavigator(
                                        context: context,
                                        widget: ReplyUI(
                                            comment: comments[i],
                                            anime: comments[i].anime,
                                            docId: docIdList[i],
                                            episode: comments[i].episode,
                                            user: user),
                                      );
                                    },
                                  ),
                                  Replies(docId: docIdList[i]),
                                ],
                              )
                            ],
                          ),
                          title: Text(
                            comments[i].comment,
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}

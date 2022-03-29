import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/GetDisplayName.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:animestar/UIs/CommentUI/liker.dart';
import 'package:animestar/UIs/CommentUI/likes.dart';
import 'package:animestar/UIs/CommentUI/replies.dart';
import 'package:animestar/UIs/ReplyUI/reply_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReviewBuilder extends StatelessWidget {
  final MyUser user;
  final Anime anime;

  ReviewBuilder({@required this.user, @required this.anime});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Reviews")
          .doc(anime.title
              .replaceAll(new RegExp(r'[^\w\s]+'), "")
              .split(' ')
              .join(''))
          .collection('Reviews')
          .limit(50)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("Loading Reviews..."),
          );
        }
        List<Comment> comments =
            snapshot.data.docs.map((e) => Comment.fromDoc(e)).toList();
        List<String> docIdList = snapshot.data.docs.map((e) => e.id).toList();
        return comments.isEmpty
            ? Center(
                child: Text(
                  "Be first to give a review!!!",
                  style: GoogleFonts.pacifico(
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.height * 0.026,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      trailing: user.uid == comments[i].user.uid
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("Reviews")
                                    .doc(anime.title
                                        .replaceAll(new RegExp(r'[^\w\s]+'), "")
                                        .split(' ')
                                        .join(''))
                                    .collection('Reviews')
                                    .doc(docIdList[i])
                                    .delete();
                              },
                            )
                          : FittedBox(),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            comments[i].user.photoUrl == null
                                ? ""
                                : comments[i].user.photoUrl),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(comments[i].comment),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("@ "),
                              GetDisplayName(comments[i].user.uid),
                            ],
                          ),
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
                                        anime: anime,
                                        docId: docIdList[i],
                                        episode: Episode(
                                            link: anime.title,
                                            title: anime.title),
                                        user: user),
                                  );
                                },
                              ),
                              Replies(docId: docIdList[i]),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        customNavigator(
                          context: context,
                          widget: ReplyUI(
                              comment: comments[i],
                              anime: anime,
                              docId: docIdList[i],
                              episode: Episode(
                                  link: anime.title, title: anime.title),
                              user: user),
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}

import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/GetDisplayName.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:animestar/UIs/CommentUI/liker.dart';
import 'package:animestar/UIs/CommentUI/likes.dart';
import 'package:animestar/UIs/CommentUI/replies.dart';
import 'package:animestar/UIs/ReplyUI/Reply.dart';
import 'package:animestar/UIs/ReplyUI/ReplyApi.dart';
import 'package:animestar/UIs/ReplyUI/reply_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class ReplyBuilder extends StatelessWidget {
  final Episode episode;
  final MyUser user;
  final Anime anime;
  final String docId;
  ReplyBuilder(
      {@required this.episode,
      @required this.docId,
      @required this.user,
      @required this.anime});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Replies")
          .doc(docId)
          .collection("Replies")
          .limit(30)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularLoading();
        }
        List<Reply> replies =
            snapshot.data.docs.map((e) => Reply.fromDoc(e)).toList();
        List<String> docIdList = snapshot.data.docs.map((e) => e.id).toList();
        return replies.isEmpty
            ? ReplyApi.emptyReplyList(context)
            : ListView.builder(
                itemCount: replies.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      trailing: user.uid == replies[i].user.uid
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                ReplyApi.deleteReply(docId, docIdList[i]);
                              },
                            )
                          : FittedBox(),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(replies[i].user.photoUrl),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(replies[i].reply),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("@ "),
                              GetDisplayName(replies[i].user.uid),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat("M/d/y")
                                  .add_jm()
                                  .format(replies[i].timestamp.toDate()),
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
                                        comment: Comment(
                                            comment: replies[i].reply,
                                            link: episode.link,
                                            timestamp: replies[i].timestamp,
                                            user: replies[i].user),
                                        anime: anime,
                                        docId: docIdList[i],
                                        episode: episode,
                                        user: user),
                                  );
                                },
                              ),
                              Replies(docId: docIdList[i]),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        customNavigator(
                            context: context,
                            widget: ReplyUI(
                                comment: Comment(
                                    comment: replies[i].reply,
                                    link: episode.link,
                                    timestamp: replies[i].timestamp,
                                    user: replies[i].user),
                                anime: anime,
                                docId: docIdList[i],
                                episode: episode,
                                user: user));
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}

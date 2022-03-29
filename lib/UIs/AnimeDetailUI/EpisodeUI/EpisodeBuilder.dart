import 'package:animestar/Api/IframeScrapper.dart';
import 'package:animestar/Database/HistoryDatabase.dart';
import 'package:animestar/Database/WatchedListDatabase.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/AnimeHistory.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/CommentUI/comment_ui.dart';
import 'package:animestar/UIs/VideoUI/VideoUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeBuilder extends StatefulWidget {
  final Anime anime;
  final List<Episode> episodeList;
  final List<String> watchedList;
  final MyUser user;
  EpisodeBuilder(
      {@required this.anime,
      @required this.user,
      @required this.episodeList,
      @required this.watchedList});

  @override
  _EpisodeBuilderState createState() => _EpisodeBuilderState();
}

class _EpisodeBuilderState extends State<EpisodeBuilder> {
  @override
  Widget build(BuildContext context) {
    WatchedListDatabase watchedListDatabase =
        WatchedListDatabase(user: widget.user);
    HistoryDatabase historyDatabase = HistoryDatabase(user: widget.user);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Card(
            elevation: 20,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              isThreeLine: true,
              onTap: () {
                watchedListDatabase
                    .add(
                        link: widget.episodeList[i].link,
                        id: widget.anime.title + widget.episodeList[i].title)
                    .then((value) {
                  historyDatabase
                      .add(
                          id: widget.anime.title +
                              " " +
                              widget.episodeList[i].title,
                          history: AnimeHistory(
                              episodeLink: widget.episodeList[i].link,
                              episodeTitle: widget.episodeList[i].title,
                              image: widget.anime.image,
                              link: widget.anime.link,
                              released: widget.anime.released,
                              title: widget.anime.title))
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('Continue')
                        .doc(widget.user.uid)
                        .set(Anime(
                                image: widget.anime.image,
                                link: widget.anime.link,
                                released: widget.anime.released,
                                title: widget.anime.title)
                            .toMap())
                        .then((value) {
                      customNavigator(
                          context: context,
                          widget: VideoUI(
                            link: widget.episodeList[i].link,
                          ));
                    });
                  });
                });
              },
              leading: IconButton(
                  icon: Icon(
                      widget.watchedList.contains(widget.episodeList[i].link)
                          ? Icons.remove_red_eye
                          : Icons.play_arrow),
                  onPressed: () {
                    watchedListDatabase.delete(
                        id: widget.anime.title + widget.episodeList[i].title);
                  }),
              title: Text(widget.episodeList[i].title),
              subtitle: Text(
                  widget.watchedList.contains(widget.episodeList[i].link)
                      ? "Watched"
                      : widget.anime.title),
              trailing: FittedBox(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(MaterialCommunityIcons.chat),
                      onPressed: () {
                        customNavigator(
                            context: context,
                            widget: CommentUI(
                                episode: widget.episodeList[i],
                                user: widget.user,
                                anime: widget.anime));
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.file_download),
                        onPressed: () {
                          return showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Download " +
                                            widget.anime.title +
                                            " " +
                                            widget.episodeList[i].title,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: RaisedButton.icon(
                                            onPressed: () async {
                                              await IframeScrapper()
                                                  .fetchDownload(
                                                      link: widget
                                                          .episodeList[i].link)
                                                  .then(
                                                      (value) => launch(value));
                                            },
                                            icon: Icon(Icons.file_download),
                                            label: Text("Download")),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: widget.episodeList.length,
      ),
    );
  }
}

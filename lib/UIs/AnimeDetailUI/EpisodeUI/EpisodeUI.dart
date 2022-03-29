import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/AnimeDetail.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailBloc.dart';
import 'package:animestar/UIs/AnimeDetailUI/EpisodeUI/EpisodeBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:theme_provider/theme_provider.dart';

class EpisodeUI extends StatefulWidget {
  final Anime anime;

  final MyUser user;
  EpisodeUI({@required this.anime, @required this.user});

  @override
  _EpisodeUIState createState() => _EpisodeUIState();
}

class _EpisodeUIState extends State<EpisodeUI> {
  TextEditingController textEditingController = TextEditingController();
  List<Episode> _searchEpisodeList = [];

  searchEpisode({List<Episode> episodeList}) {
    _searchEpisodeList = episodeList
        .where((element) => element.title
            .toLowerCase()
            .contains(textEditingController.text.toLowerCase()))
        .toList();
  }

  bool isInverted = false;

  invertedController() {
    setState(() {
      isInverted = !isInverted;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  AnimeDetailBloc bloc = AnimeDetailBloc();

  List<Episode> episodeList = [];
  @override
  Widget build(BuildContext context) {
    bloc.update(link: widget.anime.link);
    bool isDark = ThemeProvider.controllerOf(context).currentThemeId == "dark";
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SwipeDetector(
          onSwipeRight: () {
            Navigator.of(context).pop();
          },
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(widget.anime.title),
                actions: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.anime.image),
                  )
                ],
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 20,
                    pinned: true,
                    leading: Center(),
                    leadingWidth: 0,
                    title: ListTile(
                      title: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Episode Number",
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.clear,
                                      color:
                                          isDark ? Colors.white : Colors.black),
                                  onPressed: () {
                                    textEditingController.clear();
                                    _searchEpisodeList.clear();
                                    setState(() {});
                                  })),
                          onChanged: (val) {
                            setState(() {});
                            searchEpisode(episodeList: episodeList);
                          },
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(isInverted
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                          onPressed: () {
                            invertedController();
                          }),
                    ),
                  ),
                  StreamBuilder<AnimeDetail>(
                      stream: bloc.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Column(
                              children: [
                                CircularLoading(),
                                Text("Loading Episodes...")
                              ],
                            ),
                          );
                        }
                        episodeList = snapshot.data.episodes;
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('watchedLists')
                                .doc(widget.user.uid)
                                .collection('watchedLists')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      CircularLoading(),
                                      Text("Checking your watched list...")
                                    ],
                                  ),
                                );
                              }
                              return EpisodeBuilder(
                                watchedList: snapshot.data.docs
                                    .map((e) => e.data()['link'].toString())
                                    .toList(),
                                anime: widget.anime,
                                user: widget.user,
                                episodeList: _searchEpisodeList.isNotEmpty
                                    ? (isInverted
                                        ? _searchEpisodeList
                                        : _searchEpisodeList.reversed.toList())
                                    : isInverted
                                        ? episodeList
                                        : episodeList.reversed.toList(),
                              );
                            });
                      })
                ],
              )),
        ),
      ),
    );
  }
}

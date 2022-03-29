import 'package:animestar/Database/FavoriteDatabase.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/AnimeDetail.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Monetization/FacebookAdService.dart';
import 'package:animestar/Monetization/UnityAdService.dart';
import 'package:animestar/Resources/AnimeDrawer/AnimeDrawer.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailBloc.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailGenreListBuilder.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailHeader.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailInfo.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailStoryLine.dart';
import 'package:animestar/UIs/AnimeDetailUI/EpisodeUI/EpisodeUI.dart';
import 'package:animestar/UIs/AnimeDetailUI/ReviewTextField.dart';
import 'package:animestar/UIs/AnimeDetailUI/Review_Builder.dart';
import 'package:animestar/UIs/AnimeDetailUI/Watcher.dart';
import 'package:animestar/UIs/AnimeDetailUI/Watching.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:unity_ads_flutter/unity_ads_flutter.dart';

class AnimeDetailUI extends StatefulWidget {
  final MyUser user;
  final Anime anime;
  AnimeDetailUI({@required this.user, @required this.anime});
  @override
  _AnimeDetailUIState createState() => _AnimeDetailUIState();
}

class _AnimeDetailUIState extends State<AnimeDetailUI> with UnityAdsListener {
  AnimeDetailBloc animeDetailBloc = AnimeDetailBloc();

  final _key = GlobalKey<ScaffoldState>();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  void favManager(bool docExist) {
    FavoriteDatabase favoriteDatabase = FavoriteDatabase(user: widget.user);
    String topic = widget.anime.title
        .replaceAll(new RegExp(r'[^\w\s]+'), "")
        .split(' ')
        .join('');
    docExist
        ? favoriteDatabase.delete(id: widget.anime.title).then((val) {
            firebaseMessaging.unsubscribeFromTopic(topic).then((value) {
              _key.currentState.showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text(widget.anime.title +
                      " has been unmarked from favorite")));
            });
          })
        : favoriteDatabase
            .add(anime: widget.anime, id: widget.anime.title)
            .then((value) {
            firebaseMessaging.subscribeToTopic(topic).then((value) {
              _key.currentState.showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text(
                      widget.anime.title + " has been marked as favorite")));
            });
          });
  }

  @override
  void initState() {
    // TODO: implement initState
    UnityAdService.iniUnityAd(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    UnityAdService.unityAd();
  }

  @override
  Widget build(BuildContext context) {
    animeDetailBloc.update(link: widget.anime.link);
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SwipeDetector(
          onSwipeRight: () {
            Navigator.of(context).pop();
          },
          onSwipeLeft: () {
            customNavigator(
              context: context,
              widget: EpisodeUI(anime: widget.anime, user: widget.user),
            );
          },
          child: Scaffold(
            key: _key,
            endDrawer: AnimeDrawer(user: widget.user),
            floatingActionButton: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Favorites')
                  .doc(widget.user.uid)
                  .collection('Favorites')
                  .doc(widget.anime.title)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center();
                } else {
                  return FloatingActionButton(
                    key: null,
                    onPressed: () {
                      favManager(snapshot.data.exists);
                    },
                    heroTag: null,
                    backgroundColor: Colors.black,
                    child: Icon(
                        snapshot.data.exists
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white),
                  );
                }
              },
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      AnimeDetailHeader(anime: widget.anime),
                      StreamBuilder<AnimeDetail>(
                        stream: animeDetailBloc.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularLoading();
                          }
                          AnimeDetail animeDetail = snapshot.data;
                          List<String> genreList = animeDetail.genres;

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Watcher(
                                      anime: widget.anime, user: widget.user),
                                  Watching(anime: widget.anime),
                                ],
                              ),
                              AnimeDetailInfo(
                                user: widget.user,
                                animeDetail: animeDetail,
                                released: widget.anime.released,
                              ),
                              AnimeDetailStoryLine(animeDetail: animeDetail),
                              AnimeDetailGenreListBuilder(
                                genreList: genreList,
                                user: widget.user,
                              ),
                              FlatButton.icon(
                                  color: ThemeProvider.controllerOf(context)
                                              .currentThemeId ==
                                          "dark"
                                      ? Colors.black
                                      : Colors.white,
                                  label: Text("Episodes"),
                                  icon: Icon(Icons.forward),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  onPressed: () {
                                    customNavigator(
                                      context: context,
                                      widget: EpisodeUI(
                                          anime: widget.anime,
                                          user: widget.user),
                                    );
                                  }),
                              Divider(),
                              ListTile(
                                title: Text(
                                  "Reviews",
                                  style: GoogleFonts.lato(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                trailing: RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    color: Colors.black,
                                    label: Text(
                                      "add review",
                                      style:
                                          GoogleFonts.lato(color: Colors.white),
                                    ),
                                    icon: Icon(
                                      MaterialCommunityIcons.plus_circle,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title:
                                                  Text("Enter your review!!!"),
                                              content: ReviewTextField(
                                                  episode: Episode(
                                                      link: "",
                                                      title:
                                                          widget.anime.title),
                                                  user: widget.user,
                                                  anime: widget.anime),
                                            );
                                          });
                                    }),
                              ),
                              ReviewBuilder(
                                user: widget.user,
                                anime: widget.anime,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                  Positioned(child: PopNavigator()),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          icon: Icon(FlatIcons.menu),
                          onPressed: () {
                            _key.currentState.openEndDrawer();
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onUnityAdsError(UnityAdsError error, String message) {
    // TODO: implement onUnityAdsError
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    // TODO: implement onUnityAdsFinish
  }

  @override
  void onUnityAdsReady(String placementId) {
    // TODO: implement onUnityAdsReady
  }

  @override
  void onUnityAdsStart(String placementId) {
    // TODO: implement onUnityAdsStart
  }
}

import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/AiringPage/AiringPage.dart';
import 'package:animestar/Pages/HomePage/HomePage.dart';
import 'package:animestar/Pages/LatestPage/LatestPage.dart';
import 'package:animestar/Pages/MyListPage/MyListPage.dart';
import 'package:animestar/Pages/ProfilePage/ProfilePage.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Screens/HomeScreen/HomeScreenBloc.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final MyUser user;
  HomeScreen({@required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_textController.text.isNotEmpty)
      FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).set(
          MyUser(
                  displayName: _textController.text.trim(),
                  email: widget.user.email,
                  photoUrl: widget.user.photoUrl,
                  uid: widget.user.uid)
              .toMap());
  }

  Widget myBody(int index) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("Loading User Info..."),
          );
        } else if (!snapshot.data.exists) {
          return AlertDialog(
            title: Text("Choose your display name!!!"),
            content: TextFormField(
              controller: _textController,
              onChanged: (val) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: "Display Name...",
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: _textController.text.isEmpty ? null : submit,
                child: Text("Submit"),
              )
            ],
          );
        } else {
          MyUser user = MyUser.fromDoc(snapshot.data);
          return _pages(user)[index];
        }
      },
    );
  }

  List<Widget> _pages(MyUser user) => [
        HomePage(user: user),
        LatestPage(
          user: user,
          isNav: false,
        ),
        MyListPage(
          user: user,
          isNav: false,
        ),
        AiringPage(
          user: user,
          isNav: false,
        ),
        ProfilePage(user: user)
      ];

  HomeScreenBloc homeScreenBloc = HomeScreenBloc();

  List<BottomNavigationBarItem> get _bottomItems => [
        BottomNavigationBarItem(icon: Icon(FlatIcons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: "Latest"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
        BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.calendar), label: "Airing"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ];

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> data) async {
      Anime anime = Anime.fromDynamic(data['data']);
      customNavigator(
          context: context,
          widget: AnimeDetailUI(user: widget.user, anime: anime));
    }, onMessage: (Map<String, dynamic> data) async {
      // Anime anime = Anime.fromDynamic(data['data']);
      // customNavigator(
      //     context: context,
      //     widget: AnimeDetailUI(user: widget.user, anime: anime));
    }, onResume: (Map<String, dynamic> data) async {
      Anime anime = Anime.fromDynamic(data['data']);
      customNavigator(
          context: context,
          widget: AnimeDetailUI(user: widget.user, anime: anime));
    });
    setState(() {
      _textController.text = widget.user.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 0,
        stream: homeScreenBloc.stream,
        builder: (context, snapshot) {
          return ThemeConsumer(
            child: Scaffold(
              body: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AnimeUltimate')
                      .doc('animeultimatealertv13')
                      .snapshots(),
                  builder: (context, alertsnapshot) {
                    if (!alertsnapshot.hasData) {
                      return Center(
                        child: Loading(
                          color: Colors.blue,
                          indicator: BallScaleIndicator(),
                        ),
                      );
                    } else if (!alertsnapshot.data.exists) {
                      return myBody(snapshot.data);
                    } else if (alertsnapshot.data.exists) {
                      return AlertDialog(
                        content: Column(
                          children: [
                            Text(alertsnapshot.data.data()['title']),
                            Image.network(alertsnapshot.data.data()['image']),
                            Text(alertsnapshot.data.data()['content']),
                          ],
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () async {
                                await launch(alertsnapshot.data.data()['link']);
                              },
                              child: Text(alertsnapshot.data.data()['btnName']))
                        ],
                      );
                    }
                    return myBody(snapshot.data);
                  }),
              bottomNavigationBar: BottomNavigationBar(
                items: _bottomItems,
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Colors.red,
                selectedIconTheme: IconThemeData(size: 30),
                iconSize: 25,
                unselectedItemColor: Colors.grey,
                currentIndex: snapshot.data,
                onTap: (index) => homeScreenBloc.update(index: index),
              ),
            ),
          );
        });
  }
}

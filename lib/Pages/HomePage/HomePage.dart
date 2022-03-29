import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/HomePage/components/ContinueWatching/ContinueWatching.dart';
import 'package:animestar/Pages/HomePage/components/CustomtileBuilder/CustomTileBuilder.dart';
import 'package:animestar/Pages/HomePage/components/GenreBuilder/GenreBuilder.dart';
import 'package:animestar/Pages/HomePage/components/SeasonBuilder.dart/SeasonSlider.dart';
import 'package:animestar/Pages/HomePage/components/TrendingBuilder/TrendingBuilder.dart';
import 'package:animestar/Resources/AnimeDrawer/AnimeDrawer.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:animestar/UIs/NotificationUI/NotificationUI.dart';
import 'package:animestar/UIs/SearchUI/SearchUI.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class HomePage extends StatelessWidget {
  final MyUser user;
  HomePage({@required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: AnimeDrawer(user: user),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              title: GenreBuilder(user: user),
              centerTitle: false,
              titlePadding: EdgeInsets.all(16),
            ),
            actions: [
              IconButton(
                icon: Icon(FlatIcons.notification),
                onPressed: () {
                  customNavigator(
                    context: context,
                    widget: NotificationsUI(),
                  );
                },
              ),
              IconButton(
                icon: Icon(FlatIcons.search),
                onPressed: () {
                  customNavigator(
                      context: context, widget: SearchUI(user: user));
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: CustomTilesBuilder(
              user: user,
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: Icon(FontAwesome.fire),
              title: Text("Trending"),
              trailing: Icon(Icons.forward),
              onTap: () {
                customNavigator(
                    context: context,
                    widget: AnimeUI(
                        type: "popular", genre: "Trending", user: user));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: TrendingBuilder(user: user),
          ),
          SliverToBoxAdapter(
            child: SeasonSlider(user: user),
          ),
          SliverToBoxAdapter(
            child: ContinueWatchingSlider(user: user),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}

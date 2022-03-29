import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/HomePage/components/CustomtileBuilder/CustomTile.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomTilesBuilder extends StatefulWidget {
  final MyUser user;
  CustomTilesBuilder({this.user});
  @override
  _CustomTilesBuilderState createState() => _CustomTilesBuilderState();
}

class _CustomTilesBuilderState extends State<CustomTilesBuilder> {
  List<Map<String, dynamic>> get items => [
        {
          "title": "Popular",
          "icon": Icons.people,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user, genre: 'Popular', type: 'popular'));
          }
        },
        {
          "title": "Movies",
          "icon": MaterialCommunityIcons.movie,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user, genre: 'Movies', type: 'movies'));
          }
        },
        {
          "title": "DUB",
          "icon": MaterialCommunityIcons.translate,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user, genre: 'Dubbed Anime', type: 'dub'));
          }
        },
        {
          "title": "New Releases",
          "icon": MaterialCommunityIcons.new_box,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user,
                    genre: 'New Releases',
                    type: 'newseason'));
          }
        },
        {
          "title": "OVA Series",
          "icon": MaterialCommunityIcons.timelapse,
          "onTap": () {
            customNavigator(
                context: context,
                widget:
                    AnimeUI(user: widget.user, genre: 'OVA', type: 'season'));
          }
        },
        {
          "title": "ONA Series",
          "icon": MaterialCommunityIcons.scatter_plot,
          "onTap": () {
            customNavigator(
                context: context,
                widget:
                    AnimeUI(user: widget.user, genre: 'ONA', type: 'season'));
          }
        },
        {
          "title": "TV Series",
          "icon": Icons.tv,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user, genre: 'TV Series', type: 'season'));
          }
        },
        {
          "title": "Special",
          "icon": MaterialCommunityIcons.star,
          "onTap": () {
            customNavigator(
                context: context,
                widget: AnimeUI(
                    user: widget.user, genre: 'Special', type: 'season'));
          }
        },
      ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.14,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, i) {
              return CustomTile(
                icon: items[i]['icon'],
                onTap: items[i]['onTap'],
                title: items[i]['title'],
              );
            }));
  }
}

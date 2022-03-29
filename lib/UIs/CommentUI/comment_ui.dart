import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:animestar/UIs/CommentUI/comment_builder.dart';
import 'package:animestar/UIs/CommentUI/comment_textfield.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CommentUI extends StatelessWidget {
  final Episode episode;
  final MyUser user;
  final Anime anime;
  CommentUI(
      {@required this.episode, @required this.user, @required this.anime});
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
              Expanded(
                child:
                    CommentBuilder(episode: episode, user: user, anime: anime),
              ),
              CommentTextField(episode: episode, user: user, anime: anime),
            ],
          ),
        ),
      ),
    );
  }
}

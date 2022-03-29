import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomGridView extends StatelessWidget {
  final MyUser user;
  final List<Anime> items;
  CustomGridView({@required this.items, @required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemCount: (items.length),
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            customNavigator(
                context: context,
                widget: AnimeDetailUI(user: user, anime: items[i]));
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      items[i].image,
                      fit: BoxFit.cover,
                    )),
              ),
              Text(
                items[i].title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(items[i].released),
            ],
          ),
        );
      },
    );
  }
}

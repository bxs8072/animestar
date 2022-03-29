import 'package:animestar/Database/FavoriteDatabase.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBuilder extends StatelessWidget {
  final MyUser user;
  final List<Anime> items;
  CustomBuilder({@required this.items, @required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FavoriteDatabase favoriteDatabase = FavoriteDatabase(user: user);

    return GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.width > size.height ? 5 : 3,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10),
      itemCount: (items.length),
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            customNavigator(
                context: context,
                widget: AnimeDetailUI(user: user, anime: items[i]));
          },
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Do you want to remove ${items[i].title} from your list?',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.ubuntu(fontSize: size.height * 0.03),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.check_box,
                                  size: 40,
                                ),
                                onPressed: () {
                                  favoriteDatabase.delete(id: items[i].title);
                                  Navigator.of(context).pop();
                                }),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 40,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      )
                    ],
                  );
                });
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: items[i].image,
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

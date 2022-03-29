import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/HomePage/components/GenreBuilder/genre_list.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class GenreBuilder extends StatelessWidget {
  final MyUser user;
  GenreBuilder({@required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.035,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: genreList.length,
        itemBuilder: (context, i) {
          return FlatButton(
            child: Text(
              genreList[i],
              style: GoogleFonts.vollkorn(color: Colors.white),
            ),
            onPressed: () {
              customNavigator(
                  context: context,
                  widget:
                      AnimeUI(type: "genre", genre: genreList[i], user: user));
            },
          );
        },
      ),
    );
  }
}

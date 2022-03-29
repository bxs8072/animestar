import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/GenreList.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeasonSlider extends StatelessWidget {
  final MyUser user;
  SeasonSlider({@required this.user});

  final Resources resources = Resources();
  @override
  Widget build(BuildContext context) {
    List<String> seasonList = resources.seasonList;

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.06,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          primary: false,
          itemCount: seasonList.length,
          itemBuilder: (context, i) {
            return Container(
              child: FlatButton(
                child: Text(
                  seasonList[i],
                  style: GoogleFonts.lato(color: Colors.blue),
                ),
                onPressed: () {
                  customNavigator(
                      context: context,
                      widget: AnimeUI(
                          genre: seasonList[i] + " Anime",
                          type: 'season',
                          user: user));
                },
              ),
            );
          }),
    );
  }
}

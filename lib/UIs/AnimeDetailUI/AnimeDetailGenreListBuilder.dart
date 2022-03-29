import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDetailGenreListBuilder extends StatelessWidget {
  final List<String> genreList;
  final MyUser user;
  AnimeDetailGenreListBuilder({@required this.genreList, @required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.06,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: genreList.length,
        itemBuilder: (context, i) {
          return FlatButton(
              onPressed: () {
                customNavigator(
                    context: context,
                    widget: AnimeUI(
                        genre: genreList[i], type: 'genre', user: user));
              },
              child: Text(
                genreList[i],
                style: GoogleFonts.lato(color: Colors.blue),
              ));
        },
      ),
    );
  }
}

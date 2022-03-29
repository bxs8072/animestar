import 'package:animestar/Models/AnimeDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDetailStoryLine extends StatelessWidget {
  final AnimeDetail animeDetail;
  AnimeDetailStoryLine({@required this.animeDetail});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RaisedButton.icon(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      animeDetail.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: size.height * 0.027),
                    ),
                  ),
                ],
              ));
            });
      },
      icon: Icon(Icons.more, color: Colors.white),
      label: Text(
        "Storyline",
        style: GoogleFonts.ubuntu(
            fontSize: size.height * 0.02, color: Colors.white),
      ),
    );
  }
}

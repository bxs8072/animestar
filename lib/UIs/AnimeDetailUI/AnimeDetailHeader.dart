import 'dart:ui';

import 'package:animestar/Models/Anime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDetailHeader extends StatelessWidget {
  final Anime anime;
  AnimeDetailHeader({@required this.anime});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height / 2.6,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  anime.image,
                ),
                alignment: Alignment.center,
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  anime.image,
                  height: height / 3,
                  width: width / 2,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            anime.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.vollkorn(fontSize: height * 0.03),
          ),
        )
      ],
    );
  }
}

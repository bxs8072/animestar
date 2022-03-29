import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeUIHeader extends StatelessWidget {
  final String genre;
  AnimeUIHeader({this.genre});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        genre,
        textAlign: TextAlign.center,
        style: GoogleFonts.vollkorn(
            fontWeight: FontWeight.bold, fontSize: size.height * 0.034),
      ),
    );
  }
}

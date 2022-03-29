import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchApi {
  static OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  static Padding header(double fontSize) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Search Anime",
          textAlign: TextAlign.center,
          style: GoogleFonts.vollkorn(
              fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      );
}

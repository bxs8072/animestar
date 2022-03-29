import 'package:animestar/Models/AnimeDetail.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDetailInfo extends StatelessWidget {
  final AnimeDetail animeDetail;
  final MyUser user;
  final String released;
  AnimeDetailInfo(
      {@required this.animeDetail,
      @required this.user,
      @required this.released});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    TextStyle style = GoogleFonts.ubuntu(
        fontSize: size.height * 0.02, fontWeight: FontWeight.bold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          released.contains("Epi")
                              ? "LAST EPISODE"
                              : "RELEASED",
                          style: style,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          released.contains(":")
                              ? released.split(':')[1].trim()
                              : released,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  customNavigator(
                      context: context,
                      widget: AnimeUI(
                          genre: animeDetail.season,
                          type: 'season',
                          user: user));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "SEASON",
                            style: style,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            animeDetail.season,
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "STATUS",
                          style: style,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          animeDetail.status,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Other Names: " + animeDetail.otherName,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ],
    );
  }
}

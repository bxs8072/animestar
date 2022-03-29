import 'package:animestar/Api/AiringAnimeScrapper.dart';
import 'package:animestar/Models/AiringAnime.dart';
import 'package:animestar/Models/AiringAnimeDetail.dart';
import 'package:animestar/Pages/AiringPage/AiringDetailUI/CharactersBuilder.dart';
import 'package:animestar/Pages/AiringPage/AiringDetailUI/Header.dart';
import 'package:animestar/Pages/AiringPage/AiringDetailUI/StaffsBuilder.dart';
import 'package:animestar/Pages/AiringPage/AiringDetailUI/StudioBuilder.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';
import 'package:theme_provider/theme_provider.dart';

class AiringAnimeDetailUI extends StatefulWidget {
  final AiringAnime airingAnime;
  final int id;
  AiringAnimeDetailUI({this.id, this.airingAnime});

  @override
  _AiringAnimeDetailUIState createState() => _AiringAnimeDetailUIState();
}

class _AiringAnimeDetailUIState extends State<AiringAnimeDetailUI> {
  AiringAnimeScrapper scrapper = AiringAnimeScrapper();
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: FutureBuilder(
            future: scrapper.fetch(id: widget.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(
                        indicator: BallScaleMultipleIndicator(),
                        color: Colors.blue,
                      ),
                      Text(
                        "Anime Schedule is Loading",
                        style: GoogleFonts.ubuntu(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      )
                    ],
                  ),
                );
              }
              AiringAnimeDetail airingAnimeDetail = snapshot.data;
              return SafeArea(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Header(airingAnime: widget.airingAnime),
                        Center(
                          child: Text(
                            DateFormat('EEEE').format(
                                    widget.airingAnime.airingAt.toDate()) +
                                " at " +
                                DateFormat().add_jm().format(
                                    widget.airingAnime.airingAt.toDate()),
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          airingAnimeDetail.timeUntilAiring + "left",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "NEXT AIRING: EPISODE " +
                                airingAnimeDetail.nextAiringEpisode.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "DURATION",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.duration.toString() +
                                        " minutes",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "COUNTRY",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.countryOfOrigin,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "SEASON",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.season,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.airingAnime.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                          ),
                        ),
                        widget.airingAnime.synonyms.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SYNONYMS: " +
                                      widget.airingAnime.synonyms.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "STATUS",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.status,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "EPISODE",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.episode.toString() +
                                        " episodes",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "START DATE",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                  Text(
                                    widget.airingAnime.startDate,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        airingAnimeDetail.characterList.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CharactersBuilder(
                                  characters: airingAnimeDetail.characterList,
                                ),
                              ),
                        airingAnimeDetail.staffList.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StaffsBuilder(
                                  staffs: airingAnimeDetail.staffList,
                                ),
                              ),
                        airingAnimeDetail.studioList.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StudioBuilder(
                                  studios: airingAnimeDetail.studioList,
                                ),
                              )
                      ],
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: PopNavigator(),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}

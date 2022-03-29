import 'package:animestar/Api/AiringAnimeScrapper.dart';
import 'package:animestar/Models/AiringAnime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/AiringPage/AiringDetailUI/AiringAnimeDetailUI.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';
import 'package:theme_provider/theme_provider.dart';

class AiringPage extends StatelessWidget {
  final MyUser user;
  final bool isNav;
  AiringPage({@required this.user, @required this.isNav});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AiringAnime>>(
        future: AiringAnimeScrapper().fetchAll(),
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Loading(
                indicator: BallScaleMultipleIndicator(),
                color: Colors.blue,
              ),
            );
          }
          List<AiringAnime> items = [];
          snapshot.data.forEach((element) {
            if (!items.contains(element)) {
              items.add(element);
            }
          });
          return items.isEmpty
              ? ThemeConsumer(
                  child: Scaffold(
                    body: Center(
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
                    ),
                  ),
                )
              : ThemeConsumer(
                  child: Scaffold(
                    body: SafeArea(
                      child: Stack(
                        children: [
                          ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "Anime Airing",
                                    style: GoogleFonts.vollkorn(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, i) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: ListTile(
                                          onTap: () {
                                            customNavigator(
                                              context: context,
                                              widget: AiringAnimeDetailUI(
                                                id: items[i].id,
                                                airingAnime: items[i],
                                              ),
                                            );
                                          },
                                          contentPadding: EdgeInsets.all(12),
                                          title: Image.network(
                                            items[i].coverImage,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  DateFormat('EEEE').format(
                                                          items[i]
                                                              .airingAt
                                                              .toDate()) +
                                                      " at " +
                                                      DateFormat()
                                                          .add_jm()
                                                          .format(items[i]
                                                              .airingAt
                                                              .toDate()),
                                                  style: GoogleFonts.lato(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  items[i].title,
                                                  style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                ),
                                              ),
                                              items[i].title ==
                                                      items[i].nativetitle
                                                  ? Text("")
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        items[i].nativetitle,
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02),
                                                      ),
                                                    ),
                                              items[i].synonyms.isEmpty
                                                  ? Container()
                                                  : Text("Synonyms: " +
                                                      items[i]
                                                          .synonyms
                                                          .toString()),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "STATUS",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                          items[i].status,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "EPISODE",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                          items[i]
                                                              .episode
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "START DATE",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                          items[i].startDate,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }),
                            ],
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: isNav ? PopNavigator() : Center())
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}

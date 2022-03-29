import 'package:animestar/Api/AnimeScrapper.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingBuilder extends StatelessWidget {
  final MyUser user;
  TrendingBuilder({@required this.user});

  final _animeApi = AnimeScrapper();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<Anime>>(
        future: _animeApi.fetchAnimeByType(
            genre: "Popular", page: 1, type: "popular"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularLoading();
          }
          List<Anime> _items = snapshot.data;
          return CarouselSlider(
              items: _items.map((anime) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        customNavigator(
                            context: context,
                            widget: AnimeDetailUI(user: user, anime: anime));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              anime.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              anime.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: size.height * 0.35,
                aspectRatio: 16 / 9,
                viewportFraction: 0.5,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ));
        });
  }
}

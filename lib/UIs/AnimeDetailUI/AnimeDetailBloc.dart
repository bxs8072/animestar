import 'dart:async';

import 'package:animestar/Api/AnimeDetailScrapper.dart';
import 'package:animestar/Models/AnimeDetail.dart';

class AnimeDetailBloc {
  AnimeDetailScrapper scrapper = AnimeDetailScrapper();
  StreamController<AnimeDetail> controller =
      StreamController<AnimeDetail>.broadcast();
  Stream<AnimeDetail> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  update({String link}) {
    scrapper
        .fetchAnimeDetail(link: link)
        .then((animeDetail) => controller.sink.add(animeDetail));
  }
}

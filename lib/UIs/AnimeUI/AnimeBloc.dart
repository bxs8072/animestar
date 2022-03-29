import 'dart:async';
import 'package:animestar/Api/AnimeScrapper.dart';
import 'package:animestar/Models/Anime.dart';

class AnimeBloc {
  AnimeScrapper _scrapper = AnimeScrapper();

  StreamController<List<Anime>> _controller =
      StreamController<List<Anime>>.broadcast();
  Stream<List<Anime>> get stream => _controller.stream.asBroadcastStream();

  dispose() {
    _controller.close();
  }

  add({int page, String type, String genre}) async {
    final data =
        await _scrapper.fetchAnimeByType(page: page, type: type, genre: genre);
    _controller.sink.add(data);
  }
}

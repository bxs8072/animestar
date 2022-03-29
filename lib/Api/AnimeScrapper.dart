import 'dart:convert';
import 'package:animestar/Models/Anime.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class AnimeScrapper {
  Future<List<Anime>> fetchAnimeByType(
      {String type, String genre, int page}) async {
    var response;
    if (type == "popular") {
      response = await http.get(baseUrl + "/popular/$page");
    } else if (type == "latestsubanime") {
      response = await http.get(baseUrl + "/latestanime/$page");
    } else if (type == "latestdubanime") {
      response = await http.get(baseUrl + "/latestdubanime/$page");
    } else if (type == "latestchineseanime") {
      response = await http.get(baseUrl + "/latestchineseanime/$page");
    } else if (type == "dub") {
      response = await http.get(baseUrl + "/dub/$page");
    } else if (type == "movies") {
      response = await http.get(baseUrl + "/movies/$page");
    } else if (type == "newseason") {
      response = await http.get(baseUrl + "/newseason/$page");
    } else if (type == "search") {
      response = await http.post(baseUrl + "/search", body: {"keyword": genre});
    } else if (type == "genre") {
      response = await http.post(baseUrl + "/genre",
          body: {"genre": genre, "page": page.toString()});
      print(response.body);
    } else if (type == "season") {
      response = await http.post(baseUrl + "/season",
          body: {"season": genre, "page": page.toString()});
    }

    var body = json.decode(response.body)['animeList'] as List;
    List<Anime> animeList = body.map((e) => Anime.fromDynamic(e)).toList();
    return animeList;
  }
}

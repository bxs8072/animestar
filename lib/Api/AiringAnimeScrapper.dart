import 'dart:convert';
import 'package:animestar/Models/AiringAnime.dart';
import 'package:animestar/Models/AiringAnimeDetail.dart';
import 'package:animestar/main.dart';
import 'package:http/http.dart' as http;

class AiringAnimeScrapper {
  Future<List<AiringAnime>> fetchAll() async {
    var response = await http.get(baseUrl + '/airinganime');
    var data = json.decode(response.body)['list'] as List;
    List<AiringAnime> items = [];
    data.forEach((e) {
      items.add(AiringAnime.fromDynamic(e));
    });
    return items;
  }

  Future<AiringAnimeDetail> fetch({int id}) async {
    var response = await http.get(baseUrl + '/airinganime/$id');
    var data = json.decode(response.body)['data'];
    AiringAnimeDetail airingAnimeDetail = AiringAnimeDetail.fromDynamic(data);
    return airingAnimeDetail;
  }
}

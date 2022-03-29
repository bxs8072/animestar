import 'dart:convert';

import 'package:animestar/Models/AnimeDetail.dart';
import 'package:animestar/main.dart';
import 'package:http/http.dart' as http;

class AnimeDetailScrapper {
  Future<AnimeDetail> fetchAnimeDetail({String link}) async {
    var response = await http.post(baseUrl + "/detail", body: {'link': link});
    var data = json.decode(response.body);
    return AnimeDetail.fromDynamic(data);
  }
}

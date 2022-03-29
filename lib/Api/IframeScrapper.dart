import 'dart:convert';
import 'package:animestar/main.dart';
import 'package:http/http.dart' as http;

class IframeScrapper {
  Future<String> fetchIframe({String link}) async {
    var res = await http.post(baseUrl + "/iframe", body: {"link": link});
    return json.decode(res.body)['iframeLink'].toString();
  }

  Future<String> fetchDownload({String link}) async {
    var res = await http.post(baseUrl + "/iframe", body: {"link": link});
    return json.decode(res.body)['downloadLink'].toString();
  }
}

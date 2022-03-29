import 'dart:async';

import 'package:animestar/Api/IframeScrapper.dart';

class VideoBloc {
  StreamController<String> controller = StreamController<String>.broadcast();

  Stream<String> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  update(String link) async {
    IframeScrapper _iframeScrapper = IframeScrapper();
    String url = await _iframeScrapper.fetchIframe(link: link);
    controller.sink.add(url);
  }
}

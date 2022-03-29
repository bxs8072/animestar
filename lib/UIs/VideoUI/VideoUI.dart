import 'package:animestar/Monetization/FacebookAdService.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/UIs/VideoUI/VideoApi.dart';
import 'package:animestar/UIs/VideoUI/VideoBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoUI extends StatefulWidget {
  final String link;
  VideoUI({this.link});
  @override
  _VideoUIState createState() => _VideoUIState();
}

class _VideoUIState extends State<VideoUI> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // UnityAdService.unityRewardedAd();
    FacebookAdService.facebookAd2();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FacebookAdService.facebookAd();
  }

  VideoBloc videoBloc = VideoBloc();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    double height = MediaQuery.of(context).size.height;
    double width = height * 16 / 9;
    videoBloc.update(widget.link);
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<String>(
          stream: videoBloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularLoading();
            }
            String iframelink = snapshot.data;
            return Center(
              child: Container(
                width: width,
                height: height,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: Uri.dataFromString(
                    VideoApi.url(iframelink),
                    mimeType: 'text/html',
                  ).toString(),
                ),
              ),
            );
          }),
    );
  }
}

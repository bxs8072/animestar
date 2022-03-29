import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/LatestPage/LatestAnimeBloc.dart';
import 'package:animestar/Resources/CustomGridView.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';

class LatestDubPage extends StatefulWidget {
  final MyUser user;
  LatestDubPage({@required this.user});
  @override
  _LatestDubPageState createState() => _LatestDubPageState();
}

class _LatestDubPageState extends State<LatestDubPage> {
  LatestAnimeBloc _bloc = LatestAnimeBloc();
  final _controller = ScrollController();
  String _type = "latestdubanime";
  int _page = 1;

  List<Anime> _items = [];

  initScroller() {
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _bloc.add(page: _page, type: _type);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(page: _page, type: _type);
    initScroller();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: [
        StreamBuilder<List<Anime>>(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(
                        indicator: BallScaleMultipleIndicator(),
                        color: Colors.blue,
                      ),
                      Text("Latest Dub Animes Loading...."),
                    ],
                  ),
                );
              }
              for (var u in snapshot.data) {
                if (!_items.contains(u)) {
                  _items.addAll(snapshot.data);
                }
              }
              return CustomGridView(
                user: widget.user,
                items: _items,
              );
            }),
        Center(
            child: _items.isEmpty
                ? Container()
                : Loading(
                    indicator: BallScaleMultipleIndicator(),
                    color: Colors.blue,
                  ))
      ],
    );
  }
}

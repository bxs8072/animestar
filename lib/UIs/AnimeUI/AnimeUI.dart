import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/AnimeDrawer/AnimeDrawer.dart';
import 'package:animestar/Resources/CustomGridView.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:animestar/UIs/AnimeUI/AnimeBloc.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUIHeader.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';
import 'package:theme_provider/theme_provider.dart';

class AnimeUI extends StatefulWidget {
  final String type, genre;
  final MyUser user;
  AnimeUI({@required this.genre, @required this.type, @required this.user});
  @override
  _AnimeUIState createState() => _AnimeUIState();
}

class _AnimeUIState extends State<AnimeUI> {
  AnimeBloc _bloc = AnimeBloc();
  final _controller = ScrollController();
  String get _type => widget.type;
  String get _genre => widget.genre;
  int _page = 1;

  List<Anime> _items = [];

  initScroller() {
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _bloc.add(page: _page, type: _type, genre: _genre);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(page: _page, type: _type, genre: _genre);
    initScroller();
  }

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        key: _key,
        endDrawer: AnimeDrawer(user: widget.user),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                controller: _controller,
                children: [
                  AnimeUIHeader(
                    genre: _genre,
                  ),
                  StreamBuilder<List<Anime>>(
                      stream: _bloc.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Loading(
                              indicator: BallScaleMultipleIndicator(),
                              color: Colors.blue,
                            ),
                          );
                        }
                        for (var u in snapshot.data) {
                          if (!_items.contains(u)) {
                            _items.addAll(snapshot.data);
                          }
                        }
                        return CustomGridView(
                          items: _items,
                          user: widget.user,
                        );
                      }),
                  Center(
                    child: _items.isEmpty
                        ? Container()
                        : Loading(
                            indicator: BallScaleMultipleIndicator(),
                            color: Colors.blue,
                          ),
                  ),
                ],
              ),
              Positioned(
                left: 5,
                top: 5,
                child: PopNavigator(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      icon: Icon(FlatIcons.menu),
                      onPressed: () {
                        _key.currentState.openEndDrawer();
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

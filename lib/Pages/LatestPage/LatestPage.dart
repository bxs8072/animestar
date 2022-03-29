import 'package:animestar/Models/User.dart';
import 'package:animestar/Pages/LatestPage/LatestChinesePage.dart';
import 'package:animestar/Pages/LatestPage/LatestDubPage.dart';
import 'package:animestar/Pages/LatestPage/LatestSubPage.dart';
import 'package:animestar/Resources/PopNavigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class LatestPage extends StatefulWidget {
  final MyUser user;
  final bool isNav;
  LatestPage({@required this.user, @required this.isNav});

  @override
  _LatestPageState createState() => _LatestPageState();
}

class _LatestPageState extends State<LatestPage> {
  List<Widget> get _pages => [
        LatestSubPage(user: widget.user),
        LatestDubPage(user: widget.user),
        LatestChinesePage(user: widget.user)
      ];

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      initialIndex: _index,
      child: ThemeConsumer(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: widget.isNav ? PopNavigator() : Container(),
            title: Text(
              "Latest Released",
              style: GoogleFonts.vollkorn(
                  fontWeight: FontWeight.bold, fontSize: size.height * 0.034),
            ),
            bottom: TabBar(
                indicatorColor: Colors.red,
                onTap: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Sub"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Dub"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Chinese"),
                  ),
                ]),
          ),
          body: _pages[_index],
        ),
      ),
    );
  }
}

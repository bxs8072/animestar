import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomGridView.dart';
import 'package:animestar/Resources/Loading.dart';
import 'package:animestar/UIs/AnimeUI/AnimeBloc.dart';
import 'package:animestar/UIs/SearchUI/SearchApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchUI extends StatefulWidget {
  final MyUser user;
  SearchUI({@required this.user});
  @override
  _SearchUIState createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  AnimeBloc bloc = AnimeBloc();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: ThemeConsumer(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(
                  "Search Anime",
                  style: GoogleFonts.vollkorn(),
                ),
              ),
              SliverStickyHeader(
                  sticky: true,
                  header: Card(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          // contentPadding: EdgeInsets.all(8.0),
                          hintText: "Search Anime",
                          border: SearchApi.border(Colors.blue),
                          disabledBorder: SearchApi.border(Colors.grey),
                          enabledBorder: SearchApi.border(Colors.white),
                          errorBorder: SearchApi.border(Colors.red),
                          focusedBorder: SearchApi.border(Colors.teal),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                textEditingController.clear();
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              })),
                      onChanged: (val) {
                        setState(() {});
                        bloc.add(genre: val, page: 1, type: 'search');
                      },
                    ),
                  ),
                  sliver: StreamBuilder<List<Anime>>(
                      stream: bloc.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: size.height * 0.2),
                                  Icon(Icons.search, size: 80),
                                  SizedBox(height: 20),
                                  Text("Search Anime",
                                      style: GoogleFonts.lato(
                                          fontSize: size.height * 0.035))
                                ],
                              ),
                            ),
                          );
                        }
                        List<Anime> _items = snapshot.data;
                        return _items.isEmpty
                            ? SliverToBoxAdapter(child: CircularLoading())
                            : SliverToBoxAdapter(
                                child: CustomGridView(
                                    items: _items, user: widget.user),
                              );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

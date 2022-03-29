import 'package:animestar/Database/HistoryDatabase.dart';
import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/AnimeHistory.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/UIs/AnimeDetailUI/AnimeDetailUI.dart';
import 'package:animestar/UIs/VideoUI/VideoUI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryBuilder extends StatelessWidget {
  final List<AnimeHistory> historyList;
  final MyUser user;
  HistoryBuilder({@required this.user, @required this.historyList});
  @override
  Widget build(BuildContext context) {
    HistoryDatabase historyDatabase = HistoryDatabase(user: user);
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: historyList.length,
        itemBuilder: (context, i) {
          return Dismissible(
              key: ValueKey(historyList[i]),
              direction: DismissDirection.endToStart,
              onDismissed: (val) {
                historyDatabase.delete(
                    id: historyList[i].title +
                        " " +
                        historyList[i].episodeTitle);
              },
              confirmDismiss: (val) {
                return showModalBottomSheet(
                    context: context,
                    builder: (context) => ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Do you want to remove ${historyList[i].title} ${historyList[i].episodeTitle} from the list?",
                                style: GoogleFonts.ubuntu(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.check_box,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      }),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ));
              },
              background: ListTile(trailing: Icon(Icons.delete_sweep)),
              child: ListTile(
                leading: GestureDetector(
                    onTap: () {
                      customNavigator(
                          context: context,
                          widget: AnimeDetailUI(
                              user: user,
                              anime: Anime(
                                  image: historyList[i].image,
                                  link: historyList[i].link,
                                  released: historyList[i].released,
                                  title: historyList[i].title)));
                    },
                    child: CachedNetworkImage(imageUrl: historyList[i].image)),
                title: Text(historyList[i].episodeTitle),
                onTap: () {
                  customNavigator(
                      context: context,
                      widget: VideoUI(
                        link: historyList[i].link,
                      ));
                },
                subtitle: Text(historyList[i].title),
              ));
        });
  }
}

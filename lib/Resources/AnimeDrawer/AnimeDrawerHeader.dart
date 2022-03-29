import 'package:animestar/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDrawerHeader extends StatelessWidget {
  final MyUser user;
  AnimeDrawerHeader({@required this.user});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          elevation: 10,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: size.height * 0.06,
                backgroundImage: NetworkImage(user.photoUrl),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Hi, ' + user.displayName,
            style: GoogleFonts.ubuntu(fontSize: size.height * 0.03),
          ),
        ),
        Divider()
      ],
    );
  }
}

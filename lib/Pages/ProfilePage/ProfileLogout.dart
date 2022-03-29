import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileLogout extends StatelessWidget {
  final AuthBase auth;
  ProfileLogout({@required this.auth});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: IconButton(
          icon: Icon(MaterialCommunityIcons.logout),
          onPressed: () {
            return showModalBottomSheet(
                context: context,
                builder: (context) => ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Do you want to logout from Anime Strom?',
                            style: GoogleFonts.ubuntu(
                                fontSize: size.height * 0.03),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.check_box,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      auth.signOut();
                                      Navigator.of(context).pop(true);
                                    }),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
          }),
    );
  }
}

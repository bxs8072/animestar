import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.controllerOf(context).currentThemeId;
    bool darkMode = theme == "dark";
    return ListTile(
      leading: Icon(FeatherIcons.cloudLightning),
      title: Text(
        "Theme Controller",
        style: GoogleFonts.lato(),
      ),
      subtitle: Text(
        "change you theme",
        style: GoogleFonts.lato(),
      ),
      trailing: FlatButton.icon(
        label: Text(darkMode ? "dark" : "light"),
        icon: Icon(darkMode
            ? MaterialCommunityIcons.lightbulb_off
            : MaterialCommunityIcons.lightbulb_on),
        onPressed: () {
          ThemeProvider.controllerOf(context).nextTheme();
        },
      ),
    );
  }
}

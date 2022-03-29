import 'package:animestar/Models/User.dart';
import 'package:animestar/Resources/CustomNavigator.dart';
import 'package:animestar/Resources/GenreList.dart';
import 'package:animestar/UIs/AnimeUI/AnimeUI.dart';
import 'package:flutter/material.dart';

class GenreDropdown extends StatelessWidget {
  final MyUser user;
  GenreDropdown({@required this.user});

  final resources = Resources();
  List<DropdownMenuItem> get _dropdownItems => resources.genreList
      .map((e) => DropdownMenuItem(
            child: Text(e),
            value: e,
          ))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton(
            icon: Icon(Icons.arrow_drop_down),
            hint: Text("Select Genre"),
            items: _dropdownItems,
            underline: Container(),
            onChanged: (value) {
              customNavigator(
                  context: context,
                  widget: AnimeUI(user: user, genre: value, type: 'genre'));
            },
          ),
        ),
      ),
    );
  }
}

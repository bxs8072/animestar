import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CommentTextField extends StatefulWidget {
  final MyUser user;
  final Episode episode;
  final Anime anime;
  CommentTextField(
      {@required this.episode, @required this.user, @required this.anime});
  @override
  _CommentTextFieldState createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_textController.text.isNotEmpty) {
      Comment comment = Comment(
          comment: _textController.text.trim(),
          link: widget.episode.link,
          anime: widget.anime,
          episode: widget.episode,
          timestamp: Timestamp.now(),
          user: widget.user);
      FirebaseFirestore.instance
          .collection("Comments")
          .doc()
          .set(comment.toMap())
          .then((value) {
        _textController.clear();
        setState(() {});
        FocusScope.of(context).requestFocus(new FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextFormField(
        controller: _textController,
        onChanged: (val) {
          setState(() {});
        },
        maxLines: 2,
        decoration: InputDecoration(
            hintText: "Enter Comment",
            border: InputBorder.none,
            prefixIcon: Icon(
              MaterialCommunityIcons.chat,
              color: Colors.blue,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                MaterialCommunityIcons.send_circle,
                color: _textController.text.isEmpty ? Colors.grey : Colors.blue,
              ),
              onPressed: submit,
            )),
      ),
    );
  }
}

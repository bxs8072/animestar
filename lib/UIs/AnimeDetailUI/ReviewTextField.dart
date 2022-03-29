import 'package:animestar/Models/Anime.dart';
import 'package:animestar/Models/Episode.dart';
import 'package:animestar/Models/User.dart';
import 'package:animestar/UIs/CommentUI/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ReviewTextField extends StatefulWidget {
  final MyUser user;
  final Episode episode;
  final Anime anime;
  ReviewTextField(
      {@required this.episode, @required this.user, @required this.anime});

  @override
  _ReviewTextFieldState createState() => _ReviewTextFieldState();
}

class _ReviewTextFieldState extends State<ReviewTextField> {
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
          .collection("Reviews")
          .doc(widget.anime.title
              .replaceAll(new RegExp(r'[^\w\s]+'), "")
              .split(' ')
              .join(''))
          .collection('Reviews')
          .doc()
          .set(comment.toMap())
          .then((value) {
        _textController.clear();
        setState(() {});
        FocusScope.of(context).requestFocus(new FocusNode());
      }).then((value) => Navigator.of(context).pop());
    }
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: _textController,
          onChanged: (val) {
            setState(() {});
          },
          maxLines: 5,
          decoration: InputDecoration(
              hintText: "Enter Comment",
              border: border(),
              disabledBorder: border(),
              enabledBorder: border(),
              errorBorder: border(),
              focusedBorder: border()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton.icon(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            label: Text("Post"),
            icon: Icon(
              MaterialCommunityIcons.send_circle,
              color: _textController.text.isEmpty ? Colors.grey : Colors.white,
            ),
            onPressed: submit,
          ),
        )
      ],
    );
  }
}

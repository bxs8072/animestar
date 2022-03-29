import 'package:animestar/Models/User.dart';
import 'package:animestar/UIs/ReplyUI/Reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ReplyTextField extends StatefulWidget {
  final String docId;
  final MyUser user;
  ReplyTextField({@required this.docId, @required this.user});
  @override
  _ReplyTextFieldState createState() => _ReplyTextFieldState();
}

class _ReplyTextFieldState extends State<ReplyTextField> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_textController.text.isNotEmpty) {
      Reply reply = Reply(
          reply: _textController.text.trim(),
          timestamp: Timestamp.now(),
          user: widget.user);
      FirebaseFirestore.instance
          .collection("Replies")
          .doc(widget.docId)
          .collection('Replies')
          .doc()
          .set(reply.toMap)
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
            hintText: "Enter Reply",
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

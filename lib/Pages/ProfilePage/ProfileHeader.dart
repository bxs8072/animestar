import 'package:animestar/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatefulWidget {
  final MyUser user;
  ProfileHeader({@required this.user});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final _textController = TextEditingController();

  void submit() async {
    if (_textController.text.isNotEmpty)
      FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.user.uid)
          .set(MyUser(
                  displayName: _textController.text.trim(),
                  email: widget.user.email,
                  photoUrl: widget.user.photoUrl,
                  uid: widget.user.uid)
              .toMap())
          .then((value) {
        Navigator.of(context).pop();
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _textController.text = widget.user.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: size.height * 0.08,
                backgroundImage: NetworkImage(widget.user.photoUrl),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Hi, ' + widget.user.displayName,
            style: GoogleFonts.ubuntu(fontSize: size.height * 0.03),
          ),
        ),
        RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("Choose your display name!!!"),
                      content: TextFormField(
                        controller: _textController,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          hintText: "Display Name...",
                        ),
                      ),
                      actions: [
                        RaisedButton(
                          onPressed: submit,
                          child: Text("Submit"),
                        )
                      ],
                    );
                  });
            },
            child: Text("Edit your name")),
        Divider()
      ],
    );
  }
}

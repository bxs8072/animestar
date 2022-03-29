import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReplyApi {
  static Center emptyReplyList(BuildContext context) => Center(
        child: Text(
          "Be first to give a reply!!!",
          style: GoogleFonts.pacifico(
            letterSpacing: 1.5,
            fontSize: MediaQuery.of(context).size.height * 0.026,
          ),
          textAlign: TextAlign.center,
        ),
      );

  static deleteReply(String docId, String documentId) {
    FirebaseFirestore.instance
        .collection("Replies")
        .doc(docId)
        .collection('Replies')
        .doc(documentId)
        .delete();
  }
}

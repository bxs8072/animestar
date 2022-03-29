import 'package:flutter/material.dart';

class PopNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop()),
    );
  }
}

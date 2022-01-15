import 'package:flutter/material.dart';

class Bottommodeltitle extends StatelessWidget {
  String title;
  Bottommodeltitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    );
  }
}

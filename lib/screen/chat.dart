import 'package:flutter/material.dart';

import 'package:policesfs/Screen/messages.dart';
import 'package:policesfs/Screen/new_message.dart';

class Chat extends StatelessWidget {
  static final routeName = 'Chat';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.pink[900],
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: TextButton(onPressed: () {}, child: Text('Logout')))),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Messages(),
                ),
                NewMessage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

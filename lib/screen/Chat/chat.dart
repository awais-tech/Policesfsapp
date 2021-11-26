import 'package:flutter/material.dart';
import 'package:policesfs/widgets/chat/messages.dart';
import 'package:policesfs/widgets/chat/new_message.dart';

class Chat extends StatelessWidget {
  static final routeName = 'Chat';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Text(
            'Chat',
            textAlign: TextAlign.center,
          ),
        ),
      ),
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

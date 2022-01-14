import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
  var id;
  NewMessage(this.id);
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final shared = await SharedPreferences.getInstance();
    final detail = json.decode(shared.getString('userinfo') as String);
    // final user = await FirebaseAuth.instance.currentUser();
    // final userData = await FirebaseFirestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .get();
    FirebaseFirestore.instance.collection('chat').add({
      'message': _enteredMessage,
      'date': Timestamp.now(),
      'senderid': detail['uid'],
      'receiverid': widget.id["receiverid"],
      'SenderName': detail['name'],
      'role': 'User'
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Type Message Here...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Colors.red[900],
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}

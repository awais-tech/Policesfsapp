import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'date',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final name = 'BXwySkot9bw59oDsbhNJ';
          final nam = 'BXwySkot9bw59oDsbhN';
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              chatDocs[index]['message'],
              chatDocs[index]['SenderName'],
              chatDocs[index]['role'],
              chatDocs[index]['senderid'] == name,
              chatDocs[index]['receiverid'],
              key: ValueKey(chatDocs[index].id),
            ),
          );
        });
  }
}

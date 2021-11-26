import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.SenderName,
    this.role,
    this.senderId,
    this.receiverId, {
    required this.key,
  });

  final Key key;
  final String message;
  // ignore: non_constant_identifier_names
  final String SenderName;
  final bool senderId;
  final String role;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              senderId ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: senderId ? Colors.grey[300] : Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !senderId ? Radius.circular(0) : Radius.circular(12),
                  bottomRight:
                      senderId ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: senderId
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    SenderName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: senderId ? Colors.black : Colors.red,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: senderId ? Colors.black : Colors.red,
                    ),
                    textAlign: senderId ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: senderId ? null : 120,
          right: senderId ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              role,
            ),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}

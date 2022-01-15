import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:policesfs/Constants.dart';
import 'package:policesfs/screen/Chat/allusers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class ChatUser extends StatefulWidget {
  static final routeName = 'ChatUser';

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  String StationId = "";

  final stream = FirebaseFirestore.instance
      .collection('chat')
      .orderBy(
        'date',
        descending: true,
      )
      .snapshots();
  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: FittedBox(child: Text('Chat With Police Staff')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snp) {
                  if (snp.hasError) {
                    print(snp);
                    return Center(
                      child: Text("No Data is here"),
                    );
                  } else if (snp.hasData || snp.data != null) {
                    var i = -1;
                    var all = snp.data?.docs.where((elements) {
                      return (elements.data() as Map)["senderid"] ==
                              FirebaseAuth.instance.currentUser!.uid ||
                          (elements.data() as Map)["receiverid"] ==
                              FirebaseAuth.instance.currentUser!.uid;
                    }).where((elements) {
                      i = i + 1;

                      return snp.data?.docs.indexWhere((ele) =>
                              ((elements.data() as Map)["receiverid"] ==
                                      (ele.data() as Map)["receiverid"] &&
                                  (elements.data() as Map)["senderid"] ==
                                      (ele.data() as Map)["senderid"]) ||
                              ((elements.data() as Map)["receiverid"] ==
                                      (ele.data() as Map)["senderid"] &&
                                  (elements.data() as Map)["senderid"] ==
                                      (ele.data() as Map)["receiverid"])) ==
                          i;
                    }).toList();

                    return all!.length < 1
                        ? Center(child: Container(child: Text("No Record")))
                        : ListView.builder(
                            itemCount: all.length,
                            itemBuilder: (ctx, i) =>
                                Container(child: Viewallusers(all[i])));
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

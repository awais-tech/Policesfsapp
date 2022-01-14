import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/screen/Chat/chat.dart';
import 'package:provider/provider.dart';

class PendingCompalints extends StatefulWidget {
  final comp;

  PendingCompalints(this.comp);

  @override
  _PendingCompalintsState createState() => _PendingCompalintsState();
}

class _PendingCompalintsState extends State<PendingCompalints> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: <Widget>[
          widget.comp.data()['status'] != "disapprove"
              ? ListTile(
                  title: Text(
                    '${widget.comp.data()['Title']} ',
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(widget.comp.data()['date'].toDate()),
                  ),
                  trailing: Container(
                    width: 150,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.info_outline_rounded),
                          color: Colors.red[900],
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      content: Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Police Station Name:\n' +
                                                        widget.comp.data()[
                                                            'PoliceStationName'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Sub-Category:\n' +
                                                        widget.comp.data()[
                                                            'sub category'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Category:\n' +
                                                        widget.comp
                                                            .data()['Catagory'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'Complaint Assigned to Police Officer:\n' +
                                                        widget.comp.data()[
                                                            'OfficerName'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Type:\n' +
                                                        widget.comp
                                                            .data()['Type'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Status:\n' +
                                                        widget.comp
                                                            .data()['status'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    'Description:\n' +
                                                        widget.comp.data()[
                                                            'Description'],
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        'Detail',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ));
                            // showModalBottomSheet(
                            //     context: context,
                            //     isScrollControlled: true,
                            //     builder: (context) {
                            //       return editEmail(
                            //           context, "View Detail", widget.comp);
                            //     });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.chat),
                          color: Colors.red[900],
                          onPressed: () {
                            var stationname =
                                widget.comp.data()['PoliceStationName'];
                            FirebaseFirestore.instance
                                .collection("PoliceStaff")
                                .where("Role", isEqualTo: "Operator")
                                .where("PoliceStationDivision",
                                    isEqualTo: stationname)
                                .get()
                                .then((val) {
                              Navigator.of(context)
                                  .pushNamed(Chat.routeName, arguments: {
                                "receiverid": val.docs[0].id,
                                "senderid":
                                    FirebaseAuth.instance.currentUser!.uid,
                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(_expanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          color: Colors.red[900],
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    color: Colors.red.shade200,
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.all(6.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "Your complaint about ${widget.comp.data()['Title']} is not approved yet",
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Text(
                      'Description: \n${widget.comp.data()['Description']}',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Complaint No: ${widget.comp.data()['ComplaintNo']}',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

Widget editEmail(BuildContext context, String title, compl) {
  return Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Detail'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('PStationName:' + compl.data()['PoliceStationName'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Subcategory:' + compl.data()['sub category'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category:' + compl.data()['Catagory'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'On Task Police officer :' + compl.data()['OfficerName'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Type :' + compl.data()['Type'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Status:' + compl.data()['status'],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description:' + compl.data()['Description'],
                softWrap: true, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}

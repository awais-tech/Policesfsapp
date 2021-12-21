import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/models/Complaints.dart';
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
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          widget.comp.data()['status'] != "disapprove"
              ? ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        ' ${widget.comp.data()['Title']} ',
                        softWrap: true,
                      ),
                    ),
                  ),
                  subtitle: FittedBox(
                    child: Text(
                      DateFormat('dd/MM/yyyy hh:mm')
                          .format(widget.comp.data()['date'].toDate()),
                    ),
                  ),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Expanded(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.details_outlined),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        content: Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'PStationName:' +
                                                          widget.comp.data()[
                                                              'PoliceStationName'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'Subcategory:' +
                                                          widget.comp.data()[
                                                              'sub category'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'Category:' +
                                                          widget.comp.data()[
                                                              'Catagory'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'On Task Police officer :' +
                                                          widget.comp.data()[
                                                              'OfficerName'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'Type :' +
                                                          widget.comp
                                                              .data()['Type'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'Status:' +
                                                          widget.comp
                                                              .data()['status'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      'Description:' +
                                                          widget.comp.data()[
                                                              'Description'],
                                                      softWrap: true,
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
                            icon: Icon(_expanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                          ),
                        ],
                      ),
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
                      'Description: ${widget.comp.data()['Description']}',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Complaint No :${widget.comp.data()['ComplaintNo']}',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
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

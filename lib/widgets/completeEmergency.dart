import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplEmergency extends StatefulWidget {
  final comp;

  ComplEmergency(this.comp);

  @override
  _ComplEmergencyState createState() => _ComplEmergencyState();
}

class _ComplEmergencyState extends State<ComplEmergency> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          widget.comp.data()['status'] == "pending"
              ? Container(
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
                )
              : ListTile(
                  title: Text(
                    '${widget.comp.data()['Title']} ',
                    softWrap: true,
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(widget.comp.data()['date'].toDate()),
                  ),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Expanded(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.info_outline),
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
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Police Station Name:\n' +
                                                          (widget.comp.data()[
                                                                      'PoliceStationName'] ==
                                                                  null
                                                              ? 'AssignSoon'
                                                              : widget.comp
                                                                      .data()[
                                                                  'PoliceStationName']),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Sub-Category:\n' +
                                                          widget.comp.data()[
                                                              'sub category'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Category:\n' +
                                                          widget.comp.data()[
                                                              'Catagory'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'On Task Police officer:\n' +
                                                          widget.comp.data()[
                                                              'OfficerName'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Type:\n' +
                                                          widget.comp
                                                              .data()['Type'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Status:\n' +
                                                          widget.comp
                                                              .data()['status'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Description:\n' +
                                                          widget.comp.data()[
                                                              'Description'],
                                                      textAlign:
                                                          TextAlign.center,
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
                        'Complaint No: ${widget.comp.data()['ComplaintNo']}',
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
            child: Text(
                'Police Station Name:\n' +
                    (compl.data()['PoliceStationName'] == null
                        ? 'AssignSoon'
                        : compl.data()['PoliceStationName']),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sub-Category:\n' + compl.data()['sub category'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category:\n' + compl.data()['Catagory'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Complaint Assigned to Police Officer:\n' +
                    compl.data()['OfficerName'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Type:\n' + compl.data()['Type'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Status:\n' + compl.data()['status'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description:\n' + compl.data()['Description'],
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}

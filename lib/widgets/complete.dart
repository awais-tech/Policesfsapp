import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/ComplaintsFeedback.dart';

class CompleteCompalints extends StatefulWidget {
  final comp;

  CompleteCompalints(this.comp);

  @override
  _CompleteCompalintsState createState() => _CompleteCompalintsState();
}

class _CompleteCompalintsState extends State<CompleteCompalints> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: <Widget>[
          ListTile(
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
              width: 100,
              child: Expanded(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: Colors.red[900],
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return editEmail(
                                  context, "View Detail", widget.comp);
                            });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more),
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
                      'Description:\n ${widget.comp.data()['Description']}',
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
                        'Complaint No:${widget.comp.data()['ComplaintNo']}',
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
            ),
          SizedBox(height: 10),
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
            child: Text('Remarks:' + compl.data()[' SHOFeedback'],
                softWrap: true, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
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
          compl.data()['Ufeedback'] == ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.details_outlined),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(FeedbacksC.routename, arguments: compl.id);
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('My Feedback:' + compl.data()['Ufeedback'],
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
        ],
      ),
    ),
  );
}

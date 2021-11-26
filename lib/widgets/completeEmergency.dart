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
          ListTile(
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
            child: Text(
                'PStationName:' +
                    (compl.data()['PoliceStationName'] == null
                        ? 'AssignSoon'
                        : compl.data()['PoliceStationName']),
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

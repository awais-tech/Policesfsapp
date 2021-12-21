import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:policesfs/Constants.dart';
import 'package:policesfs/screen/ManageComplaints/ComplaintHistoryScreen.dart';
import 'package:policesfs/screen/ManageComplaints/orderstabscreen.dart';

class FeedbacksC extends StatefulWidget {
  static final routename = "FeedbacksC";
  @override
  _FeedbacksCState createState() => _FeedbacksCState();
}

class _FeedbacksCState extends State<FeedbacksC> {
  var loading = false;

  bool _isInit = true;
  var save;
  void AssignDuties() async {
    var id = ModalRoute.of(context)?.settings.arguments as Map;
    var form = _form.currentState!.validate();
    if (!form) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      loading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection("Complaints")
          .doc(id as String)
          .update({
        "Ufeedback": savedata["Description"],
      });
      // await DutiesDatabase.UploadFeedbacks(savedata, id);
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(
                  'Feedbacks submitted',
                ),
                title: Text(
                  'Alert',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pushNamed(ComplaintHistory.routeName);
                    },
                  ),
                ],
              ));
    } catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(
                  'Something Goes wrong ?',
                ),
                title: Text(
                  'Warning',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ));
    }

    setState(() {
      loading = false;
    });
  }

  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       loading = true;
  //     });
  //     var stationId = json
  //         .decode(Constants.prefs.getString('userinfo') as String)['StationId'];
  //     final result = FirebaseFirestore.instance
  //         .collection('PoliceStaff')
  //         .where("PoliceStationID", isEqualTo: stationId)
  //         .where("Role", whereNotIn: ['Police Inspector', 'Operator'])
  //         .get()
  //         .then((result) {
  //           save = result.docs
  //               .map((val) => {
  //                     'label': val.data()["Name"],
  //                     "value": val.data()["PoliceStaffId"]
  //                   })
  //               .toList();
  //           setState(() {
  //             loading = false;
  //           });
  //         });

  //     _isInit = false;

  //     super.didChangeDependencies();
  //   }
  // }

  final savedata = {
    "Description": "",
    "UserDescription": "",
    "Date": DateTime.now(),
  };

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ids = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('FeedbacksC'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !loading
            ? Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // Visibility(
                    //   child: TextFormField(
                    //     maxLines: 4,
                    //     decoration: InputDecoration(
                    //       labelText: 'Hidden Field',
                    //       border: OutlineInputBorder(),
                    //     ),
                    //     keyboardType: TextInputType.text,
                    //   ),
                    //   maintainSize: false,
                    //   maintainAnimation: true,
                    //   maintainState: true,
                    //   visible: false,
                    // ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Remarks',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Description.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          savedata["Description"] = value!;
                        },
                      ),
                    ),

                    Center(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                              vertical: 1,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .top) *
                                          0.3),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[900])),
                              onPressed: () {
                                AssignDuties();
                              },
                              child: Text("Submit FeedbacksC"))),
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

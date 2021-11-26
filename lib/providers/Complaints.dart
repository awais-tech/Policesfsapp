import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaints extends ChangeNotifier {
  // important
  // final _complaints = StreamController<List<ComplaintsModel>>();

  // Stream<List<ComplaintsModel>> get allcomplaints => _complaints.stream;

  // Complaints() {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   FirebaseFirestore.instance
  //       .collection('Complaints')
  //       .where('Userid', isEqualTo: userId)
  //       .snapshots()
  //       .listen((event) {
  //     final List<ComplaintsModel> trans = [];
  //     if (event.size == 0) {
  //       _complaints.add(trans);
  //     } else {
  //       event.docs.forEach((element) {
  //         Map<String, dynamic> data = element.data();

  //         trans.add(ComplaintsModel(
  //             category: data['Catageory'],
  //             subcategory: data['sub category'],
  //             title: data['Title'],
  //             description: data['Description'],
  //             complaintno: data['ComplaintNo'],
  //             type: data['Type'],
  //             status: data['status'],
  //             date: (data['date'] as Timestamp).toDate(),
  //             policeStationName: data['PoliceStationName'],
  //             policeOfficerName: data['OfficerName'],
  //             sentby: data['sent by']));
  //       });
  //       _complaints.add(trans);
  //     }
  //   });
  // }
  // void dispose() {
  //   _complaints.close();
  // }
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cloudFirestoreIntance = FirebaseFirestore.instance;
  Future<void> authcomplaint(ComplaintsModel complaint, val, String image,
      rnumber, _locationData) async {
    CollectionReference complaints =
        cloudFirestoreIntance.collection('Complaints');
    final shared = await SharedPreferences.getInstance();
    final phone = json.decode(shared.getString('userinfo') as String);

    try {
      await FirebaseFirestore.instance
          .collection('PoliceStation')
          .where('Division', isEqualTo: complaint.policeStationName)
          .get()
          .then((value) async {
        await complaints.add({
          'Catagory': complaint.category,
          'ReportNo': rnumber == '' ? 'not have report number' : rnumber,
          'ComplaintNo': 'Not assign',
          'Description': complaint.description,
          'OfficerName': 'No',
          'PoliceOfficerid': 'No',
          'Title': complaint.title,
          'Type': val,
          'Userid': FirebaseAuth.instance.currentUser!.uid,
          'imageUrl': image,
          'sent by': complaint.sentby,
          'status': 'pending',
          'sub category': complaint.subcategory,
          'Complaint Location': _locationData,
          'phone': phone['phoneno'],
          'PoliceStationName': complaint.policeStationName,
          'date': DateTime.now(),
          'userinfo': phone,

          // 'PolicePoliceStationID': value.docs.id,
          // 'PoliceStationID': pid,
        });
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> authemergency(complaint, val, _locationData) async {
    CollectionReference complaints =
        cloudFirestoreIntance.collection('Emergency');
    final shared = await SharedPreferences.getInstance();
    final phone = json.decode(shared.getString('userinfo') as String);
    try {
      await complaints.add({
        'Catagory': complaint.category,
        'ComplaintNo': 'Not assign',
        'Description': complaint.description,
        'OfficerName': 'No',
        'PoliceOfficerid': 'No',
        'Title': complaint.title,
        'Type': val,
        'Userid': FirebaseAuth.instance.currentUser!.uid,
        'sent by': complaint.sentby,
        'status': 'pending',
        'sub category': complaint.subcategory,
        'Complaint Location': _locationData,
        'phone': phone['phoneno'],
        'date': DateTime.now(),
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

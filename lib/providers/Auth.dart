import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  String? _userId;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cloudFirestoreIntance = FirebaseFirestore.instance;

  bool get isAuth {
    return _userId != null;
  }

  Future<void> signUp(
      String email,
      String password,
      Complainer complainer,
      ComplaintsModel complaint,
      val,
      String image,
      rnumber,
      CNIC,
      location) async {
    CollectionReference clients = cloudFirestoreIntance.collection('user');
    CollectionReference complaints =
        cloudFirestoreIntance.collection('Complaints');

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _userId = userCredential.user!.uid;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', _userId!);

      userCredential.user!.sendEmailVerification().then((value) async {
        print(userCredential.user!.uid);
        await FirebaseFirestore.instance
            .collection('PoliceStation')
            .where('Division', isEqualTo: complaint.policeStationName)
            .get()
            .then((value) async {
          await clients.doc(_userId).set({
            'name': complainer.name,
            'email': email,
            'streetNo': complainer.streetNo,
            'houseNo': complainer.houseNo,
            'area': complainer.area,
            'city': complainer.city,
            'age': complainer.age,
            'phoneno': complainer.phoneno,
            'uid': _userId,
            'CNIC': CNIC,
            'address': complainer.city +
                ',' +
                complainer.area +
                ',' +
                complainer.streetNo +
                ',' +
                complainer.houseNo +
                ','
          });
          final userinfo = json.encode({
            'name': complainer.name,
            'email': email,
            'streetNo': complainer.streetNo,
            'houseNo': complainer.houseNo,
            'area': complainer.area,
            'city': complainer.city,
            'age': complainer.age,
            'password': password,
            'phoneno': complainer.phoneno,
            'uid': _userId,
            'address': complainer.city +
                ',' +
                complainer.area +
                ',' +
                complainer.streetNo +
                ',' +
                complainer.houseNo +
                ','
          });

          await prefs.setString('userinfo', userinfo);
          final shared = await SharedPreferences.getInstance();
          final phone = json.decode(shared.getString('userinfo') as String);
          await complaints.add({
            'Catagory': complaint.category,
            'ReportNo': rnumber == '' ? 'not have report number' : rnumber,
            'ComplaintNo': 'Not assign',
            'Description': complaint.description,
            'OfficerName': 'No',
            'PoliceOfficerid': 'No',
            'Title': complaint.title,
            'Type': val,
            'Userid': _userId,
            'imageUrl': image,
            'sent by': complaint.sentby,
            'status': 'disapprove',
            'phone': complainer.phoneno,
            'userinfo': phone,
            'sub category': complaint.subcategory,
            'Complaint Location': location,
            'PoliceStationName': complaint.policeStationName,
            'date': DateTime.now(),
            // 'PolicePoliceStationID': value.docs.id,
            // 'PoliceStationID': pid,
          });
        });
      });
      notifyListeners();
      final url = Uri.parse(
          'https://fitnessappauth.herokuapp.com/api/users/TokenRefreshs');
      Map<String, String> headers = {"Content-type": "application/json"};

      var doc = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
          'message':
              "Hi !<br> You Complaint About  ${complaint.title} is submitted<br> <h1>Desscription</h1>:${complaint.description} <br> For see further detail please open the app",
        }),
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print(email);
      print(password);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      _userId = userCredential.user!.uid;
      prefs.setString('uid', _userId!);
      CollectionReference clients = cloudFirestoreIntance.collection('user');
      var dat = await clients.doc(_userId!).get();
      final userinfo = json.encode({
        'name': dat['name'],
        'email': dat['email'],
        'streetNo': dat['streetNo'],
        'houseNo': dat['houseNo'],
        'area': dat['area'],
        'city': dat['city'],
        'age': dat['age'],
        'password': password,
        'phoneno': dat['phoneno'],
        'uid': _userId,
        'address': dat['city'] +
            ',' +
            dat['area'] +
            ',' +
            dat['streetNo'] +
            ',' +
            dat['houseNo'] +
            ','
      });
      await prefs.setString('userinfo', userinfo);
      _userId = userCredential.user!.uid;
      notifyListeners();
      print(_userId);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('uid')) {
      print(2);
      return false;
    }
    _userId = prefs.getString('uid');
    print(_userId);
    notifyListeners();
    CollectionReference clients = cloudFirestoreIntance.collection('user');
    var dat = await clients.doc(_userId!).get();
    // final userinfo = json.encode({
    //   'name': dat['name'],
    //   'email': dat['email'],
    //   'streetNo': dat['streetNo'],
    //   'houseNo': dat['houseNo'],
    //   'area': dat['area'],
    //   'city': dat['city'],
    //   'age': dat['age'],
    //   'phoneno': dat['phoneno'],
    //   'uid': _userId,
    //   'address': dat['city'] +
    //       ',' +
    //       dat['area'] +
    //       ',' +
    //       dat['streetNo'] +
    //       ',' +
    //       dat['houseNo'] +
    //       ','
    // });
    // await prefs.setString('userinfo', userinfo);
    notifyListeners();
    return true;
  }

  void logout() async {
    await auth.signOut();
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> emergency(complaint, val, phone, location) async {
    CollectionReference complaints =
        cloudFirestoreIntance.collection('Emergency');

    try {
      await complaints.add({
        'Catagory': complaint.category,
        'ComplaintNo': 'Not assign',
        'Description': complaint.description,
        'OfficerName': 'No',
        'PoliceOfficerid': 'No',
        'Title': complaint.title,
        'Type': val,
        'Userid': 'without login',
        'sent by': complaint.sentby,
        'status': 'pending',
        'PoliceStationName': complaint.policeStationName,
        'sub category': complaint.subcategory,
        'Complaint Location': location,
        'phone': phone,
        'date': DateTime.now(),
        // 'PolicePoliceStationID': value.docs.id,
        // 'PoliceStationID': pid,
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

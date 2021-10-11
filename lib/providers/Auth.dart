import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Constants.dart';
import 'package:policesfs/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _userId;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cloudFirestoreIntance = FirebaseFirestore.instance;
  var complaint = Complainer(
      name: '',
      streetNo: '',
      houseNo: '',
      area: '',
      city: '',
      age: '',
      phoneno: '',
      uid: '');
  bool get isAuth {
    return _userId != null;
  }

  Future<void> signUp(
      String email, String password, Complainer complainer) async {
    CollectionReference clients = cloudFirestoreIntance.collection('user');
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userId = userCredential.user!.uid;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', _userId!);
      notifyListeners();
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
        'address': complainer.city +
            ',' +
            complainer.area +
            ',' +
            complainer.streetNo +
            ',' +
            complainer.houseNo +
            ','
      });

      complaint = complainer;

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userId = userCredential.user!.uid;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', _userId!);
      // CollectionReference clients = cloudFirestoreIntance.collection('user');
      // var dat = await clients.doc(_userId!).get();
      // complaint = dat.data() as Complainer;

      notifyListeners();
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
    // CollectionReference clients = cloudFirestoreIntance.collection('user');
    // var dat = await clients.doc(_userId!).get();
    // // complaint = dat.data() as Complainer;
    // notifyListeners();
    return true;
  }

  void logout() async {
    await auth.signOut();
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

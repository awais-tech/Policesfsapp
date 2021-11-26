import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utilities with ChangeNotifier {
  FirebaseFirestore cloudFirstoreInstance = FirebaseFirestore.instance;
  List<String> _category = [];
  List<String> _policestation = [];
  Map<String, List<dynamic>> _subcategory = {
    'No': ['Please Select Categeory']
  };

  Future fetchAreasFromServer() async {
    CollectionReference areas = cloudFirstoreInstance.collection('utilities');
    final documentSnapshot = await areas.doc('Category').get();
    _category =
        new List<String>.from((documentSnapshot.data() as Map)['category']);
    notifyListeners();
  }

  Future fetchCategoryFromServer() async {
    CollectionReference areas = cloudFirstoreInstance.collection('utilities');
    final result = (await areas.doc('SubCategory').get());
    _subcategory = new Map<String, List<dynamic>>.from(result.data() as Map);

    notifyListeners();
  }

  Future fetchStationFromServer() async {
    CollectionReference areas =
        cloudFirstoreInstance.collection('PoliceStation');
    final results = (await areas.get());
    final List<String> station = results.docs
        .map((station) => (station.data() as Map)['Division'])
        .toList()
        .cast<String>();
    _policestation = station;

    notifyListeners();
  }

  List<String> get areas {
    return _category;
  }

  List<String> get policestation {
    return _policestation;
  }

  Map<String, List<dynamic>> get subcategory {
    return _subcategory;
  }
}

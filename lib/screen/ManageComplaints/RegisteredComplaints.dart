import 'dart:io';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/models/User.dart';
import 'package:policesfs/providers/Auth.dart';
import 'package:policesfs/providers/Complaints.dart';
import 'package:policesfs/providers/utilities.dart';
import 'package:policesfs/screen/Auth/Signscreen.dart';
import 'package:policesfs/screen/Dashboard.dart';
import 'package:policesfs/widgets/camera.dart';
import 'package:policesfs/widgets/image_upload.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

// import './signIn-screen.dart';

class Addcomplaint extends StatelessWidget {
  static const routeName = '/registercomplaint';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('Registered Complaint'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                width: mediaQuery.width * 0.75,
                child: Text(
                  'Police SFS',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SignUpForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _initialize = false;
  bool _loading = true;

  var index = 0;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'rnumber': '',
  };
  var complaint = ComplaintsModel(
      category: '',
      subcategory: '',
      title: '',
      description: '',
      complaintno: 'no assign',
      type: 'no assign',
      sentby: '',
      status: 'pending',
      date: DateTime.now(),
      policeStationName: '',
      policeOfficerName: 'no assign');
  XFile? _userImageFile;
  void _pickedImage(XFile image) {
    _userImageFile = image;
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_initialize) {
      setState(() {
        _loading = true;
      });
      await Provider.of<Utilities>(context, listen: false)
          .fetchAreasFromServer()
          .then((value) => Provider.of<Utilities>(context, listen: false)
              .fetchCategoryFromServer()
              .then((value) => Provider.of<Utilities>(context, listen: false)
                  .fetchStationFromServer()
                  .then(
                    (value) => setState(() {
                      _loading = false;
                    }),
                  )));

      _initialize = true;
    }
    super.didChangeDependencies();
  }

  Future<void> next() async {
    var a = true;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    a = false;

    if (a == false) {
      setState(() {
        index = index + 1;
      });
      print(index);
    }
  }

  void back() {
    setState(() {
      index = index - 1;
    });
    // _submit();
  }

  void _showErrorDialogue(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                print(2);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Okay')),
        ],
      ),
    );
  }

  void _submit() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _showErrorDialogue("Please allow permission");
        return;
      }
    }
    _locationData = await location.getLocation();
    if (val != 'Emergency') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
    });

    try {
      if (val == 'Emergency') {
        await Provider.of<Complaints>(context, listen: false).authemergency(
            complaint,
            val,
            '${_locationData.latitude},${_locationData.longitude}');
        _showErrorDialogue(
            "Your Complaint is submitted officer will reach your location soon");
      } else {
        if (val != 'Fir') {
          _authData['rnumber'] = '';
        }
        final ref = FirebaseStorage.instance.ref().child(_userImageFile!.name);
        print(File(_userImageFile!.path));
        await ref.putFile(File(_userImageFile!.path));
        final download = await ref.getDownloadURL();
        await Provider.of<Complaints>(context, listen: false).authcomplaint(
            complaint,
            val,
            download,
            _authData['rnumber'],
            '${_locationData.latitude},${_locationData.longitude}');

        _showErrorDialogue("Your complaint has been submited");
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialogue(error.message!);
    } catch (error) {
      print(error);
      _showErrorDialogue("Something Goes wrong");
    }
    setState(() {
      _loading = false;
    });
  }

  String val = "Fir";
  String problemRelatedTo = 'No';
  @override
  Widget build(BuildContext context) {
    final problems = Provider.of<Utilities>(context)
        .subcategory[problemRelatedTo]!
        .cast<String>();
    // if (val == 'Emergency') {
    //   setState(() {
    //     index = 0;
    //   });
    //   // } else {
    //   //   setState(() {
    //   //     index = index;
    //   //   });
    //   // }
    // }
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              RadioListTile(
                activeColor: Color(0xff8d43d6),
                groupValue: val,
                title: const Text('Fir'),
                value: 'Fir',
                onChanged: (String? value) {
                  print(value);
                  print(val);
                  setState(() {
                    val = value as String;
                  });
                },
                secondary: const Icon(
                  Icons.report,
                  color: Color(0xff8d43d6),
                ),
              ),
              RadioListTile(
                activeColor: Color(0xff8d43d6),
                groupValue: val,
                title: const Text('Report'),
                value: 'Report',
                onChanged: (String? value) {
                  setState(() {
                    val = value as String;
                  });
                },
                secondary: const Icon(
                  Icons.dangerous,
                  color: Color(0xff8d43d6),
                ),
              ),
              RadioListTile(
                activeColor: Color(0xff8d43d6),
                groupValue: val,
                title: const Text('Emergency'),
                value: 'Emergency',
                onChanged: (String? value) {
                  setState(() {
                    val = value as String;
                  });
                },
                secondary: const Icon(
                  Icons.local_police_outlined,
                  color: Color(0xff8d43d6),
                ),
              ),
              Form(
                  key: _formKey,
                  child: (index == 0)
                      ? Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                child: val == 'Emergency'
                                    ? Text('Emergency Form')
                                    : Text('Step 1')),
                            TextFormField(
                              initialValue: complaint.title,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                // icon: Icon(Icons.email_outlined),
                                prefixIcon: Icon(Icons.email_outlined),

                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(10.0)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the title';
                                }
                              },
                              onSaved: (value) {
                                complaint = ComplaintsModel(
                                    category: '',
                                    subcategory: '',
                                    sentby: '',
                                    title: value!,
                                    description: '',
                                    complaintno: '',
                                    type: '',
                                    status: '',
                                    date: DateTime.now(),
                                    policeStationName: '',
                                    policeOfficerName: '');
                              },
                            ),
                            TextFormField(
                              initialValue: complaint.description,
                              maxLines: 10,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.person),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (val == 'Emergency'
                                    ? false
                                    : value!.isEmpty) {
                                  return 'Please enter the Description';
                                }
                              },
                              onSaved: (value) {
                                complaint = ComplaintsModel(
                                    category: '',
                                    subcategory: '',
                                    sentby: '',
                                    title: complaint.title,
                                    description: value!,
                                    complaintno: '',
                                    type: '',
                                    status: '',
                                    date: DateTime.now(),
                                    policeStationName: '',
                                    policeOfficerName: '');
                              },
                            ),
                            Consumer<Utilities>(
                              builder: (ctx, utility, _) =>
                                  TextDropdownFormField(
                                decoration: InputDecoration(
                                  labelText: 'Choose Category',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                options: utility.areas,
                                dropdownHeight: 250,
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return 'Please choose Category';
                                  }
                                },
                                onChanged: (dynamic value) {
                                  setState(() {
                                    problemRelatedTo = value;
                                  });
                                },
                                onSaved: (dynamic value) {
                                  complaint = ComplaintsModel(
                                      category: value!,
                                      subcategory: '',
                                      sentby: '',
                                      title: complaint.title,
                                      description: complaint.description,
                                      complaintno: '',
                                      type: '',
                                      status: '',
                                      date: DateTime.now(),
                                      policeStationName: '',
                                      policeOfficerName: '');
                                },
                              ),
                            ),
                            TextDropdownFormField(
                                decoration: InputDecoration(
                                  labelText: 'Choose sub Category',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                // ignore: unrelated_type_equality_checks
                                options: problems == []
                                    ? ['Choose sub Category']
                                    : problems,
                                dropdownHeight: 250,
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return 'Please choose Category';
                                  }
                                },
                                onSaved: (dynamic value) {
                                  complaint = ComplaintsModel(
                                      category: complaint.category,
                                      subcategory: value!,
                                      sentby: '',
                                      title: complaint.title,
                                      description: complaint.description,
                                      complaintno: '',
                                      type: '',
                                      status: '',
                                      date: DateTime.now(),
                                      policeStationName: '',
                                      policeOfficerName: '');
                                }),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Sent by',
                                hintText: '',
                                prefixIcon: Icon(Icons.house_outlined),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (val == 'Emergency'
                                    ? false
                                    : value!.isEmpty) {
                                  return 'Please enter Sent by';
                                }
                              },
                              onSaved: (value) {
                                complaint = ComplaintsModel(
                                    category: complaint.category,
                                    subcategory: complaint.subcategory,
                                    title: complaint.title,
                                    description: complaint.description,
                                    complaintno: '',
                                    type: complaint.type,
                                    status: '',
                                    sentby: value!,
                                    date: DateTime.now(),
                                    policeStationName: '',
                                    policeOfficerName: '');
                              },
                            ),
                            val == 'Fir'
                                ? TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Report number if you have',
                                      hintText: '',
                                      prefixIcon: Icon(Icons.report),
                                    ),
                                    onSaved: (value) {
                                      _authData['rnumber'] = value as String;
                                    },
                                  )
                                : Container(),
                            SizedBox(
                              height: 8,
                            ),
                            if (_loading)
                              CircularProgressIndicator()
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => back(),
                                    child: Text('Back'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        val != 'Emergency' ? next() : _submit(),
                                    child: val != 'Emergency'
                                        ? Text('Next')
                                        : Text('Submit'),
                                  ),
                                ],
                              ),
                          ],
                        )
                      : Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Consumer<Utilities>(
                              builder: (ctx, utility, _) =>
                                  TextDropdownFormField(
                                decoration: InputDecoration(
                                  labelText: 'Choose PoliceStation',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                options: utility.policestation.cast<String>(),
                                dropdownHeight: 250,
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return 'Please choose Station';
                                  }
                                },
                                onChanged: (dynamic value) {},
                                onSaved: (dynamic value) {
                                  complaint = ComplaintsModel(
                                      category: complaint.category,
                                      subcategory: complaint.subcategory,
                                      title: complaint.title,
                                      description: complaint.description,
                                      complaintno: 'no',
                                      type: complaint.type,
                                      status: 'pending',
                                      sentby: complaint.sentby,
                                      date: DateTime.now(),
                                      policeStationName: value!,
                                      policeOfficerName: 'no');
                                },
                              ),
                            ),
                            UserImagePicker(_pickedImage),
                            camera(_pickedImage),
                            SizedBox(
                              height: 8,
                            ),
                            if (_loading)
                              CircularProgressIndicator()
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => back(),
                                    child: Text('Back'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _submit(),
                                    child: Text('Submit'),
                                  ),
                                ],
                              ),
                          ],
                        )),
            ],
          );
  }
}

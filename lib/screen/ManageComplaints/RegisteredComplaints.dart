import 'dart:io';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
          child: Text('Register New Complaint'),
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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
    // Location location = new Location();

    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // LocationData _locationData;
    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {}
    // }
    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     _showErrorDialogue("Please allow permission");
    //     return;
    //   }
    // }
    // _locationData = await location.getLocation();
    var _locationData = await _determinePosition();
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
            "Your Complaint is submitted. Officer will reach your location shortly.");
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
      _showErrorDialogue("Something went wrong!");
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
                activeColor: Colors.red[900],
                groupValue: val,
                title: const Text('F.I.R'),
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
                  color: Colors.blue,
                ),
              ),
              RadioListTile(
                activeColor: Colors.red[900],
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
                  color: Colors.blue,
                ),
              ),
              RadioListTile(
                activeColor: Colors.red[900],
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
                  color: Colors.blue,
                ),
              ),
              Form(
                  key: _formKey,
                  child: (index == 0)
                      ? Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 20),
                            Container(
                                child: val == 'Emergency'
                                    ? Text(
                                        'Emergency Form',
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    : Text(
                                        'Step 1',
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                            SizedBox(height: 20),
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
                                    policeStationName:
                                        complaint.policeStationName,
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
                                    policeStationName:
                                        complaint.policeStationName,
                                    policeOfficerName: '');
                              },
                            ),
                            val == 'Emergency'
                                ? Consumer<Utilities>(
                                    builder: (ctx, utility, _) =>
                                        TextDropdownFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Choose PoliceStation',
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      options:
                                          utility.policestation.cast<String>(),
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
                                  )
                                : Container(),
                            SizedBox(
                              height: 8,
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
                                  labelText: 'Choose Sub-Category',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                // ignore: unrelated_type_equality_checks
                                options: problems == []
                                    ? ['Choose Sub-Category']
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
                            SizedBox(
                              height: 8,
                            ),
                            val == 'Fir'
                                ? TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Report Number (Optional)',
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
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red[900])),
                                    onPressed: () => back(),
                                    child: Text('Back'),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red[900])),
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
                                  labelText: 'Choose Police Station',
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
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red[900])),
                                    onPressed: () => back(),
                                    child: Text('Back'),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red[900])),
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

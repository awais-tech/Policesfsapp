// ignore_for_file: unnecessary_statements

import 'dart:io';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/models/User.dart';
import 'package:policesfs/providers/Auth.dart';
import 'package:policesfs/providers/utilities.dart';
import 'package:geolocator/geolocator.dart';
import 'package:policesfs/screen/Auth/Signscreen.dart';
import 'package:policesfs/widgets/camera.dart';
import 'package:policesfs/widgets/image_upload.dart';
import 'package:provider/provider.dart';

// import './signIn-screen.dart';

class SignUp extends StatelessWidget {
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
                    color: Colors.blue[900],
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
  final _passwordController = TextEditingController();
  bool _initialize = false;
  bool _loading = true;
  // Location location = new Location();
  // late LocationData _locationData;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'rnumber': '',
  };
  Map<String, String> need = {
    'phone': '',
  };
  var index = 0;
  var _complainer = Complainer(
      name: '',
      streetNo: '',
      houseNo: '',
      area: '',
      city: '',
      age: '',
      phoneno: '',
      uid: '');
  var complaint = ComplaintsModel(
      category: '',
      subcategory: '',
      title: '',
      description: '',
      complaintno: '',
      type: '',
      sentby: '',
      status: '',
      date: DateTime.now(),
      policeStationName: '',
      policeOfficerName: '');
  XFile? _userImageFile;
  void _pickedImage(XFile image) {
    _userImageFile = image;
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
    }
  }

  void back() {
    setState(() {
      index = index - 1;
    });
    // _submit();
  }

  void _showErrorDialogue(bool check, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Okay')),
        ],
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool isPhone(String em) {
    String p =
        r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void _submit() async {
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     _showErrorDialogue(false, "Please allow permission");
    //     return;
    //   }
    // }
    // _permissionGranted = await location.hasPermission();
    // print(_permissionGranted);
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     _showErrorDialogue(false, "Please allow permission");
    //     return;
    //   }
    // }

    // _locationData = await location.getLocation();
    // print(_locationData);
    print(32);
    var _locationData = await _determinePosition();
    print(122);
    print(_locationData);
    if (val != 'Emergency') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
    });
    // print(Json.p_locationData);
    try {
      if (val == 'Emergency') {
        await Provider.of<Auth>(context, listen: false).emergency(
            complaint,
            val,
            need["phone"],
            '${_locationData.latitude},${_locationData.longitude}');
        _showErrorDialogue(true,
            "Your Complaint is submitted officer will reach your location soon");
      } else {
        if (val != 'Fir') {
          _authData['rnumber'] = '';
        }
        final ref = FirebaseStorage.instance.ref().child(_userImageFile!.name);
        print(File(_userImageFile!.path));
        await ref.putFile(File(_userImageFile!.path));
        final download = await ref.getDownloadURL();
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
          _complainer,
          complaint,
          val,
          download,
          _authData['rnumber']!,
          '${_locationData.latitude},${_locationData.longitude}',
        );

        _showErrorDialogue(true,
            "Your complaint has been submited Log in to track your Complaint");
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialogue(false, error.message!);
    } catch (error) {
      print(error);
      _showErrorDialogue(false, "Something Goes wrong");
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
    if (val == 'Emergency') {
      setState(() {
        index = 1;
      });
    } else {
      setState(() {
        index = index;
      });
    }
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
                  setState(() {
                    index = 0;
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
                  setState(() {
                    index = 0;
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
                            TextFormField(
                              initialValue: _authData['email'],
                              decoration: InputDecoration(
                                labelText: 'Email',
                                // icon: Icon(Icons.email_outlined),
                                prefixIcon: Icon(Icons.email_outlined),

                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(10.0)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the eamil';
                                } else if (!value.contains('@')) {
                                  return 'Invalid Eamil.';
                                }
                              },
                              onSaved: (value) {
                                _authData['email'] = value!;
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.name,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the name';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: value!,
                                    streetNo: '',
                                    houseNo: '',
                                    area: '',
                                    city: '',
                                    age: '',
                                    phoneno: '',
                                    uid: '');
                              },
                            ),

                            //   onSaved: (dynamic value) {
                            //     _Complainer = Complainer(
                            //       name: _Complainer.name,
                            //       houseNo: '',
                            //       streetNo: '',
                            //       area: value ?? '',
                            //     );
                            //   },
                            // ),

                            TextFormField(
                              initialValue: _complainer.streetNo,
                              decoration: InputDecoration(
                                labelText: 'Street No',
                                hintText: '9',
                                prefixIcon: Icon(Icons.streetview_rounded),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the street no';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: value!,
                                    houseNo: '',
                                    area: '',
                                    city: '',
                                    age: '',
                                    phoneno: '',
                                    uid: '');
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.houseNo,
                              decoration: InputDecoration(
                                labelText: 'House No',
                                hintText: '887 J2',
                                prefixIcon: Icon(Icons.house_outlined),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the House No';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: _complainer.streetNo,
                                    houseNo: value!,
                                    area: '',
                                    city: '',
                                    age: '',
                                    phoneno: '',
                                    uid: '');
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.area,
                              decoration: InputDecoration(
                                labelText: 'Area',
                                hintText: 'Johar town',
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the area ';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: _complainer.streetNo,
                                    houseNo: _complainer.houseNo,
                                    area: value!,
                                    city: '',
                                    age: '',
                                    phoneno: '',
                                    uid: '');
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.city,
                              decoration: InputDecoration(
                                labelText: 'City',
                                prefixIcon: Icon(Icons.location_city_rounded),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the city';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: _complainer.streetNo,
                                    houseNo: _complainer.houseNo,
                                    area: _complainer.city,
                                    city: value!,
                                    age: '',
                                    phoneno: '',
                                    uid: '');
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.age,
                              decoration: InputDecoration(
                                  labelText: 'Age',
                                  prefixIcon: Icon(Icons.elderly_sharp)),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the age';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: _complainer.streetNo,
                                    houseNo: _complainer.houseNo,
                                    area: _complainer.city,
                                    city: _complainer.city,
                                    age: value!,
                                    phoneno: '',
                                    uid: '');
                              },
                            ),
                            TextFormField(
                              initialValue: _complainer.phoneno,
                              decoration: InputDecoration(
                                  labelText: 'Phone no',
                                  prefixIcon: Icon(Icons.phone)),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the Phoneno';
                                }
                              },
                              onSaved: (value) {
                                _complainer = Complainer(
                                    name: _complainer.name,
                                    streetNo: _complainer.streetNo,
                                    houseNo: _complainer.houseNo,
                                    area: _complainer.city,
                                    city: _complainer.city,
                                    age: _complainer.age,
                                    phoneno: value!,
                                    uid: '');
                              },
                            ),

                            TextFormField(
                              initialValue: _authData['Password'],
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password_outlined),
                                  labelText: 'Password',
                                  helperText:
                                      'Password Should be at least 6 characters long.'),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the password';
                                } else if (value.length < 6) {
                                  return 'Password is too short.';
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value!;
                              },
                            ),
                            TextFormField(
                              initialValue: _passwordController.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_outlined),
                                labelText: 'Confirm Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Password does not match.';
                                }
                              },
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            if (_loading)
                              CircularProgressIndicator()
                            else
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red[900])),
                                onPressed: () => next(),
                                child: Text('Next'),
                              ),
                            TextButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.red[900])),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/');
                                },
                                child: Text('LOGIN INSTEAD'))
                          ],
                        )
                      : (index == 1)
                          ? Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    child: val == 'Emergency'
                                        ? Text('Emergency Form')
                                        : Text('Step 2')),
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
                                  decoration: InputDecoration(
                                      labelText: 'Phone no',
                                      prefixIcon: Icon(Icons.phone)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the Phoneno';
                                    }
                                  },
                                  onSaved: (value) {
                                    need['phone'] = value as String;
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
                                          policeStationName:
                                              complaint.policeStationName,
                                          policeOfficerName: '');
                                    },
                                  ),
                                ),
                                val == 'Emergency'
                                    ? Consumer<Utilities>(
                                        builder: (ctx, utility, _) =>
                                            TextDropdownFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Choose PoliceStation',
                                            suffixIcon:
                                                Icon(Icons.arrow_drop_down),
                                          ),
                                          options: utility.policestation
                                              .cast<String>(),
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
                                                subcategory:
                                                    complaint.subcategory,
                                                title: complaint.title,
                                                description:
                                                    complaint.description,
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
                                        return 'Please choose area';
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
                                          policeStationName:
                                              complaint.policeStationName,
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
                                        policeStationName:
                                            complaint.policeStationName,
                                        policeOfficerName: '');
                                  },
                                ),
                                val == 'Fir'
                                    ? TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              'Report number if you have',
                                          hintText: '',
                                          prefixIcon: Icon(Icons.report),
                                        ),
                                        onSaved: (value) {
                                          _authData['rnumber'] =
                                              value as String;
                                        },
                                      )
                                    : Container(),
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
                                        onPressed: () => val != 'Emergency'
                                            ? next()
                                            : _submit(),
                                        child: val != 'Emergency'
                                            ? Text('Next')
                                            : Text('Submit'),
                                      ),
                                    ],
                                  ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('LOGIN INSTEAD',
                                        style:
                                            TextStyle(color: Colors.red[900])))
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
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red[900])),
                                        onPressed: () => _submit(),
                                        child: Text('SIGNUP'),
                                      ),
                                    ],
                                  ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                    },
                                    child: Text('LOGIN INSTEAD'))
                              ],
                            )),
            ],
          );
  }
}

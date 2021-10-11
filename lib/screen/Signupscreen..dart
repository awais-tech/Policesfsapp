import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/models/User.dart';
import 'package:policesfs/screen/Signscreen.dart';
import 'package:provider/provider.dart';

// import './signIn-screen.dart';

import '../providers/auth.dart';

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
  final _passwordController = TextEditingController();
  bool _initialize = false;
  bool _loading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
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

  @override
  void didChangeDependencies() {
    if (!_initialize) {
      // Provider.of<Utilities>(context, listen: false).fetchAreasFromServer();
      _initialize = true;
    }
    super.didChangeDependencies();
  }

  void next() {
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
    _submit();
  }

  void _showErrorDialogue(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay')),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email']!, _authData['password']!, _complainer);
      Navigator.of(context).pushReplacementNamed('/');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Complainer successfully added'),
      //   ),
      // );

    } on FirebaseAuthException catch (error) {
      _showErrorDialogue(error.message!);
    } catch (error) {
      print(error);
      _showErrorDialogue("Authentication Failed");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('email');
    print(_authData['email']);
    return Form(
        key: _formKey,
        child: (index == 0)
            ? Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
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
                  // Consumer<Utilities>(
                  //   builder: (ctx, utility, _) => TextDropdownFormField(
                  //     decoration: InputDecoration(
                  //       labelText: 'Choose Area',
                  //       suffixIcon: Icon(Icons.arrow_drop_down),
                  //     ),
                  //     options: utility.areas,
                  //     dropdownHeight: 250,
                  //     validator: (dynamic value) {
                  //       if (value == null) {
                  //         return 'Please choose area';
                  //       }
                  //     },
                  //     onSaved: (dynamic value) {
                  //       _Complainer = Complainer(
                  //         name: _Complainer.name,
                  //         houseNo: '',
                  //         streetNo: '',
                  //         area: value ?? '',
                  //       );
                  //     },
                  //   ),
                  // ),

                  TextFormField(
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
                    decoration: InputDecoration(
                      labelText: 'house No',
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
                    decoration: InputDecoration(
                      labelText: 'area',
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
                    decoration: InputDecoration(
                      labelText: 'city',
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
                    decoration: InputDecoration(
                        labelText: 'age',
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
                    decoration: InputDecoration(
                        labelText: 'Phone no', prefixIcon: Icon(Icons.phone)),
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
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
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
                      onPressed: () => next(),
                      child: Text('Next'),
                    ),

                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Text('LOGIN INSTED'))
                ],
              )
            : (index == 1)
                ? Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(child: Text('Page 2')),
                      TextFormField(
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
                      // Consumer<Utilities>(
                      //   builder: (ctx, utility, _) => TextDropdownFormField(
                      //     decoration: InputDecoration(
                      //       labelText: 'Choose Area',
                      //       suffixIcon: Icon(Icons.arrow_drop_down),
                      //     ),
                      //     options: utility.areas,
                      //     dropdownHeight: 250,
                      //     validator: (dynamic value) {
                      //       if (value == null) {
                      //         return 'Please choose area';
                      //       }
                      //     },
                      //     onSaved: (dynamic value) {
                      //       _Complainer = Complainer(
                      //         name: _Complainer.name,
                      //         houseNo: '',
                      //         streetNo: '',
                      //         area: value ?? '',
                      //       );
                      //     },
                      //   ),
                      // ),

                      TextFormField(
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
                        decoration: InputDecoration(
                          labelText: 'house No',
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
                        decoration: InputDecoration(
                          labelText: 'area',
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
                        decoration: InputDecoration(
                          labelText: 'city',
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
                        decoration: InputDecoration(
                            labelText: 'age',
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => back(),
                              child: Text('Back'),
                            ),
                            ElevatedButton(
                              onPressed: () => next(),
                              child: Text('Next'),
                            ),
                          ],
                        ),

                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          child: Text('LOGIN INSTED'))
                    ],
                  )
                : Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
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
                      // Consumer<Utilities>(
                      //   builder: (ctx, utility, _) => TextDropdownFormField(
                      //     decoration: InputDecoration(
                      //       labelText: 'Choose Area',
                      //       suffixIcon: Icon(Icons.arrow_drop_down),
                      //     ),
                      //     options: utility.areas,
                      //     dropdownHeight: 250,
                      //     validator: (dynamic value) {
                      //       if (value == null) {
                      //         return 'Please choose area';
                      //       }
                      //     },
                      //     onSaved: (dynamic value) {
                      //       _Complainer = Complainer(
                      //         name: _Complainer.name,
                      //         houseNo: '',
                      //         streetNo: '',
                      //         area: value ?? '',
                      //       );
                      //     },
                      //   ),
                      // ),

                      TextFormField(
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
                        decoration: InputDecoration(
                          labelText: 'house No',
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
                        decoration: InputDecoration(
                          labelText: 'area',
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
                        decoration: InputDecoration(
                          labelText: 'city',
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
                        decoration: InputDecoration(
                            labelText: 'age',
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => back(),
                              child: Text('Back'),
                            ),
                            ElevatedButton(
                              onPressed: () => _submit(),
                              child: Text('SIGNUP'),
                            ),
                          ],
                        ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          child: Text('LOGIN INSTED'))
                    ],
                  ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/providers/Auth.dart';
import 'package:policesfs/screen/Auth/Signupscreen..dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/signin';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialogue(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert!'),
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
          .login(_authData['email']!, _authData['password']!);
    } on FirebaseAuthException catch (error) {
      _showErrorDialogue(error.message!);
    } catch (error) {
      _showErrorDialogue(error.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "WELCOME TO Police Sfs",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: (MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).padding.top) *
                                0.060,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8d43d6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: Container(
                    width: deviceSize.width * 0.90,
                    height: deviceSize.height * 0.64,
                    child: Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Email'),
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
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['password'] = value!;
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              if (_loading)
                                CircularProgressIndicator()
                              else
                                ElevatedButton(
                                  onPressed: () => _submit(),
                                  child: Text('LOGIN'),
                                ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SignUp.routeName);
                                },
                                child: Text('SIGNUP INSTED'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

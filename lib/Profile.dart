import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:policesfs/Constants.dart';
import 'package:policesfs/widgets/Bottommodaltitle.dart';
import 'package:policesfs/widgets/Straightline.dart';
import 'package:policesfs/widgets/inputborder.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:progress_state_button/iconed_button.dart';
// import 'package:progress_state_button/progress_button.dart';

class Profile extends StatefulWidget {
  static const routeName = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final myList = ['Age', 'Name', 'Password', 'Phoneno', 'Email', 'Address'];

  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  void submit(value, name) async {
    try {
      Constants.prefs = await SharedPreferences.getInstance();
      final dat =
          await json.decode(Constants.prefs.getString('userinfo') as String);
      if (name == "name") {
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({name: value});

        final userinfo = json.encode({
          'name': value,
          'email': dat['email'],
          'streetNo': dat['streetNo'],
          'houseNo': dat['houseNo'],
          'area': dat['area'],
          'city': dat['city'],
          'age': dat['age'],
          'password': dat["password"],
          'phoneno': dat['phoneno'],
          'uid': dat['uid'],
          'address': dat['city'] +
              ',' +
              dat['area'] +
              ',' +
              dat['streetNo'] +
              ',' +
              dat['houseNo'] +
              ','
        });
        await Constants.prefs.setString('userinfo', userinfo);
      }

      if (name == "age") {
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({name: value});

        final userinfo = json.encode({
          'name': dat['name'],
          'email': dat['email'],
          'streetNo': dat['streetNo'],
          'houseNo': dat['houseNo'],
          'area': dat['area'],
          'city': dat['city'],
          'age': value,
          'password': dat["password"],
          'phoneno': dat['phoneno'],
          'uid': dat['uid'],
          'address': dat['city'] +
              ',' +
              dat['area'] +
              ',' +
              dat['streetNo'] +
              ',' +
              dat['houseNo'] +
              ','
        });
        await Constants.prefs.setString('userinfo', userinfo);
      }

      if (name == "Password") {
        final c = FirebaseAuth.instance.currentUser;
        final cre = EmailAuthProvider.credential(
            email: dat["email"], password: dat["password"]);
        c!.reauthenticateWithCredential(cre).then((va) {
          c
              .updatePassword(value as String)
              .then((valu) => print("change"))
              .catchError((error) {
            _showErrorDialogue("Something Goes Wrong");
          });
        }).catchError((error) {
          _showErrorDialogue("Something Goes Wrong");
        });

        final userinfo = json.encode({
          'name': dat['name'],
          'email': dat['email'],
          'streetNo': dat['streetNo'],
          'houseNo': dat['houseNo'],
          'area': dat['area'],
          'city': dat['city'],
          'age': dat['age'],
          'password': value,
          'phoneno': dat['phoneno'],
          'uid': dat['uid'],
          'address': dat['city'] +
              ',' +
              dat['area'] +
              ',' +
              dat['streetNo'] +
              ',' +
              dat['houseNo'] +
              ','
        });
        await Constants.prefs.setString('userinfo', userinfo);
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialogue(error.message!);
    } catch (e) {
      _showErrorDialogue("Something Goes Wrong");
      throw (e);
    }
    Navigator.of(context).pop();
    setState(() {});
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
                Navigator.of(context).pop();
              },
              child: Text('Okay')),
        ],
      ),
    );
  }
  // Widget progessButton() {
  //   return Container();
  //   // return ProgressButton.icon(iconedButtons: {
  //   //   ButtonState.idle: IconedButton(
  //   //       text: "Save Changes",
  //   //       icon: Icon(Icons.save_alt_rounded, color: Colors.white),
  //   //       color: Colors.pink.shade900),
  //   //   ButtonState.loading:
  //   //       IconedButton(text: "Loading", color: Colors.pink.shade900),
  //   //   ButtonState.fail: IconedButton(
  //   //       text: "Failed",
  //   //       icon: Icon(Icons.cancel, color: Colors.white),
  //   //       color: Colors.red.shade300),
  //   //   ButtonState.success: IconedButton(
  //   //       text: "Success",
  //   //       icon: Icon(
  //   //         Icons.check_circle,
  //   //         color: Colors.white,
  //   //       ),
  //   //       color: Colors.green.shade400)
  //   // }, onPressed: () {});
  // }

  Widget editCNIC(BuildContext context, String title) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bottommodeltitle(title),
          Divider(
            thickness: 2,
          ),
          Container(
            decoration: putborder(),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.person_add_alt,
                    color: Colors.blue[900],
                  ),
                ),
                Straightline(),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.streetAddress,
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Edit  Name',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).padding.top) *
                    0.35),
                backgroundColor: MaterialStateProperty.all(
                    Colors.red[900]), // <-- Button color
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.red; // <-- Splash color
                }),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => {
                submit(
                  name.text,
                  "name",
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget editEmail(BuildContext context, String title) {
  //   return Padding(
  //     padding: MediaQuery.of(context).viewInsets,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Bottommodeltitle(title),
  //         Divider(
  //           thickness: 2,
  //         ),
  //         Container(
  //           decoration: putborder(),
  //           margin:
  //               const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  //           child: Row(
  //             children: <Widget>[
  //               new Padding(
  //                 padding:
  //                     EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  //                 child: Icon(
  //                   Icons.email_outlined,
  //                   color: Color(0xff8d43d6),
  //                 ),
  //               ),
  //               Straightline(),
  //               Expanded(
  //                 child: TextField(
  //                   keyboardType: TextInputType.streetAddress,
  //                   controller: email,
  //                   decoration: InputDecoration(
  //                     labelText: 'Edit address',
  //                     border: InputBorder.none,
  //                     hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 8.0),
  //           child: ElevatedButton(
  //             style: ButtonStyle(
  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                   RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               )),
  //               padding: MaterialStateProperty.all(EdgeInsets.symmetric(
  //                       vertical: 25,
  //                       horizontal: MediaQuery.of(context).size.width -
  //                           MediaQuery.of(context).padding.top) *
  //                   0.35),
  //               backgroundColor: MaterialStateProperty.all(
  //                   Color(0xff8d43d6)), // <-- Button color
  //               overlayColor:
  //                   MaterialStateProperty.resolveWith<Color?>((states) {
  //                 if (states.contains(MaterialState.pressed))
  //                   return Color(0xffB788E5); // <-- Splash color
  //               }),
  //             ),
  //             child: const Text(
  //               "submit",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () => {
  //               submit(
  //                 email.text,
  //                 "address",
  //               )
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget editPhone(BuildContext context, String title) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bottommodeltitle(title),
          Divider(
            thickness: 2,
          ),
          Container(
            decoration: putborder(),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Colors.blue[900],
                  ),
                ),
                Straightline(),
                Expanded(
                  child: TextField(
                    controller: phone,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: 'Edit age',
                      border: InputBorder.none,
                      hintText: 'Please enter age ex:21',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).padding.top) *
                    0.35),
                backgroundColor: MaterialStateProperty.all(
                    Colors.red[900]), // <-- Button color
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.red; // <-- Splash color
                }),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => {
                submit(
                  phone.text,
                  "age",
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget editPassword(BuildContext context, String title) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bottommodeltitle(title),
          Divider(
            thickness: 2,
          ),
          Container(
            decoration: putborder(),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.password_rounded,
                    color: Colors.blue[900],
                  ),
                ),
                Straightline(),
                Expanded(
                  child: TextField(
                    controller: password,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: 'Enter New Password',
                      border: InputBorder.none,
                      hintText: 'Please atleast 8 characters',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    obscureText: true,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).padding.top) *
                    0.35),
                backgroundColor: MaterialStateProperty.all(
                    Colors.red[900]), // <-- Button color
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.red; // <-- Splash color
                }),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => {
                if (password.text.length < 8)
                  {
                    Navigator.of(context).pop(),
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Password must be 7 character long',
                      ),
                      duration: Duration(seconds: 2),
                    )),
                  }
                else
                  {
                    submit(
                      password.text,
                      "Password",
                    )
                  }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Profile',
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            final myListData = [
              json.decode(snapshot.data.getString('userinfo') as String)['age'],
              json.decode(
                  snapshot.data.getString('userinfo') as String)['name'],
              json.decode(
                  snapshot.data.getString('userinfo') as String)['password'],
              json.decode(
                  snapshot.data.getString('userinfo') as String)['phoneno'],
              json.decode(
                  snapshot.data.getString('userinfo') as String)['email'],
              json.decode(
                  snapshot.data.getString('userinfo') as String)['address'],
            ];
            return ListView.builder(
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    elevation: 5,
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        "${myList[index]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Text(
                        "${myListData[index]}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: index < 3
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.red[900],
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0)),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      if (index == 0)
                                        return editPhone(context, "Edit Age");
                                      // else if (index == 1)
                                      //   return editEmail(context, "Edit Email");
                                      else if (index == 1)
                                        return editCNIC(context, "Edit name");
                                      else
                                        return editPassword(
                                            context, "Change Password");
                                    });
                              },
                            )
                          : Icon(Icons.lock),
                    ),
                  );
                });
          }),
    );
  }
}

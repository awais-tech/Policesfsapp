import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:policesfs/screen/Aboutus.dart';
import 'package:policesfs/screen/Dashboard.dart';
import 'package:policesfs/screen/ManageComplaints/ComplaintEmergency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Drawner extends StatelessWidget {
  const Drawner({
    Key? key,
    required this.navigators,
  }) : super(key: key);

  final List<String> navigators;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: LayoutBuilder(builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: SharedPreferences
                    .getInstance(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children = [Container(child: Text('email'))];
                  if (snapshot.hasData) {
                    var c = json
                        .decode(snapshot.data.getString('userinfo') as String);
                    children = <Widget>[
                      Container(
                        color: Colors.blue,
                        child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Colors.blue),
                          accountEmail: Text(c['email']),
                          accountName: Text(c['name']),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
              Container(
                color: Colors.blue[900],
                height: constraints.minHeight * 0.7,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: navigators.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 3),
                        child: ListTile(
                          onTap: () async {
                            if (navigators[index] ==
                                "Emergency Complaint detail") {
                              Navigator.of(context)
                                  .pushNamed(ComplaintEmergency.routeName);
                            } else if (navigators[index] == "About Us") {
                              Navigator.of(context)
                                  .pushNamed(AboutUs.routeName);
                            } else if (navigators[index] == "Whats app") {
                              var url =
                                  "whatsapp://send?text=Emgergency need help&phone=+923324343256";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw url;
                              }
                            }
                          },
                          leading: Icon(
                            Complainantdashboard.navigatorsIcon[index],
                            color: Colors.white,
                          ),
                          title: Text(
                            "${navigators[index]}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

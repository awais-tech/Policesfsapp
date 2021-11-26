import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:policesfs/Constants.dart';
import 'package:policesfs/providers/Auth.dart';

import 'package:policesfs/screen/ManageComplaints/ComplaintHistoryScreen.dart';
import 'package:policesfs/screen/ManageComplaints/RegisteredComplaints.dart';

import 'package:policesfs/screen/ManageComplaints/orderstabscreen.dart';
import 'package:policesfs/screen/Chat/chat.dart';
import 'package:policesfs/widgets/drawner/drawner.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Complainantdashboard extends StatefulWidget {
  static final routeName = "home";
  static List<IconData> navigatorsIcon = [
    Icons.home,
    Icons.local_police_outlined,
    Icons.person_outlined,
    Icons.message
  ];

  @override
  _ComplainantdashboardState createState() => _ComplainantdashboardState();
}

class _ComplainantdashboardState extends State<Complainantdashboard> {
  var prefs;

  final List<String> navigators = [
    "Home",
    "About Us",
    "Emergency Complaint detail",
    "Whats app",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: FittedBox(fit: BoxFit.fitWidth, child: Text('Dashboard')),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var url = "tel:03324343256";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw url;
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                side: MaterialStateProperty.all(
                    BorderSide(width: 1, color: Colors.black38)),
                backgroundColor: MaterialStateProperty.all(Colors.red[900]),
              ),
              child: FittedBox(
                  fit: BoxFit.fitWidth, child: Text('Emergency Call')),
            ),
          ],
        ),
        drawer: Drawner(navigators: navigators),
        body: LayoutBuilder(builder: (ctx, constraints) {
          return Center(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CarouselSlider(
                          items: [
                            //1st Image of Slider
                            Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://courtingthelaw.com/wp-content/uploads/punjab-police-484x290.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            //2nd Image of Slider
                            Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://punjabpolice.gov.pk/system/files/mainbanner-bg-2.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            //3rd Image of Slider
                            Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://i.guim.co.uk/img/static/sys-images/Guardian/Pix/pictures/2014/10/6/1412613942090/dea827f7-44df-48ae-a7aa-2284311299f7-2060x1236.jpeg?width=620&quality=85&auto=format&fit=max&s=ee64be8ddc8daa63c0acaaf24915449a"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            //4th Image of Slider
                            Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://i.pinimg.com/originals/ec/7c/86/ec7c86a82e4b6010b577c690e202378a.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            //5th Image of Slider
                            Container(
                              margin: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://www.thenews.com.pk/assets/uploads/akhbar/2021-07-28/869757_7032377_Punjab-police-to-visit-Turkey-for-probe_akhbar.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],

                          //Slider Container properties
                          options: CarouselOptions(
                            height: 180.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: constraints.maxHeight * 0.20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            color: Colors.pink,
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ComplaintHistory.routeName);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.history_rounded,
                                    size: 65,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Complaints History",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ), //BoxDecoration
                        ), //Container
                      ), //Flexible
                      SizedBox(
                        width: 20,
                      ),
                      //Flexible

                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: constraints.maxHeight * 0.20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            elevation: 8,
                            color: Colors.amber[400],
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(Chat.routeName);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.chat,
                                    size: 65,
                                  ),
                                  Text(
                                    "Chat",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ), //BoxDecoration
                          ),
                        ),
                      ), //Container
                    ],
                  ),
                  //Row
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          width: 380,
                          height: constraints.maxHeight * 0.20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            elevation: 8,
                            color: Colors.pink[200],
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Addcomplaint.routeName);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.add_moderator_outlined,
                                    size: 65,
                                  ),
                                  Text(
                                    "Register New Complaint",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ), //BoxDecoration
                        ), //Container
                      ),
                    ],
                  ), //Flexible
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Container(
                          width: 180,
                          height: constraints.maxHeight * 0.20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            elevation: 8,
                            color: Colors.cyanAccent[400],
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ComplaintTrack.routeName);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.track_changes_rounded,
                                    size: 65,
                                  ),
                                  Text(
                                    "Track Complaints",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ), //BoxDecoration
                        ),
                        //Container
                      ), //Flexible
                      SizedBox(
                        width: 20,
                      ), //SixedBox
                      Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                            width: 180,
                            height: constraints.maxHeight * 0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Card(
                              elevation: 8,
                              color: Colors.deepOrange[700],
                              child: InkWell(
                                onTap: () {
                                  Provider.of<Auth>(context, listen: false)
                                      .logout();
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      size: 65,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ), //BoxDecoration
                          ) //Container,
                          ) //Flexible
                    ], //<widget>[]
                    mainAxisAlignment: MainAxisAlignment.center,
                  ), //Row
                ], //<Widget>[]
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
              ), //Column
            ) //Padding
                ), //Container
          );
        }) //Center
        ); //Scaffold
  }
}

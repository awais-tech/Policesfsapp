import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  static const routeName = '/aboutus';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            'About Us',
            textAlign: TextAlign.center,
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio magna, sollicitudin eu mattis a, sodales ac tortor. Praesent maximus risus quis sapien gravida commodo. Integer ut consequat nisl. Proin non est at elit tempus blandit. Donec ultrices aliquam magna ac feugiat. Etiam aliquet aliquam turpis in imperdiet. Nulla vitae ante accumsan, posuere odio quis, condimentum turpis. Pellentesque ligula ligula, sagittis vel consequat quis, blandit sed turpis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

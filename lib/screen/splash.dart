import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:policesfs/screen/Auth/Signupscreen..dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => SignUp())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateRoute: SignUp(),
        duration: 5000,
        imageSize: 130,
        imageSrc: "assets/Images/Logo.png",
        text: "WELCOME TO POLICE SFS",
        textType: TextType.NormalText,
        textStyle: TextStyle(
          fontSize: 16.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
    // final deviceSize = MediaQuery.of(context).size;
    // return Scaffold(
    //     body: Center(
    //   child: Image(
    //     width: double.infinity,
    //     height: double.infinity / 2,
    //     image: AssetImage('assets/Images/Logo.png'),
    // child: Stack(
    //   children: <Widget>[
    //     Container(
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [
    //             Color.fromRGBO(215, 117, 255, 1).withOpacity(0.3),
    //             Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
    //           ],
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //           stops: [0, 1],
    //         ),
    //       ),
    //     ),
    //     SingleChildScrollView(
    //       child: Container(
    //         height: deviceSize.height,
    //         width: deviceSize.width,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Flexible(
    //               child: Container(
    //                 margin: EdgeInsets.only(bottom: 20.0),
    //                 padding: EdgeInsets.symmetric(
    //                     vertical: 8.0, horizontal: 94.0),
    //                 transform: Matrix4.rotationZ(-8 * pi / 180)
    //                   ..translate(-10.0),
    //                 // ..translate(-10.0),
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(20),
    //                   color: Colors.pink,
    //                   boxShadow: [
    //                     BoxShadow(
    //                       blurRadius: 8,
    //                       color: Colors.black26,
    //                       offset: Offset(0, 2),
    //                     )
    //                   ],
    //                 ),
    //                 child: Text(
    //                   'Police SFS',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 50,
    //                     fontFamily: 'Anton',
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    //   ),
    // ));
  }
}

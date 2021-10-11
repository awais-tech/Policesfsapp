import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/Dashboard.dart';
import 'package:policesfs/manageorders/orders_screen.dart';
import 'package:policesfs/manageorders/orderstabscreen.dart';
import 'package:policesfs/screen/HomeSreen.dart';
import 'package:policesfs/screen/Signscreen.dart';
import 'package:policesfs/screen/Signupscreen..dart';
import 'package:policesfs/screen/chat.dart';
import 'package:policesfs/screen/splash.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: AlertDialog(
            content: Text('Something went wrong. Please restart the app.'),
          ),
        ),
      );
    }
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Police SFS',
          theme: ThemeData(
            backgroundColor: Colors.blue[900],
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.amber,
            fontFamily: 'QuickSand',
          ),
          home: auth.isAuth
              ? Complainantdashboard()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? Splash()
                          : SignIn(),
                ),
          routes: {
            SignUp.routeName: (ctx) => SignUp(),
            Complainantdashboard.routeName: (ctx) => Complainantdashboard(),
            ComplaintHistory.routeName: (ctx) => ComplaintHistory(),
            ComplaintTrack.routeName: (ctx) => ComplaintTrack(),
            Chat.routeName: (ctx) => Chat(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('E-Solution for WM'),
//       ),
//       body: Center(
//         child: Text('Loading..'),
//       ),
//     );
//   }
// }

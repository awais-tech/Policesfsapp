import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/Profile.dart';
import 'package:policesfs/providers/Auth.dart';
import 'package:policesfs/providers/Complaints.dart';

import 'package:policesfs/providers/utilities.dart';
import 'package:policesfs/screen/Aboutus.dart';
import 'package:policesfs/screen/Auth/Signscreen.dart';
import 'package:policesfs/screen/Auth/Signupscreen..dart';
import 'package:policesfs/screen/Chat/ChatUser.dart';
import 'package:policesfs/screen/Chat/chat.dart';
import 'package:policesfs/screen/Dashboard.dart';
import 'package:policesfs/screen/ManageComplaints/ComplaintEmergency.dart';
import 'package:policesfs/screen/ManageComplaints/ComplaintHistoryScreen.dart';
import 'package:policesfs/screen/ManageComplaints/RegisteredComplaints.dart';
import 'package:policesfs/screen/ManageComplaints/orderstabscreen.dart';
import 'package:policesfs/screen/splash.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => Utilities(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Complaints(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Police SFS',
          theme: ThemeData(primarySwatch: Colors.blue),
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
            Addcomplaint.routeName: (ctx) => Addcomplaint(),
            ComplaintEmergency.routeName: (ctx) => ComplaintEmergency(),
            AboutUs.routeName: (ctx) => AboutUs(),
            ChatUser.routeName: (ctx) => ChatUser(),
            Profile.routeName: (ctx) => Profile()
          },
        ),
      ),
    );
  }
}

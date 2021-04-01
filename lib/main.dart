import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/landing_page.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Time Tracker',
    //   theme: ThemeData(
    //     primarySwatch: Colors.teal,
    //   ),
    //   home: LandingPage(
    //     auth: Auth(),
    //   ),
    // );
    // return MaterialApp(
    //   initialRoute: WelcomeScreen.id,
    //   routes: {
    //     WelcomeScreen.id: (context) => WelcomeScreen(),
    //     LoginScreen.id: (context) => LoginScreen(),
    //     RegistrationScreen.id: (context) => RegistrationScreen(),
    //     //ChatScreen.id: (context) => ChatScreen(),
    //   },
    // );
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Manager',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LandingPage(),
      ),
    );
  }
}


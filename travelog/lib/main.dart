import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelog/screens/newJourney.dart';
import './screens/home.dart';
import './screens/login.dart';
import './screens/editDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travelog',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan[200],
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
      // home: HomePage(title: 'Travelog'),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return LoginPage();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'data/firebase.dart';
import 'login_page.dart';
//import 'mongo.dart';

Future<void> main() async {
  firebaseInit();
  //connectToDb();
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: LoginPage(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

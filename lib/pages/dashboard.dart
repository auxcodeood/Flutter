import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var user =
        loggedUser['firstName'] != null && loggedUser['lastName'] != null
            ? '${loggedUser["firstName"]} ${loggedUser["lastName"]}'
            : "Dear User";
    return Scaffold(
        body: Center(
            child: Text('$user, Welcome to Thomas Lloyd made in Flutter')));
  }
}

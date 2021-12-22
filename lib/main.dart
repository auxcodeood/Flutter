import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'data/firebase.dart';
import 'data/graphql.dart';
import 'login_page.dart';
//import 'mongo.dart';

Future<void> main() async {
  await initGraphQlClient();
  await firebaseInit();
  //connectToDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: ValueNotifier(client!),
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const LoginPage(),
        ));
  }
}

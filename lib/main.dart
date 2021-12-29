import 'package:flutter/material.dart';
import 'package:flutter_app/profile_data_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'data/firebase.dart';
import 'data/graphql.dart';
//import 'mongo.dart';

dynamic settings = {};
Future<void> main() async {
  await initGraphQlClient();
  await firebaseInit();
  settings = (await getSettings());
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
          theme: settings['darkMode'] ? ThemeData.dark() : ThemeData.light(),
          home: const ProfileDataPage(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/orders.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'data/firebase.dart';
import 'data/graphql.dart';
import 'login_page.dart';
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
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
          initialRoute: '/',
          routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/orders': (context) => const OrderPage()
          },
        ));
  }
}
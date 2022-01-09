import 'package:flutter/material.dart';
import 'package:flutter_app/biometrics.dart';
import 'package:flutter_app/pages/camera.dart';
import 'package:flutter_app/pages/dashboard.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/orders.dart';
import 'package:flutter_app/pages/questionnaire.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'data/firebase.dart';
import 'data/graphql.dart';
import 'login_page.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
//import 'mongo.dart';

dynamic settings = {};
List<CameraDescription> cameras = [];
Map<String, dynamic> loggedUser = {};
Future<void> main() async {
  await initGraphQlClient();
  await firebaseInit();
  settings = (await getSettings());
  //connectToDb();
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(const MyApp());
}

/// May throw a [CameraException].
Future<List<CameraDescription>> availableCameras() async {
  return CameraPlatform.instance.availableCameras();
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
            '/orders': (context) => const OrderPage(),
            '/dashboard': (context) => const Dashboard(),
            '/questionnaire': (context) => const Questionnaire(),
            '/biometrics': (context) => Biometrics(),
            '/photos': (context) => CameraExampleHome()
          },
        ));
  }
}

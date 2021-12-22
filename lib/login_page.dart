import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'data/graphql.dart';
import 'data/firebase.dart';
import 'biometrics.dart';
import 'camera.dart';
import 'query.dart';
//import 'mongo.dart';

// ignore: constant_identifier_names
const LIME_GREEN = Color(0xFFC4FF19);
// ignore: constant_identifier_names
const DARK_GREEN = Color(0xFF043D44);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  CameraDescription _camera = CameraDescription(
      name: 'asd',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 2);

  @override
  void initState() {
    super.initState();
    _getCamera();
  }

  Future<void> _getCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    setState(() {
      _camera = cameras.first;
    });
  }

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Column(
                children: [
                  ToggleSwitch(
                    initialLabelIndex: 0,
                    totalSwitches: 2,
                    labels: ['EN', 'BG'],
                    onToggle: (index) {
                      if (index == 1) {
                        locale = "bg";
                      } else {
                        locale = "en";
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      suffixIcon: emailController.text.isEmpty
                          ? const Text('')
                          : GestureDetector(
                              onTap: () {
                                emailController.clear();
                              },
                              child: const Icon(Icons.close)),
                      hintText: 'example@mail.com',
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: isVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            isVisible = !isVisible;
                            setState(() {});
                          },
                          child: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey)),
                      hintText: 'type your password',
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(240, 50),
                        primary: LIME_GREEN,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      ),
                      onPressed: () async {
                        // await addUser(emailController.text,
                        //     passwordController.text);
                        // await signin(
                        //     emailController.text, passwordController.text);
                        await executeQuery();
                        final user = await getUserByEmail(emailController.text);
                        if (user['password'] == passwordController.text) {
                          print("password is correct");
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text('Your submitted data '),
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.mail),
                                      title:
                                          Text(emailController.text.toString()),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.lock),
                                      title: Text(
                                          passwordController.text.toString()),
                                    ),
                                  ],
                                );
                              });
                        } else
                          print("wrong password");
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [LoginButton()],
                      )),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(240, 50),
                      primary: LIME_GREEN,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Fingerprint',
                          style: TextStyle(
                              color: DARK_GREEN, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.fingerprint, color: DARK_GREEN),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Biometrics()),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(240, 50),
                      primary: LIME_GREEN,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Take a selfie',
                          style: TextStyle(
                              color: DARK_GREEN, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.camera,
                          color: DARK_GREEN,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TakePictureScreen(camera: _camera)),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

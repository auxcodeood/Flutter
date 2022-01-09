import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'colors.dart';
import 'data/graphql.dart';
import 'data/firebase.dart';
import 'types/locale.dart';
//import 'mongo.dart';

dynamic settings = {};
Future<void> main() async {
  await initGraphQlClient();
  await firebaseInit();
  settings = (await getSettings());
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  late Future<QueryResult> _translations;
  int toggleIndex = 0;
  int registerToggleIndex = 0;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _translations = buttonsQuery(Locale.EN);
  }

  void _onToggle(int index) {
    setState(() {
      _translations = buttonsQuery(index == 0 ? Locale.EN : Locale.BG);
      toggleIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //var translations = pesho;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
          ),
          FutureBuilder<QueryResult>(
              future: _translations,
              builder: (context, snapshot) => snapshot.hasData
                  ? buildFormBuilder(context, snapshot.data)
                  : const SizedBox())
        ],
      ),
    );
  }

  ToggleSwitch buildRegisterToggle() {
    return ToggleSwitch(
        initialLabelIndex: registerToggleIndex,
        totalSwitches: 2,
        labels: const ['Login', 'Register'],
        activeBgColor: [LIME_GREEN],
        activeFgColor: DARK_GREEN,
        inactiveBgColor: Colors.blueGrey,
        inactiveFgColor: Colors.white,
        curve: Curves.bounceInOut,
        onToggle: (int index) {
          setState(() {
            isLogin = index == 0 ? true : false;
            registerToggleIndex = index;
          });
        });
  }

  Future openDialog(String email) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('User with email $email registered successfully'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'))
                ]));
  }

    Future wrongLoginDialog(String result) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("There was an error with the login: $result. But we'll let you pass for the demo :)"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'))
                ]));
  }

  Expanded buildFormBuilder(BuildContext context, data) {
    print("snapshot data");
    print(data);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35))),
        child: Column(
          children: [
            ToggleSwitch(
              initialLabelIndex: toggleIndex,
              totalSwitches: 2,
              labels: const ['EN', 'BG'],
              activeBgColor: [LIME_GREEN],
              activeFgColor: DARK_GREEN,
              inactiveBgColor: Colors.blueGrey,
              inactiveFgColor: Colors.white,
              curve: Curves.bounceInOut,
              onToggle: _onToggle,
            ),
            const SizedBox(height: 50),
            Text(
              isLogin
                  ? data.data!['home']['loginTitle']
                  : data.data!['home']['registerTitle'],
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
                        isVisible ? Icons.visibility : Icons.visibility_off,
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
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: () async {
                  if (isLogin) {
                    var result = await signin(emailController.text, passwordController.text);
                    if(result != "success"){
                      await wrongLoginDialog(result);
                    }
                    Navigator.pushNamed(context, "/home");
                  } else {
                    await register(
                        emailController.text, passwordController.text);
                    openDialog(emailController.text);
                    setState(() {
                      isLogin = true;
                      registerToggleIndex = 0;
                    });
                    isLogin = true;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLogin
                          ? data.data!['home']['loginButton']
                          : data.data!['home']['registerButton'],
                      style: TextStyle(
                          color: DARK_GREEN, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.login,
                      color: DARK_GREEN,
                    ),
                  ],
                )),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240, 50),
                primary: LIME_GREEN,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Use fingerprint',
                    style: TextStyle(
                        color: DARK_GREEN, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.fingerprint, color: DARK_GREEN),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/biometrics');
              },
            ),
            const SizedBox(height: 32),
            buildRegisterToggle()
          ],
        ),
      ),
    );
  }
}

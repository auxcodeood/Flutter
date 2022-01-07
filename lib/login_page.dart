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
              data.data!['home']['loginTitle'],
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
                  // await addUser(emailController.text,
                  //     passwordController.text);
                  await signin(emailController.text, passwordController.text);
                  //await executeQuery();
                  Navigator.pushNamed(context, "/home");
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.data!['home']['loginButton'],
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
          ],
        ),
      ),
    );
  }
}

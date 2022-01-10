import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:flutter_app/data/graphql.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/data/firebase.dart';
import 'package:flutter_app/types/locale.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<Portfolio> {
  dynamic translations;

  List<QueryDocumentSnapshot<Object?>>? orders;

  late Future<QueryResult> _translations;
  late Future<dynamic> _orders;

  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _translations = depotQuery(Locale.EN);
    _orders = getOrders();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          //LanguageToggle(),
          FutureBuilder<QueryResult>(
              future: _translations,
              builder: (context, snapshot) => snapshot.hasData
                  ? buildExpandedBuilder(context, snapshot)
                  : const SizedBox())
        ],
      ),
    );
  }

  Future openDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Notice'),
              content: const Text(
                  "Further features will be available in upcoming versions."),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Expanded buildExpandedBuilder(BuildContext context, snapshot) {
    translations = snapshot;
    debugPrint('movieTitle: {$translations.data!.data!}');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 32),
              alignment: Alignment.topLeft,
              child: ToggleSwitch(
                initialLabelIndex: toggleIndex,
                totalSwitches: 2,
                activeBgColor: [LIME_GREEN],
                activeFgColor: DARK_GREEN,
                inactiveBgColor: Colors.blueGrey,
                inactiveFgColor: Colors.white,
                labels: const ['EN', 'BG'],
                onToggle: (index) async {
                  String locale;
                  if (index == 0) {
                    locale = Locale.EN;
                  } else {
                    locale = Locale.BG;
                  }
                  setState(() {
                    _translations = depotQuery(locale);
                    toggleIndex = index;
                  });
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 5, left: 15),
                alignment: Alignment.topLeft,
                child: Image.network(
                  translations.data.data!['home']['myImage']["url"],
                  width: 100,
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            const Text(
              'Depot overview',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${translations.data!.data!['portfolio']['strategyName']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LIME_GREEN,
              ),
            ),
            Text(
              '${translations.data!.data!['portfolio']['strategyValue']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: WHITE,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${translations.data!.data!['portfolio']['totalValueName']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LIME_GREEN,
              ),
            ),
            Text(
              '${translations.data!.data!['portfolio']['totalValueValue']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: WHITE,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${translations.data!.data!['portfolio']['openedName']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LIME_GREEN,
              ),
            ),
            Text(
              '${translations.data!.data!['portfolio']['openedValue']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: WHITE,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${translations.data!.data!['portfolio']['openedName']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LIME_GREEN,
              ),
            ),
            Text(
              '${translations.data!.data!['portfolio']['openedValue']}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: WHITE,
              ),
            ),
            const SizedBox(height: 32),
            Container(
                margin: const EdgeInsets.only(top: 5, left: 15),
                alignment: Alignment.topCenter,
                child: Image.network(
                  translations.data.data!['portfolio']['reads']["url"],
                  width: 200,
                )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                openDialog();
              },
              child: const Text('Change plan'),
            ),
          ],
        ),
      ),
    );
  }
}

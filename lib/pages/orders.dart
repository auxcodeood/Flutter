import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:flutter_app/data/graphql.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/data/firebase.dart';
import 'package:flutter_app/types/locale.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<QueryResult> _translations;
  late Future<dynamic> _products;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
    _products = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
          ),
          FutureBuilder<QueryResult>(
              future: _translations,
              builder: (context, snapshot) {
                return Expanded(
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
                          onToggle: (index) async {
                            String locale;
                            if (index == 0) {
                              locale = Locale.EN;
                            } else {
                              locale = Locale.BG;
                            }
                            print(snapshot.data!.data!['product']
                                ['us88160r1014Name']);
                            print(snapshot.data!.data!['product']
                                ['us007903107Name']);
                            setState(() {
                              _translations = productsQuery(locale);
                            });
                          },
                        ),
                        FutureBuilder<dynamic>(
                            future: _products,
                            builder: (context, snapshot) {
                              final stuff = snapshot.data;
                              return ListView(
                                children: [
                                  Text("US0079031078"),
                                  Text("US88160R1014")
                                ],
                              );
                            })
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}

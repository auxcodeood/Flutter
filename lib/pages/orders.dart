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

var translations;
var products;

class _OrderPageState extends State<OrderPage> {
  late Future<QueryResult> _translations;
  late Future<dynamic> _products;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
    _products = getProducts();
  }

  Widget _buildListView() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 80,
          color: LIME_GREEN,
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.assessment_outlined, color: DARK_GREEN),
              title: Text(
                translations.data!.data != null
                    ? translations.data!.data!['product']
                            ['${products[index]['isin'].toLowerCase()}Name'] ??
                        "missing"
                    : "missing translation",
                style: const TextStyle(
                    color: DARK_GREEN, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${translations.data!.data!['product']['${products[index]['isin'].toLowerCase()}Price'] ?? "price"} ${translations.data!.data!['product']['${products[index]['isin'].toLowerCase()}Currency'] ?? "currency"}',
                style: const TextStyle(color: DARK_GREEN),
              ),
              onTap: () =>
                  {print('tapped ${products[index]['isin'].toLowerCase()}')},
              onLongPress: () =>
                  {print('pressed ${products[index]['isin'].toLowerCase()}')},
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _products = getProducts();
    });
    return Scaffold(
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
          ),
          //LanguageToggle(),
          FutureBuilder<QueryResult>(
              future: _translations,
              builder: (context, snapshot) {
                translations = snapshot;
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
                            setState(() {
                              _translations = productsQuery(locale);
                            });
                          },
                        ),
                        FutureBuilder<dynamic>(
                            future: _products,
                            builder: (context, snapshot) {
                              products = snapshot.data;

                              if (products != null &&
                                  translations != null &&
                                  translations.data != null) {
                                return _buildListView();
                              } else {
                                return const Text("Loading...");
                              }
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

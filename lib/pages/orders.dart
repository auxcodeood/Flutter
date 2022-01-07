import 'package:cloud_firestore/cloud_firestore.dart';
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
  dynamic translations;
  dynamic products;

  List<QueryDocumentSnapshot<Object?>>? orders;

  late Future<QueryResult> _translations;
  late Future<dynamic> _products;
  late Future<dynamic> _orders;

  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
    _products = getProducts();
    _orders = getOrders();
  }

  Widget _buildTile(int index) {
    return ListTile(
      leading: const Icon(Icons.assessment_outlined, color: DARK_GREEN),
      title: Text(
        translations.data!.data != null
            ? translations.data!.data!['product']
                    ['${products[index]['isin'].toLowerCase()}Name'] ??
                "missing"
            : "missing translation",
        style: const TextStyle(color: DARK_GREEN, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${translations.data!.data!['product']['${products[index]['isin'].toLowerCase()}Price'] ?? "price"} ${translations.data!.data!['product']['${products[index]['isin'].toLowerCase()}Currency'] ?? "currency"}',
        style: const TextStyle(color: DARK_GREEN),
      ),
      trailing: orders!.any((x) => x['isin']
              .toLowerCase()
              .contains(products[index]['isin'].toLowerCase()))
          ? const Icon(Icons.shopping_cart, color: DARK_GREEN)
          : const Icon(Icons.shopping_cart_outlined, color: DARK_GREEN),
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text("Are you sure you want to make an order?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () async {
                      if (!orders!.any((x) => x['isin']
                          .toLowerCase()
                          .contains(products[index]['isin'].toLowerCase()))) {
                        await insertOrders(products[index]['isin']);
                      }
                      setState(() {
                        _orders = getOrders();
                      });
                      print(
                          'you agreed on ${products[index]['isin'].toLowerCase()}');
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      onLongPress: () async {
        await deleteOrder(products[index]['isin']);
        setState(() {
          _orders = getOrders();
        });
        print('pressed ${products[index]['isin'].toLowerCase()}');
      },
    );
  }

  Widget _buildListView() {
    return FutureBuilder<dynamic>(
        future: _products,
        builder: (context, snapshot) {
          products = snapshot.data;
          if (products != null &&
              translations != null &&
              translations.data != null) {
            return FutureBuilder<dynamic>(
                future: _orders,
                builder: (context, snapshot) {
                  orders = snapshot.data;
                  if (orders != null) {
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
                            child: _buildTile(index),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  } else {
                    return const Text("Loading...");
                  }
                });
          } else {
            return const Text("Loading...");
          }
        });
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

  Expanded buildExpandedBuilder(BuildContext context, snapshot) {
    translations = snapshot;
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
                    _translations = productsQuery(locale);
                    toggleIndex = index;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
            ),
            const Text(
              'Products',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildListView()
          ],
        ),
      ),
    );
  }
}

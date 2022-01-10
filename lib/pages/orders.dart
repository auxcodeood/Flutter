import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
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
  List<dynamic>? orders;

  late Future<QueryResult> _translations;

  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
    orders = loggedUser["orders"];
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      orders = loggedUser["orders"];
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
          FutureBuilder<QueryResult>(
              future: _translations,
              builder: (context, snapshot) => snapshot.hasData
                  ? _translationBuilder(context, snapshot)
                  : const SizedBox())
        ],
      ),
    );
  }

  Expanded _translationBuilder(BuildContext context, snapshot) {
    translations = snapshot.data.data;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        constraints: const BoxConstraints.expand(),
        child: ListView(
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
                margin: const EdgeInsets.only(top: 5, left: 15),
                alignment: Alignment.topLeft,
                child: Image.network(
                  translations['home']['myImage']["url"],
                  width: 100,
                )),

            //Orders
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
            ),
            const Text(
              'Orders',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProductsList()
          ],
        ),
      ),
    );
  }

  ListView _buildProductsList() {
    if (orders != null) {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: orders != null ? orders!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: LIME_GREEN,
            child: Center(
              child: _buildTile(index),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else {
      return ListView();
    }
  }

  Widget _buildTile(int index) {
    final order = orders![index];
    return ListTile(
      leading: const Icon(Icons.assessment_outlined, color: DARK_GREEN),
      title: Text(
        order['name'],
        style: const TextStyle(color: DARK_GREEN, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '''
        quantity: ${order["quantity"]}
        price: ${order["price"]} ${order["currency"]}
        total: ${double.parse(order["quantity"] == "" ? "0" : order["quantity"]) * double.parse(order["price"])} ${order["currency"]}
       ''',
        style: const TextStyle(color: DARK_GREEN),
      ),
      onTap: () async {
        _onProductDelete(order);
        print("delete order");
      },
    );
  }

  Future<dynamic> _onProductDelete(dynamic order) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: Text(
              "You'll delete your order of ${order['name']} stock with quantity ${order["quantity"]}"),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                removeOrder(order);
                setState(() {
                  orders!
                      .removeWhere((element) => element['id'] == order['id']);
                });
                Navigator.of(context).pop(order);
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
}

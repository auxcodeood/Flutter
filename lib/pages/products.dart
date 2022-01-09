import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:flutter_app/data/graphql.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/data/firebase.dart';
import 'package:flutter_app/types/locale.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController priceController = TextEditingController();
  dynamic translations;
  dynamic products;

  late Future<QueryResult> _translations;
  late Future<dynamic> _products;

  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
    _products = getProducts();
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  Widget _buildTile(int index) {
    final isin = products[index]['isin'];
    final price =
        '${translations['product']['${isin.toLowerCase()}Price'] ?? "price"} ${translations['product']['${isin.toLowerCase()}Currency'] ?? "currency"}';
    return ListTile(
      leading: const Icon(Icons.assessment_outlined, color: DARK_GREEN),
      title: Text(
        translations['product']['${isin.toLowerCase()}Name'] ?? isin,
        style: const TextStyle(color: DARK_GREEN, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        price,
        style: const TextStyle(color: DARK_GREEN),
      ),
      trailing: const Icon(Icons.shopping_cart_outlined, color: DARK_GREEN),
      onTap: () async {
        Map<String, dynamic> order = await _onProductBuy(isin, price);
        print(order);
      },
      onLongPress: () async {
        // await deleteOrder(isin);
        print('pressed ${isin.toLowerCase()}');
      },
    );
  }

  Widget _buildListView() {
    return FutureBuilder<dynamic>(
        future: _products,
        builder: (context, snapshot) => snapshot.hasData
            ? buildProductsList(context, snapshot)
            : const SizedBox());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DARK_GREEN,
      body: Column(
        children: [
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
    translations = snapshot.data.data;
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
                margin: const EdgeInsets.only(top: 5, left: 15),
                alignment: Alignment.topLeft,
                child: Image.network(
                  translations['home']['myImage']["url"],
                  width: 100,
                )),
            
            //Products
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
            ),
            const Text(
              'Products',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildListView(),
          ],
        ),
      ),
    );
  }

  ListView buildProductsList(BuildContext context, snapshot) {
    products = snapshot.data;
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
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Future<dynamic> _onProductBuy(String isin, String price) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "How much ${translations['product']['${isin.toLowerCase()}Name']} stock do you want to buy at price $price?"),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(hintText: "Enter number of assets"),
            controller: priceController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                Map<String, dynamic> order = {
                  "isin": isin,
                  "name": translations['product']['${isin.toLowerCase()}Name'],
                  "price": price,
                  "quantity": priceController.text
                };
                await insertOrder(order);
                priceController.clear();
                Navigator.of(context).pop(order);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

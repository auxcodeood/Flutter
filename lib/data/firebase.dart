import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Order {
  final String isin;
  Order({required this.isin});

  Order.fromJson(Map<String, Object?> json)
      : this(
          isin: json['isin']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'isin': isin,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Order && other.runtimeType == runtimeType && other.isin == isin;

  @override
  int get hashCode => isin.hashCode;
}

Future<void> firebaseInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDIO5uzVQ73-7YYWGo0qKMiM_Zm96B5ECk",
      appId: "1:238716424724:android:3ad9796a029c480e06cd01",
      messagingSenderId: "238716424724",
      projectId: "hackaton-poc-4a333",
    ),
  );
}

CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference orders =
    FirebaseFirestore.instance.collection('orders').withConverter<Order>(
          fromFirestore: (snapshot, _) => Order.fromJson(snapshot.data()!),
          toFirestore: (order, _) => order.toJson(),
        );
CollectionReference products =
    FirebaseFirestore.instance.collection('products');
CollectionReference settings =
    FirebaseFirestore.instance.collection('settings');

Future<void> addUser(String email, String password) {
  return users
      .add({
        'email': email,
        'password': password,
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<dynamic> getUserByEmail(String email) async {
  final user = await users
      .where('email', isEqualTo: email)
      .limit(1)
      .get()
      .then((snapshot) => snapshot.docs[0]);
  return user;
}

Future<dynamic> getUser() async {
  final user = await users.get().then((snapshot) => snapshot.docs[0]);
  return user;
}

Future<void> updateByEmail(String email, dynamic user) async {
  try {
    return users.doc((await getUserByEmail(email)).id).update(user);
  } on FirebaseException catch (e) {
    print('Something went wrong while updating user with email ' +
        email +
        ' err - ' +
        e.message!);
  }
}

Future<dynamic> getProducts() async {
  final allProducts =
      (await products.get()).docs.map((doc) => doc.data()).toList();
  return allProducts;
}

Future<List<QueryDocumentSnapshot<Object?>>> getOrders() async {
  List<QueryDocumentSnapshot<Object?>> tempOrders =
      (await orders.get().then((snapshot) => snapshot.docs));
  final allOrders = (await orders.get()).docs.map((doc) => doc.data()).toList();
  return tempOrders;
}

Future<void> insertOrders(String isin) async {
  orders.add(Order(isin: isin)).then((value) => print("Order Added"));
}

Future<void> deleteOrder(String isin) async {
  await orders.where("isin", isEqualTo: isin).get().then((value) {
    for (var element in value.docs) {
      orders.doc(element.id).delete().then((value) {
        print("Success!");
      });
    }
  });
}

Future<void> register(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signin(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
        print("logged in successfully");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      //await register(email, password);
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    } else if (e.code == "invalid-email"){
      print("Invalid email");
    }
  }
}

Future<dynamic>? getSettings() async {
  try {
    final settingsData =
        await settings.get().then((snapshot) => snapshot.docs[0]);
    return settingsData;
  } on Exception catch (e) {
    print(
        'Something went wrong while fetching settings from firestore, err - ' +
            e.toString());
    return null;
  }
}

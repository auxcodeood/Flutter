import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:uuid/uuid.dart';

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

Future<void> addUser(String email) {
  return users
      .add({'email': email, "orders": FieldValue.arrayUnion([])})
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
    await users.doc((await getUserByEmail(email)).id).update(user);
    await SyncUser(email);
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

Future<void> insertOrder(Map<String, dynamic> order) async {
  var id = (Uuid()).v1();
  order['id'] = id;
  await updateByEmail(loggedUser['email'], {
    "orders": FieldValue.arrayUnion([order])
  });
  await SyncUser(loggedUser['email']);
}

Future<void> removeOrder(dynamic order) async {
  await updateByEmail(loggedUser['email'], {
    "orders": FieldValue.arrayRemove([order])
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

Future<String> signin(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await SyncUser(email);
    return "success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    } else if (e.code == "invalid-email") {
      print("Invalid email");
    }
    await SyncUser(email);
    return e.code;
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

Future<void> SyncUser(String email) async {
  dynamic user = {};
  try {
    user = await getUserByEmail(email);
  } on IndexError catch (e) {
    await addUser(email);
    user = await getUserByEmail(email);
  } on RangeError catch (e) {
    await addUser(email);
    user = await getUserByEmail(email);
  } catch (e) {
    print(e);
  } finally {
    loggedUser = user.data();
  }
}

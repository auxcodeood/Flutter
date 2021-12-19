import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      //await register(email, password);
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

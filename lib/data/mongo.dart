// import 'package:mongo_dart/mongo_dart.dart';
// import 'dart:io' show Platform;

// late Db db;
// late DbCollection UserModel;

// void connectToDb() async {
//   db = Db(
//       'mongodb://mario:vasilev@mariocluster-shard-00-00.tamyp.mongodb.net:27017,mariocluster-shard-00-01.tamyp.mongodb.net:27017,mariocluster-shard-00-02.tamyp.mongodb.net:27017/MarioDB?authSource=admin&compressors=disabled&gssapiServiceName=mongodb&replicaSet=atlas-qgugk2-shard-0&ssl=true');
//   await db.open();
//   UserModel = db.collection('users');
// }

// Future<dynamic> findByEmail(String email) async {
//   var user = await UserModel.findOne({"email": email});
//   print(
//       "===============================================USER=======================================");
//   print(user);
//   return user;
// }

// Future<void> insertByEmail(String email, dynamic data) async {
//   var result = await UserModel.insertOne(
//       {"email": data['email'], "password": data['password']});
//   print(result);
// }

// import 'package:graphql_flutter/graphql_flutter.dart';


// late Db db;
// late DbCollection UserModel;


// void connectToGraphQL() async {
//   await initHiveForFlutter();
//   final HttpLink httpLink = HttpLink(
//     'https://testing-9787.admin.datocms.com/',
//   );
//   final AuthLink authLink = AuthLink(
//     getToken: () async => 'Bearer 65ac1ebdd4570a1667873978c2b2b5',
//     // OR
//     // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
//   );
//    final Link link = authLink.concat(httpLink);

//    ValueNotifier<GraphQLClient> client = ValueNotifier(
//     GraphQLClient(
//       link: link,
//       // The default store is the InMemoryStore, which does NOT persist to disk
//       store: GraphQLCache(store: HiveStore()),
//     ),
//   );
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

// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// import 'data/graphql.dart';
// import 'login_page.dart';

// class LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext) {
//     return Query(
//       options: QueryOptions(
//         document: gql(allHomesNew),
//         variables: {"locale": locale},
//         // pollInterval: Duration(seconds: 10)
//       ),
//       builder: (QueryResult result,
//           {VoidCallback? refetch, FetchMore? fetchMore}) {
//         if (result.hasException) {
//           return Text(result.exception.toString());
//         }

//         if (result.isLoading) {
//           return const Text('Loading');
//         }

//         String loginButtonText = result.data!['home']['loginButton'];

//         return Text(
//           loginButtonText,
//           style: TextStyle(color: DARK_GREEN, fontWeight: FontWeight.bold),
//         );
//       },
//     );
//   }
// }

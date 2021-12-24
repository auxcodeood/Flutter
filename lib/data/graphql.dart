import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient? client;

Future<void> initGraphQlClient() async {
  await initHiveForFlutter();
  final HttpLink httpLink = HttpLink(
    'https://graphql.datocms.com/',
  );
  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer 1f6a3be4a08dbaa3491b7fa0e24f52',
  );
  final Link link = authLink.concat(httpLink);

  client = GraphQLClient(
    link: link,
    // The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(store: HiveStore()),
  );
}

// String allHomes = """
//       query allHomesEN {
//         home(locale: $locale) {
//           anotherTitle
//           homeTitle
//           loginButton
//         }
//       }
// """;

// String allHomesNew = """
//       query querryName {
//   home(locale: $locale) {
//     loginButton
//   }
// }
// """;

Future<QueryResult> executeQuery(String locale) async {
  String allHomesNew = """
      query querryName {
  home(locale: $locale) {
    loginButton
    selfieButton
  }
}
""";

  final results = await client!.query(QueryOptions(document: gql(allHomesNew)));
  print(results.data!["home"]);
  return results;
}

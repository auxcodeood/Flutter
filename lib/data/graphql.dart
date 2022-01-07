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
      defaultPolicies:
          DefaultPolicies(query: Policies(fetch: FetchPolicy.cacheAndNetwork,error: ErrorPolicy.all)));
}

Future<QueryResult> buttonsQuery(String locale) async {
  String allHomes = """
      query querryName {
        home(locale: $locale) {
          loginButton
          loginTitle
          registerTitle
          registerButton
        }
}
""";

  final results = await client!.query(QueryOptions(document: gql(allHomes)));
  print(results.data!["home"]);
  return results;
}

Future<QueryResult> productsQuery(String locale) async {
  String allProducts = """
      query querryName {
        product(locale: $locale) {
          us88160r1014Price
          us88160r1014Name
          us88160r1014Currency
          us0079031078Price
          us0079031078Name
          us0079031078Currency
          us0231351067Price
          us0231351067Name
          us0231351067Currency
        }
        home(locale: $locale) {
          myImage {
            url
          }
        }
}
""";

   var results = await client!.query(QueryOptions(document: gql(allProducts)));
  //print(results.data!["product"]);
  return results;
}
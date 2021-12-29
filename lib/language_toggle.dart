import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:flutter_app/data/graphql.dart';
import 'package:flutter_app/types/locale.dart';

class LanguageToggle extends StatefulWidget {
  static AsyncSnapshot<QueryResult>? translations;
  const LanguageToggle({Key? key}) : super(key: key);

  @override
  _LanguageToggleState createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  late Future<QueryResult> _translations;

  @override
  void initState() {
    super.initState();
    _translations = productsQuery(Locale.EN);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
        future: _translations,
        builder: (context, snapshot) {
          LanguageToggle.translations = snapshot;
          return ToggleSwitch(
            initialLabelIndex: 0,
            totalSwitches: 2,
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
              });
            },
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/colors.dart';

class Questionnaire extends StatelessWidget {
  const Questionnaire({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Questionnaire'), backgroundColor: DARK_GREEN),
        body: const Center(child: Text('This is the questionnaire.')));
  }
}

import 'package:testeapibanco/home.dart';
import 'package:flutter/material.dart';

// main
void main() {
  runApp(AutoLeitura());
}

class AutoLeitura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

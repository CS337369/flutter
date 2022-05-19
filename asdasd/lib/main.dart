import 'package:asdasd/screens/create.dart';
import 'package:asdasd/screens/home.dart';
import 'package:asdasd/screens/qr.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/create': (context) => Create(),
        '/qr': (context) => QrView(),
      },
      title: 'test',
    );
  }
}

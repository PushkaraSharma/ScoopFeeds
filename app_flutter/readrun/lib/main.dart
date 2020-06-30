import 'package:flutter/material.dart';
import 'package:readrun/testing.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeroKata',
      theme: new ThemeData(

        primarySwatch: Colors.grey,
      ),
      home:  MainFetchData(),
    );
  }
}

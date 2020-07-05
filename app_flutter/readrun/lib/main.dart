import 'package:flutter/material.dart';
import 'package:readrun/testing.dart';
import 'package:readrun/starting_screen.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
//color  - #FF9D63
    return MaterialApp(
        home: Scaffold(body: StartScreen())
    );
  }
}
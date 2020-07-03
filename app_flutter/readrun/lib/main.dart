import 'package:flutter/material.dart';
import 'package:readrun/testing.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(body: MainFetchData())
    );
  }
}
import 'package:flutter/material.dart';
import 'package:readrun/Splash_screen.dart';
import 'package:readrun/theme.dart';
import 'package:provider/provider.dart';


import 'dart:async';

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
    builder: (context, ThemeNotifier notifier, child){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Scoop Feeds',
        theme: notifier.darkTheme ? dark : light,
        home: Scaffold(body:SplashScreen())
//        theme: ThemeData(
//          scaffoldBackgroundColor: kBackgroundColor,
//          primaryColor: kPrimaryColor,
//          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
//          visualDensity: VisualDensity.adaptivePlatformDensity,
        );

    }));
  }
}

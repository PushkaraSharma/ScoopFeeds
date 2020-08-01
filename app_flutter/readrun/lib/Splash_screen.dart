import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'views/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    startTime();

  }

  @override
  Widget build(BuildContext context) {
    return
      initScreen(context);
  }


  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  initScreen(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Image.asset("assets/icons/logo_intro.png",),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
//              backgroundColor: Colors.white,
              strokeWidth: 1,
            )
          ],
        ),
    );
  }

}
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:readrun/model/constants.dart';
import 'package:readrun/views/information.dart';
import 'HomeScreen.dart';

class No_internet extends StatefulWidget {
  final String topic;
  No_internet({Key key, @required this.topic}) : super(key: key);

  @override
  _No_internetState createState() => _No_internetState(topic:this.topic);
}

class _No_internetState extends State<No_internet> {

  String topic;

  _No_internetState({this.topic});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
//      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
//          color: Colors.white,
          child: Column(children: <Widget>[
            SizedBox(height: height*0.15,),
            Image(image: AssetImage('assets/images/no_net.png'),
              height: height*0.3,
            ),
            SizedBox(height: 20,),
            AutoSizeText("No Internet Connection!",style: TextStyle(fontSize: 18,fontFamily: 'KievitOT',fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            AutoSizeText("Please check your internet connection and retry",
              style: TextStyle(fontSize: 14,fontFamily: 'KievitOT'),
            ),
            SizedBox(height: 25,),
            Container(
              width: 120,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  print('Home');
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                          (Route<dynamic> route) => route is HomeScreen);
                },
                child:
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Home",
                    style: TextStyle(
                        fontFamily: 'KievitOT',
                        fontSize: 20
                    ),
                  ),
                ),
                color: kSecondaryColor,
                elevation: 5,

              ),
            ),
            SizedBox(height: 25,),
            Container(
              width: 120,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  print('Retry');
                  try {
                    InternetAddress.lookup('google.com').then((result) {
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) => Information(topic: topic,)),
                                (Route<dynamic> route) => route is HomeScreen);
                      } else {
                        print('No internet');
                      }
                    }).catchError((error) {
                      print('No internet');
                    });
                  } on SocketException catch (_) {
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.refresh),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Retry",
                      style: TextStyle(
                        fontFamily: 'KievitOT',
                      ),
                    )
                  ],
                ),
                color: kSecondaryColor,
                elevation: 0,
              ),
            )


          ],),

        ),
      ),
    );
  }
}
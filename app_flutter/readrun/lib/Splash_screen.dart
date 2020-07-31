import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
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
//  _checkImageExist() async {
//    print('Heyyyyy audaiuguaf');
//    Directory directory = await getApplicationDocumentsDirectory();
//    var dbPath ='${directory.path}/attachment_img.jpg';
//    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
//      ByteData data = await rootBundle.load("assets/images/blurred-background-1.jpg");
//      List<int> bytes = data.buffer.asUint8List(
//          data.offsetInBytes, data.lengthInBytes);
//      await File(dbPath).writeAsBytes(bytes);
//      print('Its done');
//    }
//  }

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
//            Container(
//              child: Image.asset("images/logo.png"),
//            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Image.asset("assets/icons/logo_intro.png"),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1,
            )
          ],
        ),
    );
  }

}
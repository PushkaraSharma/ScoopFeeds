import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:readrun/views/server_down.dart';

class FetchingNews extends StatefulWidget {

  @override
  _FetchingNewsState createState() => _FetchingNewsState();
}

class _FetchingNewsState extends State<FetchingNews> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Future.delayed(const Duration(seconds: 10), () {
      if(mounted){
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Server_Down()),
          );
        });}
    });
    return Scaffold(backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(color: Colors.white,
            height: height*0.4,width: width*0.6,
              child: Column(children: <Widget>[
              Image(image: AssetImage('assets/images/dribble-guy-cloud-800x600.gif'),
                ),
              SizedBox(height: 15,),
              AutoSizeText("Fetching Fresh News",style: TextStyle(fontSize: 20,fontFamily: 'KievitOT'),)
          ],),

        ),
      ),
    );
  }
}

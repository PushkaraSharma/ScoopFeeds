import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:readrun/constants.dart';
import 'HomeScreen.dart';

class Server_Down extends StatefulWidget {

  @override
  _Server_DownState createState() => _Server_DownState();
}

class _Server_DownState extends State<Server_Down> {


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
            Image(image: AssetImage('assets/images/undraw_server_down_s4lk.png'),
            ),
            SizedBox(height: 20,),
            AutoSizeText("Server Down!",style: TextStyle(fontSize: 20,fontFamily: 'KievitOT'),),
            SizedBox(height: 15,),
            AutoSizeText("Server is down for maintenance, Retry later",
//              style: TextStyle(fontSize: 15,color:Colors.black54,fontFamily: 'KievitOT'),
            style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20,),
            Container(
              width: 160,
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
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Home",
                    style: TextStyle(
                        fontFamily: 'KievitOT',
                        fontSize: 25
                    ),
                  ),
                ),
                color: kSecondaryColor,
                elevation: 5,

              ),
            )

          ],),

        ),
      ),
    );
  }
}
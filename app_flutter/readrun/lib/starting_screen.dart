import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:readrun/information.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        body:  Column(
          children: <Widget>[
            Container(padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              height: height*0.35,width:width,
              decoration: BoxDecoration(
                color: Color(0xffFF9D63),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(160),bottomRight: Radius.circular(160)),
                  boxShadow: [BoxShadow(
                    color: Colors.black,
                    blurRadius: 12.0, spreadRadius: 4.0,
                    offset: Offset(0.0, 3.0,),
                  ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('WEE',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 40.0,color: Colors.black,)),),

                  Image(image: AssetImage('assets/images/1.gif'),width: 100,height: 220,
                      fit: BoxFit.fitHeight,
                    ),
                  Text('READ',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 40.0,color: Colors.black,))),

                ],
              ),
            ),
            Container(padding: EdgeInsets.all(15),alignment: Alignment.centerLeft,
            child: Text("Choose Categories",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 25.0,color: Colors.black,)),
              )),
            Expanded(
              child: StaggeredGridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      children: <Widget>[
                        myitems('Top Stories','assets/images/undraw_newspaper_k72w.png',Information(topic:"top_stories")),
                        myitems('Sports','assets/images/undraw_track_and_field_33qn.png' ,Information(topic:"sports")),
                        myitems('Technology','assets/images/undraw_visionary_technology_33jy.png',Information(topic:"tech")),
                        myitems('Gaming','assets/images/undraw_gaming_6oy3.png',Information(topic: "gaming",)),
                        myitems('Fashion','assets/images/undraw_newspaper_k72w.png', Information(topic: "gaming",)),
                        myitems('Automobile', 'assets/images/undraw_city_driver_jh2h.png',Information(topic: "gaming",)),
                        myitems('International','assets/images/undraw_around_the_world_v9nu.png', Information(topic: "gaming",)),
                        myitems('Lifestyle','assets/images/undraw_healthy_habit_bh5w.png', Information(topic: "gaming",)),
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                        StaggeredTile.extent(1, 160),
                      ],
                    ),
            ),
          ],
        ),
        ),
        
      );
  }


  Material myitems(String heading,String pic,function) {
    return Material(
        color: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.redAccent,
        borderRadius: BorderRadius.circular(20.0),
        child: InkResponse(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>function));
          },
          radius: 10.0,
          containedInkWell: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    child: new Image(image: AssetImage(pic),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Text(heading,style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15.0,color: Colors.black,))),
                  )
                ],
              ),
            ),
          ),
        ));
  }

}


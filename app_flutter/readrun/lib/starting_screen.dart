import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:readrun/information.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return  StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: <Widget>[
                  myitems(Icons.home, 'Top Stories', 0xffed622b,Information(topic:"top_stories")),
                  myitems(Icons.accessibility, 'Sports', 0xff26cb3c,Information(topic:"sports")),
                  myitems(Icons.home, 'Tech', 0xffff3266,Information(topic:"tech")),
                  myitems(Icons.home, 'Gaming', 0xff3399fe,Information(topic: "gaming",)),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(tilecol(), randnumber()),
                  StaggeredTile.extent(tilecol(), randnumber()),
                  StaggeredTile.extent(tilecol(), randnumber()),
                  StaggeredTile.extent(1, randnumber()),
                ],
              );





  }

  Material myitems(IconData, String heading, int color,function) {
    return Material(
        color: Colors.white,
        elevation: 15.0,
        shadowColor: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20.0),
        child: InkResponse(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>function));
          },
          highlightColor: new Color(color).withOpacity(0.3),
          splashColor: new Color(color).withOpacity(0.3),
          radius: 40.0,
          containedInkWell: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: new Color(color),
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: new Color(color),
                        borderRadius: BorderRadius.circular(20.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            IconData,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  double randnumber() {
    int min = 120;
    int max = 230;
    int selec = min + (Random().nextInt(max - min));
    double sele = selec + 0.1;
    return sele;
  }

  int tilecol() {
    return 1 + Random().nextInt(2);
  }


}


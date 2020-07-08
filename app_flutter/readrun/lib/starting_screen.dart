import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:readrun/information.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  _buildCard({Config config, Color backgroundColor = Colors.transparent}) {
    return Container(
      color: Colors.transparent,
      height: 60,
      width: double.infinity,
      child: WaveWidget(
        config: config,
        backgroundColor: backgroundColor,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 6,
      ),
    );
  }

  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  int _blurIndex = 3;

  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex];
    return _blurs[_blurIndex];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    _nextBlur();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              //height: height*0.3,width:width,
              color: Color(0xffFFBD95),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Text('WEE',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 40.0,color: Colors.black,)),),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ColorizeAnimatedTextKit(
                            repeatForever: true,
                            text: ["SCOOP", 'SHORT'],
                            speed: Duration(milliseconds: 1200),
                            textStyle: TextStyle(
                                fontSize: 44.0,
                                fontFamily: 'CharterITC',
                                fontWeight: FontWeight.bold),
                            colors: [
                              Colors.black,
                              Colors.white,
                              Colors.black,
                              Colors.white,
                            ],
                            textAlign: TextAlign.start,
                            alignment: AlignmentDirectional
                                .topStart // or Alignment.topLeft
                            ),
                      ),
                      Image(
                        image: AssetImage('assets/images/1.gif'),
                        width: 80,
                        height: 160,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ColorizeAnimatedTextKit(
                            repeatForever: true,
                            speed: Duration(milliseconds: 1200),
                            text: ["FEEDS", "READS"],
                            textStyle: TextStyle(
                                fontSize: 44.0,
                                fontFamily: 'CharterITC',
                                fontWeight: FontWeight.bold),
                            colors: [
                              Colors.black,
                              Colors.white,
                              Colors.black,
                              Colors.white,
                            ],
                            textAlign: TextAlign.start,
                            alignment: AlignmentDirectional
                                .topStart // or Alignment.topLeft
                            ),
                      ),
                    ],
                  ),
                  _buildCard(
                    config: CustomConfig(
                      colors: [
                        Colors.grey[600],
                        Colors.grey[300],
                        Color(0xffFFDDC8),
                        Colors.white
                      ],
                      durations: [35000, 19440, 10800, 10000],
                      heightPercentages: [0.20, 0.23, 0.30, 0.60],
                      blur: _blur,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 20,
                left: 0.0,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.settings,
                      color:  Colors.black,
                      size: 27.0),
                )
            ),
          ]),
          Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Text(
                "Choose Category",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontFamily: 'KievitOT'),
              )),
          Expanded(
            child: StaggeredGridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              children: <Widget>[
                myitems(
                    'Top Stories',
                    'assets/images/undraw_newspaper_k72w.png',
                    Information(topic: "top_stories")),
                myitems(
                    'Sports',
                    'assets/images/undraw_track_and_field_33qn.png',
                    Information(topic: "sports")),
                myitems(
                    'Technology',
                    'assets/images/undraw_visionary_technology_33jy.png',
                    Information(topic: "tech")),
                myitems(
                    'Gaming',
                    'assets/images/undraw_gaming_6oy3.png',
                    Information(
                      topic: "gaming",
                    )),
                myitems(
                    'Fashion',
                    'assets/images/fashion_pic.png',
                    Information(
                      topic: "gaming",
                    )),
                myitems(
                    'Automobile',
                    'assets/images/undraw_city_driver_jh2h.png',
                    Information(
                      topic: "gaming",
                    )),
                myitems(
                    'International',
                    'assets/images/undraw_around_the_world_v9nu.png',
                    Information(
                      topic: "gaming",
                    )),
                myitems(
                    'Lifestyle',
                    'assets/images/undraw_healthy_habit_bh5w.png',
                    Information(
                      topic: "gaming",
                    )),
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
    );
  }

  Material myitems(String heading, String pic, function) {
    return Material(
        color: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.redAccent,
        borderRadius: BorderRadius.circular(20.0),
        child: InkResponse(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => function));
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
                    child: new Image(
                      image: AssetImage(pic),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Text(heading,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ))),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

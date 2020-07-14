import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:readrun/Widgets/waveclip.dart';
import 'package:readrun/views/no_internet.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:readrun/views/information.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  FSBStatus drawerStatus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SwipeDetector(
          onSwipeRight: () {
            setState(() {
              drawerStatus = FSBStatus.FSB_OPEN;
            });
          },
          onSwipeLeft: () {
            setState(() {
              drawerStatus = FSBStatus.FSB_CLOSE;
            });
          },
          child: FoldableSidebarBuilder(
            drawerBackgroundColor: Color(0xffFFBD95),
            drawer: CustomDrawer(
              closeDrawer: () {
                setState(() {
                  drawerStatus = FSBStatus.FSB_CLOSE;
                });
              },
            ),
            screenContents: HomePage(),
            status: drawerStatus,
          ),
        ),
//        floatingActionButton: FloatingActionButton(
//          mini: true,
//            backgroundColor: Color(0xffFFBD95),
//            child: floatButtonType?Icon(Icons.menu, color: Colors.white,):Icon(Icons.close, color: Colors.white,),
//            onPressed: () {
//              setState(() {
//                floatButtonType = true;
//                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
//                    ? FSBStatus.FSB_CLOSE
//                    : FSBStatus.FSB_OPEN;
//              });
//
//            }),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  int _blurIndex = 0;

  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 1;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[4];
    return _blurs[4];
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
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
//            Positioned(
//                top: 20,
//                left: 0.0,
//
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Icon(Icons.settings,
//                      color:  Colors.black,
//                      size: 27.0),
//                )
//            ),
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
                myitems('Top Stories',
                    'assets/images/undraw_newspaper_k72w.png', "top_stories"),
                myitems('Sports',
                    'assets/images/undraw_track_and_field_33qn.png', "sports"),
                myitems(
                    'Technology',
                    'assets/images/undraw_visionary_technology_33jy.png',
                    "tech"),
                myitems(
                  'Gaming',
                  'assets/images/undraw_gaming_6oy3.png',
                  "gaming",
                ),
                myitems(
                  'Fashion',
                  'assets/images/fashion_pic.png',
                  "gaming",
                ),
                myitems(
                  'Automobile',
                  'assets/images/undraw_city_driver_jh2h.png',
                  "gaming",
                ),
                myitems(
                  'International',
                  'assets/images/undraw_around_the_world_v9nu.png',
                  "gaming",
                ),
                myitems(
                  'Lifestyle',
                  'assets/images/undraw_healthy_habit_bh5w.png',
                  "gaming",
                ),
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

  Material myitems(String heading, String pic, String topic) {
    return Material(
        color: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.redAccent,
        borderRadius: BorderRadius.circular(20.0),
        child: InkResponse(
          onTap: () {
            try {
              InternetAddress.lookup('google.com').then((result) {
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Information(topic: topic)),
                      (Route<dynamic> route) => route is StartScreen);
                } else {
                  print('No internet');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => No_internet(topic: topic)),
                  );
                }
              }).catchError((error) {
                print('No internet');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => No_internet(topic: topic)),
                );
              });
            } on SocketException catch (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => No_internet(topic: topic)),
              );
            }
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

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      //color: Color(0xffFFDDC8),
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              color: Color(0xffeee7eb),
              height: mediaQuery.size.height * 0.22,
              width: mediaQuery.size.width * 0.60,
              child: Image(
                image: AssetImage('assets/images/4.gif'),
                fit: BoxFit.fill,
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 100,
                width: mediaQuery.size.width * 0.60,
                color: Color(0xffeee7eb),
                child: AutoSizeText(
                  'Read all new feeds in short',
                  style: TextStyle(
                      fontFamily: 'KievitOT',
                      fontSize: 16,
                      color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Profile");
              },
              leading: Icon(Icons.person),
              title: Text(
                "Your Profile",
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped settings");
              },
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Payments");
              },
              leading: Icon(Icons.payment),
              title: Text("Payments"),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Notifications");
              },
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Log Out");
              },
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out"),
            ),
          ],
        ),
        Positioned(
            bottom: mediaQuery.size.height * 0.745,
            child: Container(
              color: Color(0xffeee7eb),
              width: mediaQuery.size.width * 0.60,
              height: 5,
            )),
      ]),
    );
  }
}

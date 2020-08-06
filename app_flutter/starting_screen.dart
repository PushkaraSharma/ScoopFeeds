//import 'dart:io';
//
//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
//import 'package:flutter/widgets.dart';
//import 'package:readrun/Widgets/waveclip.dart';
//import 'package:readrun/views/no_internet.dart';
//
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:readrun/views/information.dart';
//import 'package:google_fonts/google_fonts.dart';
//
//class StartScreen extends StatefulWidget {
//  @override
//  _StartScreenState createState() => _StartScreenState();
//}
//
//class _StartScreenState extends State<StartScreen> {
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//
//  _buildCard({Config config, Color backgroundColor = Colors.transparent}) {
//    return Container(
//      color: Colors.transparent,
//      height: 60,
//      width: double.infinity,
//      child: WaveWidget(
//        config: config,
//        backgroundColor: backgroundColor,
//        size: Size(double.infinity, double.infinity),
//        waveAmplitude: 6,
//      ),
//    );
//  }
//
//  MaskFilter _blur;
//  final List<MaskFilter> _blurs = [
//    null,
//    MaskFilter.blur(BlurStyle.normal, 10.0),
//    MaskFilter.blur(BlurStyle.inner, 10.0),
//    MaskFilter.blur(BlurStyle.outer, 10.0),
//    MaskFilter.blur(BlurStyle.solid, 16.0),
//  ];
//  int _blurIndex = 0;
//
//  MaskFilter _nextBlur() {
//    if (_blurIndex == _blurs.length - 1) {
//      _blurIndex = 1;
//    } else {
//      _blurIndex = _blurIndex + 1;
//    }
//    _blur = _blurs[4];
//    return _blurs[4];
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final width = MediaQuery.of(context).size.width;
//    final height = MediaQuery.of(context).size.height;
//    _nextBlur();
//    return Scaffold(
//      key: scaffoldKey,
//      drawer: _Drawer(context),
//      backgroundColor: Colors.white,
//      body: SafeArea(
//        child: Column(
//          children: <Widget>[
//            Stack(children: <Widget>[
//              Container(
//                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                //height: height*0.3,width:width,
//                color: Color(0xffeee7eb),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        //Text('WEE',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 40.0,color: Colors.black,)),),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 20),
//                          child: ColorizeAnimatedTextKit(
//                              repeatForever: true,
//                              text: ["SCOOP", 'SHORT'],
//                              speed: Duration(milliseconds: 1200),
//                              textStyle: TextStyle(
//                                  fontSize: 44.0,
//                                  fontFamily: 'CharterITC',
//                                  fontWeight: FontWeight.bold),
//                              colors: [
//                                Colors.black,
//                                Colors.white,
//                                Colors.black,
//                                Colors.white,
//                              ],
//                              textAlign: TextAlign.start,
//                              alignment: AlignmentDirectional
//                                  .topStart // or Alignment.topLeft
//                              ),
//                        ),
//                        Image(
//                          image: AssetImage('assets/images/1.gif'),
//                          width: 80,
//                          height: 160,
//                          fit: BoxFit.fitHeight,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 20),
//                          child: ColorizeAnimatedTextKit(
//                              repeatForever: true,
//                              speed: Duration(milliseconds: 1200),
//                              text: ["FEEDS", "READS"],
//                              textStyle: TextStyle(
//                                  fontSize: 44.0,
//                                  fontFamily: 'CharterITC',
//                                  fontWeight: FontWeight.bold),
//                              colors: [
//                                Colors.black,
//                                Colors.white,
//                                Colors.black,
//                                Colors.white,
//                              ],
//                              textAlign: TextAlign.start,
//                              alignment: AlignmentDirectional
//                                  .topStart // or Alignment.topLeft
//                              ),
//                        ),
//                      ],
//                    ),
//                    _buildCard(
//                      config: CustomConfig(
//                        colors: [
//                          Colors.grey[600],
//                          Colors.purple[100],
//                          Color(0xffeee7eb),
//                          Colors.white
//                        ],
//                        durations: [35000, 19440, 10800, 10000],
//                        heightPercentages: [0.20, 0.23, 0.30, 0.60],
//                        blur: _blur,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Positioned(
//                left: -5,
//                top: 0,
//                child: IconButton(
//                  iconSize: 25,
//                  icon: Icon(Icons.menu),
//                  onPressed: () => scaffoldKey.currentState.openDrawer(),
//                ),
//              ),
//            ]),
//            Container(
//                padding: EdgeInsets.all(15),
//                alignment: Alignment.centerLeft,
//                color: Colors.white,
//                child: Text(
//                  "Category",
//                  style: TextStyle(
//                      fontSize: 25.0,
//                      color: Colors.black,
//                      fontFamily: 'KievitOT'),
//                )),
//            Expanded(
//              child: StaggeredGridView.count(
//                crossAxisCount: 3,
//                crossAxisSpacing: 15.0,
//                mainAxisSpacing: 15.0,
//                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
//                children: <Widget>[
//                  myitems('Top Stories',
//                      'assets/images/undraw_newspaper_k72w.png', "top_stories"),
//                  myitems(
//                      'Sports',
//                      'assets/images/undraw_track_and_field_33qn.png',
//                      "sports"),
//                  myitems(
//                      'Technology',
//                      'assets/images/undraw_visionary_technology_33jy.png',
//                      "tech"),
//                  myitems(
//                    'Gaming',
//                    'assets/images/undraw_gaming_6oy3.png',
//                    "gaming",
//                  ),
//                  myitems(
//                    'Fashion',
//                    'assets/images/fashion_pic.png',
//                    "gaming",
//                  ),
//                  myitems(
//                    'Automobile',
//                    'assets/images/undraw_city_driver_jh2h.png',
//                    "gaming",
//                  ),
//                  myitems(
//                    'International',
//                    'assets/images/undraw_around_the_world_v9nu.png',
//                    "gaming",
//                  ),
//                  myitems(
//                    'Lifestyle',
//                    'assets/images/undraw_healthy_habit_bh5w.png',
//                    "gaming",
//                  ),
//                ],
//                staggeredTiles: [
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                  StaggeredTile.extent(1, 160),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Material myitems(String heading, String pic, String topic) {
//    return Material(
//        color: Colors.white,
//        elevation: 8.0,
//        shadowColor: Colors.purpleAccent,
//        borderRadius: BorderRadius.circular(20.0),
//        child: InkResponse(
//          onTap: () {
//            try {
//              InternetAddress.lookup('google.com').then((result) {
//                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                  Navigator.pushAndRemoveUntil(
//                      context,
//                      MaterialPageRoute(
//                          builder: (BuildContext context) =>
//                              Information(topic: topic)),
//                      (Route<dynamic> route) => route is StartScreen);
//                } else {
//                  print('No internet');
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => No_internet(topic: topic)),
//                  );
//                }
//              }).catchError((error) {
//                print('No internet');
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => No_internet(topic: topic)),
//                );
//              });
//            } on SocketException catch (_) {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => No_internet(topic: topic)),
//              );
//            }
//          },
//          radius: 10.0,
//          containedInkWell: false,
//          child: Center(
//            child: Padding(
//              padding: EdgeInsets.all(1.0),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  ClipRRect(
//                    child: new Image(
//                      image: AssetImage(pic),
//                      fit: BoxFit.fill,
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
//                    child: Text(heading,
//                        style: GoogleFonts.roboto(
//                            textStyle: TextStyle(
//                          fontSize: 15.0,
//                          color: Colors.black,
//                        ))),
//                  )
//                ],
//              ),
//            ),
//          ),
//        ));
//  }
//}
//
//Widget _Drawer(context) {
//  bool status1 = false;
//  final width = MediaQuery.of(context).size.width;
//  final height = MediaQuery.of(context).size.height;
//  return SafeArea(
//      child: Container(
//    //color: Color(0xffFFDDC8),
//    color: Colors.white,
//    width: width * 0.70,
//    height: height,
//    child: Stack(children: <Widget>[
//      Column(
//        children: <Widget>[
//          Container(
//            color: Color(0xffeee7eb),
//            height: height * 0.22,
//            width: width * 0.70,
//            child: Image(
//              image: AssetImage('assets/images/4.gif'),
//              fit: BoxFit.fill,
//            ),
//          ),
//          ClipPath(
//            clipper: WaveClipper(),
//            child: Container(
//              height: 100,
//              width: width * 0.70,
//              color: Color(0xffeee7eb),
//              child: AutoSizeText(
//                'Read all new feeds in short',
//                style: TextStyle(
//                    fontFamily: 'KievitOT',
//                    fontSize: 16,
//                    color: Colors.black54),
//                textAlign: TextAlign.center,
//              ),
//            ),
//          ),
//          ListTile(
//            onTap: () {
//              debugPrint("Tapped Profile");
//            },
//            leading: Icon(Icons.notifications_active,color: Color(0xffFFBD95),),
//            title: Text(
//              "Notifications",
//            ),
////            trailing: FlutterSwitch(
////              activeColor: Color(0xffeee7eb),
////             // inactiveColor: Colors.red,
////              toggleColor: Color(0xffFFBD95),
////              width: 70.0,
////              height: 30.0,
////              valueFontSize: 15.0,
////              toggleSize: 35.0,
////              value: status1,
////              borderRadius: 20.0,
////              padding: 0.0,
////              showOnOff: true,
//////              onToggle: (val) {
//////                setState(() {
//////                  status1 = true;
//////                });
//////              },
////            ),
//          ),
//          Divider(
//            height: 1,
//            color: Colors.grey,
//          ),
//          ListTile(
//            onTap: () {
//              debugPrint("Tapped settings");
//            },
//            leading: Icon(Icons.settings),
//            title: Text("Settings"),
//          ),
//          Divider(
//            height: 1,
//            color: Colors.grey,
//          ),
//          ListTile(
//            onTap: () {
//              debugPrint("Tapped Payments");
//            },
//            leading: Icon(Icons.payment),
//            title: Text("Payments"),
//          ),
//          Divider(
//            height: 1,
//            color: Colors.grey,
//          ),
//          ListTile(
//            onTap: () {
//              debugPrint("Tapped Notifications");
//            },
//            leading: Icon(Icons.notifications),
//            title: Text("Notifications"),
//          ),
//          Divider(
//            height: 1,
//            color: Colors.grey,
//          ),
//          ListTile(
//            onTap: () {
//              debugPrint("Tapped Log Out");
//            },
//            leading: Icon(Icons.exit_to_app),
//            title: Text("Log Out"),
//          ),
//        ],
//      ),
//      Positioned(
//          bottom: height * 0.745,
//          child: Container(
//            color: Color(0xffeee7eb),
//            width: width * 0.70,
//            height: 5,
//          )),
//    ]),
//  ));
//}

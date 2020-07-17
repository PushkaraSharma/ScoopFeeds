import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/Widgets/waveclip.dart';
import 'package:readrun/model/News.dart';
import 'package:readrun/Widgets/Fetching_news_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readrun/views/server_down.dart';
import 'package:readrun/views/starting_screen.dart';

import 'no_internet.dart';

class Information extends StatefulWidget {
  final String topic;

  Information({Key key, @required this.topic}) : super(key: key);

  @override
  _InformationState createState() => _InformationState(topic: this.topic);
}

class _InformationState extends State<Information> {
  String topic;

  _InformationState({this.topic});

  final PageController ctrl = PageController();
  int currentPage = 1;

  List<News> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("http://35.209.249.233:5000/" + topic + "/");
    print(response);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new News.fromJson(data))
          .toList();
      print(list[0].heading);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load News');
    }
  }

  @override
  void initState() {
    _fetchData();
    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();
      print(next);

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(list.isEmpty);
    return list.isEmpty
        ? FetchingNews()
        : PageView(reverse: true, pageSnapping: true, children: <Widget>[
            PageView.builder(
                controller: ctrl,
                physics: BouncingScrollPhysics(),
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, int currentIdx) {
                  if (currentIdx == list.length - 1) {
                    print("all over");
                    return _buildEndPage();
                    ;
                  } else if (list.length >= currentIdx) {
                    // Active page
                    bool active = currentIdx == currentPage;
                    return _buildStoryPage(list[currentIdx], active);
                  }
                }),
            StartScreen()
          ]);

  }

  // Builder Functions
  _buildStoryPage(News data, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInCirc,
      //margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      color: Colors.white,
      child: Stack(children: <Widget>[
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25))),
                builder: (BuildContext context) {
                  return Container(
                    height: 100,
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                                 IconButton(
                                      onPressed: () {print('Share');},
                                      icon: Icon(
                                        Icons.share,
                                        color: Color(0xffFFBD95),size: 30,
                                      ),
                                    ),
                            AutoSizeText('Share',
                                style: TextStyle(
                                    fontFamily: 'KievitOT',
                                    fontWeight: FontWeight.w300))
                          ],
                        ),
                        SizedBox(width: 50,),
                        Column(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                print('Refresh');
                                Navigator.pop(context);
                                onRefresh(1);

                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Color(0xffFFBD95),size: 30,
                              ),
                            ),
                            AutoSizeText('Refresh',
                                style: TextStyle(
                                    fontFamily: 'KievitOT',
                                    fontWeight: FontWeight.w300))
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.5,
                width: width,
                child: ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(data.picUrl)),
                    ),
                  ),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(12.0, 18.0, 12.0, 10.0),
                child: new Text(
                  data.heading,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                      fontFamily: 'CharterITC'),
                ),
              ),
              new Padding(
                  padding: new EdgeInsets.fromLTRB(18, 18, 18, 5),
                  child: new AutoSizeText(
                    data.summary,
                    textAlign: TextAlign.justify,
                    maxLines: 9,
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                        fontFamily: 'KievitOT',
                        fontWeight: FontWeight.w300),
                  ))
            ],
          ),
        ),
      ]),
    );
  }

  _buildEndPage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("assets/images/2.gif"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "You have read all Stories",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: 'KievitOT',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              width: 140,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  onRefresh(2);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.refresh),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Refresh",
                      style: TextStyle(
                        fontFamily: 'KievitOT',
                      ),
                    )
                  ],
                ),
                color: Colors.white,
                elevation: 5,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onRefresh(int sec) {
    ctrl.animateToPage(0,duration: Duration(seconds:sec),curve: Curves.easeIn);
    _fetchData();
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

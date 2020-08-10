import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/model/constants.dart';
import 'package:readrun/model/News.dart';
import 'package:readrun/Widgets/Fetching_news_widget.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:screenshot/screenshot.dart';
import '../secrets.dart';
import 'HomeScreen.dart';

class Information extends StatefulWidget {
  final String topic;

  Information({Key key, @required this.topic}) : super(key: key);

  @override
  _InformationState createState() => _InformationState(topic: this.topic);
}

class _InformationState extends State<Information> {
  String topic;

  _InformationState({this.topic});

  ScreenshotController screenshotController = ScreenshotController();
  File _imageFile;
  final PageController ctrl = PageController();
  int currentPage = 1;

  List<News> list = List();
  var isLoading = false;
  var show_temp_images = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(api_key + topic + "/");
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
    super.initState();
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

  void _changed() {
    if (show_temp_images) {
      setState(() {
        show_temp_images = !show_temp_images;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          show_temp_images = !show_temp_images;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(list.isEmpty);
    return list.isEmpty
        ? FetchingNews()
        : Screenshot(
            controller: screenshotController,
            child:
                PageView(reverse: true, pageSnapping: true, children: <Widget>[
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
              HomeScreen()
            ]),
          );
  }

  // Builder Functions
  _buildStoryPage(News data, bool active) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(height);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => route is HomeScreen);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInCirc,
        //margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(children: <Widget>[
          GestureDetector(
            onTap: () {
              _changed();
              showModalBottomSheet<void>(
                  context: context,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25))),
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
                                onPressed: () {
                                  print('Share');
                                  _takeScreenshotandShare();
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: kSecondaryColor,
                                  size: 30,
                                ),
                              ),
                              AutoSizeText('Share',
                                  style: TextStyle(
                                      fontFamily: 'KievitOT',
                                      fontWeight: FontWeight.w300))
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
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
                                  color: kSecondaryColor,
                                  size: 30,
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
                  }).whenComplete(() => _changed());
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: height * 0.45,
                  width: width,
                  child: ClipPath(
                    clipper: ClippingClass(),
                    child: Container(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: data.picUrl,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/new_image_placeholder.png',
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(12.0, 18.0, 12.0, 10.0),
                  child: new AutoSizeText(
                    data.heading,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(18, 18, 18, 5),
                    child: new AutoSizeText(
                      data.summary,
                      maxLines: 10,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Spacer(),
                Visibility(
                  visible: show_temp_images,
                  child: Container(
                      width: width,
                      height: height * 0.12,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/google_play.png',
                            ),
                            Container(
                              child:
                                  Image.asset('assets/icons/screenShot2.png'),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _buildEndPage() {
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/images/no_more.png",
                height: height * 0.3,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "You have read all Stories",
              style: Theme.of(context).textTheme.bodyText2,
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
                elevation: 5,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onRefresh(int sec) {
    ctrl.animateToPage(0,
        duration: Duration(seconds: sec), curve: Curves.easeIn);
    _fetchData();
  }

  _takeScreenshotandShare() async {
    _imageFile = null;
    print(_imageFile);
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });

      final directory = (await getApplicationDocumentsDirectory()).path;
      print(directory);
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      await Share.file(
          'Scoop Feeds Shared News', 'screenshot.png', pngBytes, 'image/png',
          text:
              'Read AI powered crisp and short summaries of latest news on Scoop Feeds.'
              ' Download Now!!');
    }).catchError((onError) {
      print(onError);
    });
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

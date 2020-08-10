import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:readrun/constants.dart';
import 'package:readrun/views/information.dart';
import 'package:readrun/views/no_internet.dart';
import 'package:readrun/views/HomeScreen.dart';
import 'headerWithLatestNews.dart';
import 'title_with_moreBtn.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
//    print(size.height);
    // it enable scrolling on small device
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderWithLatestNews(size: size),
        TitleWithMoreBtn(title: "Categories  ", press: () {}),
        Expanded(
          child: StaggeredGridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
            children: <Widget>[
              myitems('Corona', 'assets/images/undraw_medical_care_movn.png',
                  "corona"),
              myitems('Technology', 'assets/images/undraw_programmer_imem.png',
                  "tech"),
              myitems('Sports', 'assets/images/undraw_track_and_field_33qn.png',
                  "sports"),
              myitems('Trending', 'assets/images/undraw_trends_a5mf.png',
                  "trending"),
              myitems(
                'Gaming',
                'assets/images/undraw_gaming_6oy3.png',
                "gaming",
              ),
              myitems(
                'Fashion',
                'assets/images/undraw_fashion_photoshoot_mtq8.png',
                "fashion",
              ),
              myitems(
                'Education',
                'assets/images/undraw_Graduation_ktn0.png',
                "education",
              ),
              myitems(
                'Automobile',
                'assets/images/undraw_city_driver_jh2h.png',
                "automobile",
              ),
              myitems(
                'International',
                'assets/images/undraw_around_the_world_v9nu.png',
                "world",
              ),
              myitems(
                'Business',
                'assets/images/undraw_business_deal_cpi9.png',
                "business",
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
              StaggeredTile.extent(1, size.height * 0.17),
            ],
          ),
        ),
      ],
    );
  }

  Material myitems(String heading, String pic, String topic) {
    Size size = MediaQuery.of(context).size;
    return Material(
//        color: Colors.white,
        elevation: 4.0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(width: 1, color: kPrimaryColor),
          ),
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
                        (Route<dynamic> route) => route is HomeScreen);
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
            //radius: 10.0,
            containedInkWell: true,
            child: Center(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        child: new Image(
                          image: AssetImage(pic),
                          fit: BoxFit.cover,
                          height: size.height*0.12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: AutoSizeText(heading,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15.0, fontFamily: 'KievitOT')),
                      )
                    ],
                  )),
            ),
          ),
        ));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readrun/constants.dart';
import 'package:readrun/views/information.dart';
import 'package:readrun/views/no_internet.dart';

import '../HomeScreen.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            children: <Widget>[
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
                'assets/images/undraw_fashion_photoshoot_mtq8.png',
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
            ],
          ),
        ),
      ],
    );
  }

  Material myitems(String heading, String pic, String topic) {
    return Material(
        color: Colors.white,
        elevation: 6.0,
        shadowColor: Colors.black,
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
                    child: Text(heading, style: TextStyle(fontSize: 15.0, color: kTextColor,fontFamily: 'KievitOT')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

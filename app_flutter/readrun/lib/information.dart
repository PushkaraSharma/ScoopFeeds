import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/News.dart';
import 'package:readrun/Fetching_news_widget.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'dart:io';
//import 'dart:async';

class Information extends StatefulWidget {
  final String topic;

  Information({Key key, @required this.topic}) :super(key: key);

  @override
  _InformationState createState() => _InformationState(topic:this.topic);
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
    final response = await http.get("http://35.209.249.233:5000/"+topic+"/");
    print(response);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List).map((data) => new News.fromJson(data)).toList();
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

      if(currentPage != next) {
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
        : PageView.builder(

        controller: ctrl,
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == list.length-1) {
            print("all over");
            return _buildEndPage(); ;
          } else if (list.length >= currentIdx) {
            // Active page
            bool active = currentIdx == currentPage;
            return _buildStoryPage(list[currentIdx ], active);
          }
        }
    );
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
        duration: Duration(milliseconds: 800),
        curve: Curves.bounceInOut,
        //margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Container(
            height: height*0.5,width:width,
              child: ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(data.picUrl)),
                  ),
                ),
              ),),
          new Padding(
            padding: new EdgeInsets.fromLTRB(12.0,18.0,12.0,10.0),
            child: new Text(
              data.heading,textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.w700,decoration: TextDecoration.none,fontFamily: 'CharterITC'),
            ),
          ),
          new Padding(
              padding: new EdgeInsets.fromLTRB(18,18,18,5),
              child: new AutoSizeText(
                data.summary,textAlign: TextAlign.justify,
                maxLines: 9,
                style: TextStyle(fontSize: 17.0,color: Colors.black,decoration: TextDecoration.none,fontFamily: 'KievitOT',fontWeight: FontWeight.w300),
              ))
        ],
      ),
    );
  }
  _buildEndPage(){
    return Container(color: Colors.white,
      child: Center(child:
        Text("No More News"),),
    );
  }

}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height-40);
    path.quadraticBezierTo(size.width / 4, size.height,
        size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

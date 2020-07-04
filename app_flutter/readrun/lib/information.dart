import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/News.dart';
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


    return PageView.builder(

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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
                boxShadow: [BoxShadow(
                    color: Colors.black.withAlpha(90),
                    blurRadius: 12.0, spreadRadius: 4.0,
                    offset: Offset(0.0, 3.0,),
                  ),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80.0)),
              child: new Image.network(
                data.picUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(12.0,18.0,12.0,10.0),
            child: new Text(
              data.heading,textAlign: TextAlign.justify,
              style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.w700,decoration: TextDecoration.none,)),
            ),
          ),
          new Padding(
              padding: new EdgeInsets.fromLTRB(18,18,18,5),
              child: new Text(
                data.summary,textAlign: TextAlign.justify,
                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 17.0,color: Colors.black,decoration: TextDecoration.none,fontWeight: FontWeight.w300)),
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


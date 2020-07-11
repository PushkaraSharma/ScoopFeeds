import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/model/News.dart';

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  final PageController ctrl = PageController(viewportFraction: 0.95);
  String activeTag = 'top_stories';
  int currentPage = 0;

  List<News> list = List();
  var isLoading = false;

  _fetchData({ String tag ='top_stories' }) async {
    setState(() {
      isLoading = true;
      activeTag = tag;
    });

    final response = await http.get("http://34.72.182.102:5000/"+activeTag+"/");
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
    _fetchData(tag:activeTag);
    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

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
        itemCount: list.length + 1,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == 0) {
            return _buildTagPage();
          } else if (list.length >= currentIdx) {
            // Active page
            bool active = currentIdx == currentPage;
            return _buildStoryPage(list[currentIdx - 1], active);
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


    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(data.picUrl),
            ),

            boxShadow: [BoxShadow(color: Colors.black87, blurRadius: blur, offset: Offset(offset, offset))]
        ),
        child: Align(alignment: Alignment.bottomCenter,
            child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                padding: EdgeInsets.all(10),
    child:Text(data.heading, style: TextStyle(fontSize: 25, color: Colors.black)))
    ));
  }


  _buildTagPage() {
    return Container(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text('READ RUN', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Colors.black),),
        Text('Your Stories', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
        Text('FILTER', style: TextStyle( color: Colors.black26 )),
        _buildButton('top_stories'),
        _buildButton('gaming'),
        _buildButton('tech'),
        _buildButton('sports')
      ],
    )
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    return FlatButton(color: color, child: Text('#$tag'), onPressed: () => _fetchData(tag: tag));
  }

}


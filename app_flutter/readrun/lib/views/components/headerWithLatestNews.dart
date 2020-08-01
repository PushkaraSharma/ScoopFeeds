import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readrun/model/News.dart';
import 'package:readrun/views/information.dart';
import 'package:readrun/views/no_internet.dart';
import 'package:readrun/views/HomeScreen.dart';
import 'package:readrun/constants.dart';
import 'package:http/http.dart' as http;


class HeaderWithLatestNews extends StatefulWidget {
  final Size size;
  HeaderWithLatestNews({Key key, @required this.size,}) : super(key: key);

  @override
  _HeaderWithLatestNewsState createState() => _HeaderWithLatestNewsState(size: this.size);
}

class _HeaderWithLatestNewsState extends State<HeaderWithLatestNews> {
  Size size;

  _HeaderWithLatestNewsState({this.size});

  List<News> list = List();
  var isLoading = false;
  String firstPicUrl='NotFound';
  _fetchData() async {
     firstPicUrl = await _read();
      setState(() {
      isLoading = true;
    });
    final response = await http.get("http://35.209.249.233:5000/" + 'top_stories' + "/");
    print(response);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new News.fromJson(data))
          .toList();
      _write(list[0].picUrl);
      setState(() {
        isLoading = false;
      });
      firstPicUrl = await _read();
    } else {
      throw Exception('Failed to load News');
    }
  }
  @override
  void initState() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 0.5),
      // It will cover 20% of our total height
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
      Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: 36 + kDefaultPadding,
      ),
      height: size.height * 0.2 - 27,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Scoop Feeds',
            style: Theme
                .of(context)
                .textTheme
                .headline5
                .copyWith(
                color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30,fontFamily: 'CharterITC'),
          ),
          Spacer(),
          Image.asset("assets/icons/inner_logo.png")
        ],
      ),
    ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 200,
                    child:ClipRRect(borderRadius: BorderRadius.circular(20.0),
                      child: firstPicUrl=='Notfound'?Image.asset("assets/images/blurred-background-1.jpg",fit: BoxFit.fill,height: 210,width: double.infinity,)
                          :CachedNetworkImage(
                        height: 210,width: double.infinity,
                        fit: BoxFit.fill,
                          imageUrl: firstPicUrl,
                          placeholder: (context, url) => Image.asset('assets/images/blurred-background-1.jpg',fit: BoxFit.fill,),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                    ),

                     ),

                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.4),
                                Colors.black.withOpacity(.2),
                              ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Latest News",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,fontFamily: 'KievitOT'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: (){
                                    try {
                                      InternetAddress.lookup('google.com')
                                          .then((result) {
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Information(
                                                              topic: 'top_stories')),
                                              (Route<dynamic> route) =>
                                                  route is HomeScreen);
                                        } else {
                                          print('No internet');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    No_internet(topic: 'top_stories')),
                                          );
                                        }
                                      }).catchError((error) {
                                        print('No internet');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  No_internet(topic: 'top_stories')),
                                        );
                                      });
                                    } on SocketException catch (_) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                No_internet(topic: 'top_stories')),
                                      );
                                    }
                                  },
                            child: Container(
                              height: 35,
                              width: 150,
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(
                                "Read Now",
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontFamily: 'KievitOT'),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ]),
    ))],
              ),
            );
//          ),
//        ],
//      ),
//    );
  }
  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/firstUrl.txt');
    await file.writeAsString(text);
  }
  Future<String> _read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      var path = '${directory.path}/firstUrl.txt';
      if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
        final File file = File(path);
        text = await file.readAsString();
      }
      else{
        text = 'NotFound';
      }
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

}
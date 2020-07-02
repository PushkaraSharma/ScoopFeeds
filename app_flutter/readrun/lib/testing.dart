import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readrun/News.dart';

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  List<News> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("http://35.226.196.3:5000/top_stories/");
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fetch Data JSON"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: new Text("Fetch Data"),
            onPressed: _fetchData,
          ),
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: new Text(list[index].heading),
                trailing: new Image.network(
                  list[index].picUrl,
                  fit: BoxFit.cover,
                  height: 40.0,
                  width: 40.0,
                ),
              );
            }));
  }
}
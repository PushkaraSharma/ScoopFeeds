import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readrun/views/components/body.dart';
import 'package:readrun/constants.dart';
import 'package:readrun/views/information.dart';
import '../Widgets/waveclip.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState(){
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    _showNotification();
  }
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Add Today's Earning"),
        content: new Text('Adding daliy earning will help to manage easy.'),
        actions: [
          FlatButton(
            child: new Text('Ok'),
            onPressed: ()  {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) =>  Information(topic: 'top_stories')),
    );
  }
  void _showNotification() async {
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Add Today's Earning",
        'Adding daliy earning will help to manage easy.',
        RepeatInterval.EveryMinute,
        platformChannelSpecifics);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(),
      drawer: _Drawer(context),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
      ),
    );
  }
}
Widget _Drawer(BuildContext context) {
  bool status1 = false;
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return SafeArea(
      child: Container(
        color: Colors.white,
        width: width * 0.70,
        height: height,
        child: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Color(0xffeee7eb),
                height: height * 0.22,
                width: width * 0.70,
                child: Image(
                  image: AssetImage('assets/images/4.gif'),
                  fit: BoxFit.fill,
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 100,
                  width: width * 0.70,
                  color: Color(0xffeee7eb),
                  child: AutoSizeText(
                    'Read all new feeds in short',
                    style: TextStyle(
                        fontFamily: 'KievitOT',
                        fontSize: 16,
                        color: kTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  debugPrint("Tapped Profile");
                },
                leading: Icon(Icons.notifications_active,color: kPrimaryColor,),
                title: Text(
                  "Notifications", style: TextStyle(
                    fontFamily: 'KievitOT'),
                ),
                trailing: Switch(
                  value: status1,
                  onChanged: (value) {
//                    setState(() {
//                      status1 = value;
//                      print(status1);
//                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  debugPrint("Tapped settings");
                },
                leading: Icon(Icons.wb_sunny,color: kPrimaryColor,),
                title: Text("Dark Mode",style: TextStyle(
                    fontFamily: 'KievitOT'),),
                trailing: Switch(
                  value: status1,
                  onChanged: (value) {
//                    setState(() {
//                      status1 = value;
//                      print(status1);
//                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 35,),
              Expanded(flex: 1,
                child: Container(
                  color:Colors.grey[200],
                  child: Column(
                    children: <Widget>[
                    ListTile(
                      onTap: () {
                        debugPrint("Share this app",);
                      },
                      title: Text("Share this app",style: TextStyle(
                          fontFamily: 'KievitOT')),
                    ),
                   SizedBox(height: 2,),
                    ListTile(
                      onTap: () {
                        debugPrint("Tapped Notifications");
                      },
                      title: Text("Rate this app",style: TextStyle(
                          fontFamily: 'KievitOT')),
                    ),
                      SizedBox(height: 2,),
                    ListTile(
                      onTap: () {
                        debugPrint("Tapped Log Out");
                      },
                      title: Text("Privacy",style: TextStyle(
                          fontFamily: 'KievitOT')),
                    ),
                      ListTile(
                        onTap: () {
                          debugPrint("Tapped Notifications");
                        },
                        title: Text("Terms & Conditions",style: TextStyle(
                            fontFamily: 'KievitOT')),
                      ),
                      SizedBox(height: 2,),
                      ListTile(
                        onTap: () {
                          debugPrint("Tapped Notifications");
                        },
                        title: Text("Feedback",style: TextStyle(
                            fontFamily: 'KievitOT')),
                      ),
                      SizedBox(height: 2,),
                  ],),
                ),
              )

            ],
          ),
          Positioned(
              bottom: height * 0.745,
              child: Container(
                color: Color(0xffeee7eb),
                width: width * 0.70,
                height: 5,
              )),
        ]),
      ));
}

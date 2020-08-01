import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readrun/views/components/body.dart';
import 'package:readrun/constants.dart';
import '../Widgets/waveclip.dart';
import '../Widgets/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(),
      drawer: SafeArea(
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
                    trailing:Consumer<ThemeNotifier>(
                      builder: (context,notifier,child) => Switch(
                          onChanged: (value){
                            notifier.toggleNotification(value);
                            print(notifier.notification);
                          },
                          value: notifier.notification
                      ),
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
                    trailing:Consumer<ThemeNotifier>(
                      builder: (context,notifier,child) => Switch(
                        onChanged: (val){
                          notifier.toggleTheme(val);
                          print(notifier.darkTheme);
                        },
                        value: notifier.darkTheme
                      ),
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
          )),
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


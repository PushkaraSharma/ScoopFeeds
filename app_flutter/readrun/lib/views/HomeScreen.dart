import 'package:auto_size_text/auto_size_text.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readrun/Widgets/policies_dialog.dart';
import 'package:readrun/views/components/body.dart';
import 'package:readrun/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';
import '../Widgets/waveclip.dart';
import '../model/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double Slidervalue = 12;

  loadSlider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Slidervalue = prefs.getDouble('slider') ?? 12;
  }

  Widget build(BuildContext context) {
    loadSlider();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/menu.svg"),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
      ),
      drawer: SingleChildScrollView(
          child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: width * 0.70,
        height: height,
        child: Stack(children: <Widget>[
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Column(
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
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'KievitOT',
                          fontSize: 16,
                          color: kTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(children: <Widget>[
                  ListTile(
                    onTap: () {
                      debugPrint("Tapped Profile");
                    },
                    leading: notifier.notification
                        ? Icon(
                            Icons.notifications_active,
                            color: notifier.darkTheme
                                ? kSecondaryColor
                                : kPrimaryColor,
                          )
                        : Icon(
                            Icons.notifications_off,
                            color: notifier.darkTheme
                                ? kSecondaryColor
                                : kPrimaryColor,
                          ),
                    title: AutoSizeText(
                      "Notifications",
                      maxLines: 1,
                      style: TextStyle(fontFamily: 'KievitOT'),
                    ),
                    trailing: Switch(
                      value: notifier.notification,
                      onChanged: (value) {
                        notifier.toggleNotification(value);
                        print(notifier.notification);
                      },
                    ),
                  ),
                  notifier.notification
                      ? Column(
                          children: <Widget>[
                            AutoSizeText(
                              'Number of Daily Notifications',
                              maxLines: 1,
                              style: TextStyle(fontSize: 10),
                            ),
                            Slider(
                              value: Slidervalue,
                              onChanged: (newrating) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  Slidervalue = newrating;
                                });
                                prefs.setDouble('slider', Slidervalue);
                              },
                              divisions: 3,
                              min: 6,
                              max: 24,
                              label: "$Slidervalue",
                            )
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        )
                ]),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {
                    debugPrint("Tapped settings");
                  },
                  leading: notifier.darkTheme
                      ? Icon(
                          FontAwesomeIcons.solidMoon,
                          color: kSecondaryColor,
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: kPrimaryColor,
                        ),
                  title: AutoSizeText(
                    "Dark Mode",
                    maxLines: 1,
                    style: TextStyle(fontFamily: 'KievitOT'),
                  ),
                  trailing: Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => Switch(
                        onChanged: (val) {
                          notifier.toggleTheme(val);
                          print(notifier.darkTheme);
                        },
                        value: notifier.darkTheme),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
//                SizedBox(
//                  height: 35,
//                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color:
                        notifier.darkTheme ? Colors.black54 : Colors.grey[200],
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        ListTile(
                          onTap: () async {
                            debugPrint("Share this app");
                            await Share.text(
                                "Share app",
                                "Check out Scoop Feeds app. This is the best AI powered news reading app I found https://play.google.com/store/apps/details?id=com.noobtech.scoopfeeds",
                                'text/plain');
                          },
                          title: AutoSizeText("Share this app",
                              maxLines: 1,
                              style: TextStyle(fontFamily: 'KievitOT')),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        //rate will appear it self
                        SizedBox(
                          height: 2,
                        ),
                        ListTile(
                          onTap: () {
                            debugPrint("Tapped Log Out");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PolicyDialog(
                                      mdFileName: 'privacy_policy.md');
                                });
                          },
                          title: AutoSizeText("Privacy Policy",
                              maxLines: 1,
                              style: TextStyle(fontFamily: 'KievitOT')),
                        ),
                        ListTile(
                          onTap: () {
                            debugPrint("Tapped Notifications");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PolicyDialog(
                                      mdFileName: 'termsAndConditions.md');
                                });
                          },
                          title: Text("Terms & Conditions",
                              style: TextStyle(fontFamily: 'KievitOT')),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        ListTile(
                          onTap: () {
                            debugPrint("Tapped Feedback");
                            Wiredash.of(context).show();
                          },
                          title: AutoSizeText("Feedback",
                              maxLines: 1,
                              style: TextStyle(fontFamily: 'KievitOT')),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: height * 0.775,
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
      backgroundColor: Colors.black,
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

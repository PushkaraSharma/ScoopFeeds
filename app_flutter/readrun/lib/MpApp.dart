import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readrun/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

import 'Splash_screen.dart';
import 'model/theme.dart';
import 'main.dart';
import 'onboarding.dart';


class MyApp extends StatefulWidget {

  final bool showOnboard;

  MyApp({Key key, @required this.showOnboard}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState(showOnboard:this.showOnboard);
}

class _MyAppState extends State<MyApp> {
  bool showOnboard;

  _MyAppState({this.showOnboard});

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return Wiredash(
                secret: p_key,
                projectId: p_id,
                navigatorKey: navigatorKey,
                options: WiredashOptionsData(showDebugFloatingEntryPoint: false),
                theme: notifier.darkTheme?
                WiredashThemeData(brightness: Brightness.dark,primaryColor: Color(0xff1d7ca7),secondaryColor: Color(0xff53b4df)):
                WiredashThemeData(brightness: Brightness.light,primaryColor: Color(0xff10516e),secondaryColor: Color(0xff53b4df)),
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                    debugShowCheckedModeBanner: false,
                    title: 'Scoop Feeds',
                    theme: notifier.darkTheme ? dark : light,
                    home: Scaffold(body: showOnboard?OnboardingScreen():SplashScreen())
                ),
              );
            }));
  }
  
}
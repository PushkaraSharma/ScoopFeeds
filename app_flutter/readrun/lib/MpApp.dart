import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readrun/secrets.dart';
import 'package:wiredash/wiredash.dart';

import 'Splash_screen.dart';
import 'Widgets/theme.dart';
import 'main.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {

    return Wiredash(
      secret: p_key,
      projectId: p_id,
      navigatorKey: navigatorKey,
      child: ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
          child: Consumer<ThemeNotifier>(
              builder: (context, ThemeNotifier notifier, child) {
                return MaterialApp(
                  navigatorKey: navigatorKey,
                    debugShowCheckedModeBanner: false,
                    title: 'Scoop Feeds',
                    theme: notifier.darkTheme ? dark : light,
                    home: Scaffold(body: SplashScreen())
                );
              })),
    );
  }
  
}
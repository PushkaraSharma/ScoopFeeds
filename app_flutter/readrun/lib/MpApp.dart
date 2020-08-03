import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Splash_screen.dart';
import 'Widgets/theme.dart';
import 'main.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Scoop Feeds',
                  theme: notifier.darkTheme ? dark : light,
                  home: Scaffold(body: SplashScreen())
              );
            }));
  }
  
}
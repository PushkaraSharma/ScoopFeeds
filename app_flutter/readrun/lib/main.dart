import 'package:flutter/material.dart';
import 'package:readrun/Splash_screen.dart';
import 'package:readrun/Widgets/theme.dart';
import 'package:provider/provider.dart';
import 'Widgets/notification_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          _checkNotificationOnOff() async {
            print('function');
            if (notifier.notification == true) {
              await notificationPlugin.showNotificationWithAttachment();
            } else {
              await notificationPlugin.cancelNotification();
            }
          }
          _checkNotificationOnOff();

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Scoop Feeds',
              theme: notifier.darkTheme ? dark : light,
              home: Scaffold(body: SplashScreen())
//        theme: ThemeData(
//          scaffoldBackgroundColor: kBackgroundColor,
//          primaryColor: kPrimaryColor,
//          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
//          visualDensity: VisualDensity.adaptivePlatformDensity,
              );
        }));
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
}

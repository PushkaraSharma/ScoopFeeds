import 'package:flutter/material.dart';
import 'package:readrun/Splash_screen.dart';
import 'package:readrun/Widgets/theme.dart';
import 'package:provider/provider.dart';
import 'package:readrun/read_write.dart';
import 'package:readrun/secrets.dart';
import 'Widgets/notification_plugin.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/News.dart';

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup
void showNotification( v, flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);
  await flp.show(0, 'Virtual intelligent solution', '$v', platform,
      payload: 'VIS \n $v');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: true); //to true if still in testing lev turn it to false whenever you are launching the app
  await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15),//when should it check the link
      initialDelay: Duration(seconds: 5),//duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var val = await readWrite.read("notification", "true");
    print(val);
   if(val=='true') {
     print("Executing task of notification");
     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
     var iOS = IOSInitializationSettings();
     var initSetttings = InitializationSettings(android, iOS);
     flp.initialize(initSetttings);


     List<News> list = List();
     final response = await http.get(api_key + 'top_stories' + "/");
     if (response.statusCode == 200) {
       list = (json.decode(response.body) as List)
           .map((data) => new News.fromJson(data))
           .toList();
       String head = list[0].heading;
       showNotification(head, flp);
     } else {
       print("no messgae");
     }
   }
   else{
     print("Notification OFF");
   }
    return Future.value(true);
  });
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
//    super.initState();
//    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
//    notificationPlugin.setOnNotificationClick(onNotificationClick);
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
//          _checkNotificationOnOff();

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Scoop Feeds',
              theme: notifier.darkTheme ? dark : light,
              home: Scaffold(body: SplashScreen())
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

import 'package:shared_preferences/shared_preferences.dart';

import 'MpApp.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:readrun/Widgets/notification_plugin.dart';


const simplePeriodicTask = "simplePeriodicTask";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var timings = prefs.getDouble("slider")??6;
  print("Slider value is $timings");
  var time = ((24/timings)*60).toInt();
  print("Timing of notification changed $time");
  await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: time),
      initialDelay: Duration(minutes: time),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   var val = prefs.getBool("notification")??true;

    print('Notif $val');
   if(val) {
     print("Executing task of notification");
     notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
     notificationPlugin.setOnNotificationClick(onNotificationClick);
     await notificationPlugin.showNotificationWithAttachment();
   }
   else{
     print("Notification OFF");
     await notificationPlugin.cancelNotification();
   }
    return Future.value(true);
  });
}

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }




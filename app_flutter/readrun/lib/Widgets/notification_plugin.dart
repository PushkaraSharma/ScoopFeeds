import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, InternetAddress, Platform, SocketException;
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:workmanager/workmanager.dart';

import '../model/News.dart';
import '../secrets.dart';

class NotificationPlugin {
  //
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> repeatNotification() async {
    print('Its here in plugin');
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 3',
      'CHANNEL_NAME 3',
      "CHANNEL_DESCRIPTION 3",
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Repeating Test Title',
      'Repeating Test Body',
      RepeatInterval.EveryMinute,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  var isLoading = false;

//  Future<void> MainNotification() async {
////    WidgetsFlutterBinding.ensureInitialized();
//    await Workmanager.initialize(showNotificationWithAttachment,
//        isInDebugMode:
//            true); //to true if still in testing lev turn it to false whenever you are launching the app
//    await Workmanager.registerPeriodicTask("5", "simplePeriodicTask",
//        existingWorkPolicy: ExistingWorkPolicy.replace,
//        frequency: Duration(minutes: 15),
//        //when should it check the link
//        initialDelay: Duration(seconds: 5),
//        //duration before showing the notification
//        constraints: Constraints(
//          networkType: NetworkType.connected,
//        ));
//  }

  Future<void> showNotificationWithAttachment() async {
    Workmanager.executeTask((task, inputData) async {
      List<News> list = List();
      isLoading = true;
      String heading, pic_url;

      final response = await http.get(api_key + 'top_stories' + "/");
      if (response.statusCode == 200) {
        list = (json.decode(response.body) as List)
            .map((data) => new News.fromJson(data))
            .toList();
        print(list[0].heading);

        heading = list[0].heading;
        pic_url = list[0].picUrl;

        isLoading = false;
      } else {
        throw Exception('Failed to load News');
      }

      var attachmentPicturePath =
          await _downloadAndSaveFile(pic_url, 'attachment_img.jpg');
      var iOSPlatformSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(attachmentPicturePath)],
      );
      var bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(attachmentPicturePath));
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL ID 2',
        'CHANNEL NAME 2',
        'CHANNEL DESCRIPTION 2',
        importance: Importance.High,
        priority: Priority.High,
        styleInformation: bigPictureStyleInformation,
        ongoing: true,
        icon: 'app_icon',
        color: Colors.white,
      );
      var notificationDetails =
          NotificationDetails(androidChannelSpecifics, iOSPlatformSpecifics);

      await flutterLocalNotificationsPlugin.show(
          0, 'Breaking News', heading, notificationDetails);
      return Future.value(true);
    });
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

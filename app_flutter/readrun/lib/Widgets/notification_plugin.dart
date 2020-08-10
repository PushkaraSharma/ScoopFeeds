import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, InternetAddress, Platform, SocketException;
import 'package:http/http.dart' as http;
import 'package:readrun/model/constants.dart';
import 'package:rxdart/subjects.dart';
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
        AndroidInitializationSettings('ic_launcher');
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


  var isLoading = false;

  Future<void> showNotificationWithAttachment() async {
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

    var attachmentPicturePath =
        await _downloadAndSaveFile(pic_url, 'attachment_img.jpg');
    var iOSPlatformSpecifics = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(attachmentPicturePath)],
    );
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachmentPicturePath),
        largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
      contentTitle: heading,
    );
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL ID 2',
      'CHANNEL NAME 2',
      'CHANNEL DESCRIPTION 2',
      importance: Importance.High,
      priority: Priority.High,
      styleInformation: bigPictureStyleInformation,
      ongoing: false,
      autoCancel: true,
      icon: 'app_icon',
      color: kSecondaryColor,
    );
    var notificationDetails =
        NotificationDetails(androidChannelSpecifics, iOSPlatformSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, heading,"Read more...", notificationDetails);
    }
    else {
        throw Exception('Failed to load News');
     }
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

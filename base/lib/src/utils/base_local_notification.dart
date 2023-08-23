import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

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

class BaseNotification {
  static final BaseNotification _instance = BaseNotification._();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  factory BaseNotification() => _instance;

  BaseNotification._()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    _requestIOSPermissions();
    _notificationConfig();
  }

  Future<void> _notificationConfig() async {
    print('LOCAL NOTIFICATION CALLEDDD');

    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
      ReceivedNotification receivedNotification) async {
    print("showing notification");

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Redawa Notification channel', 'Redawa',
      'Cyber trade application notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // sound: x
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin
        .show(
      receivedNotification?.id ?? 0,
      receivedNotification.title,
      receivedNotification.body,
      platformChannelSpecifics,
      payload: '${receivedNotification.payload}',
    )
        .catchError((e) {
      print("error :  $e");
      return e;
    }).then((value) => print("notification completed"));
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
}

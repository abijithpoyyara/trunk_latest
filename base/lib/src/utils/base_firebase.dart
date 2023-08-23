import 'dart:io';

import 'package:base/src/utils/base_local_notification.dart';
import 'package:base/src/utils/base_prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

const String _FIREBASE_SUBSCRIPTION_KEY = "_FIREBASE_SUBSCRIPTION_KEY";
const String _SUBSCRIPTION_LIST_KEY = "topics";

mixin FireBaseNotificationMixin {
  static final FirebaseNotificationHelper _firebaseNotificationHelper =
      FirebaseNotificationHelper();

  BaseNotification _notification = BaseNotification();

  void initFireBase() {
    _firebaseNotificationHelper.configure();
  }

  void registerForCallback() {
    print("callbacked");
    _firebaseNotificationHelper.configure();
  }

  void subscribeToTopics(List<String> topics) {
    _firebaseNotificationHelper.subscribeTopics(topics);
  }

  void unsubscribeTopics(List<String> topics) {
    _firebaseNotificationHelper.unsubscribeTopics(topics);
  }

  void onLaunch(RemoteMessage message) {
    print(message);

    _serialiseAndNavigate(message);
  }

  void onMessage(RemoteMessage message) {
    FirebaseMessaging.onMessage.listen((message) {
      FlutterAppBadger.updateBadgeCount(1);
      print("onMessage datarwaeq532q5436: ${message?.data}");
    });
    var notificationMsg = message.notification;
    var data = message.data;
    String title = notificationMsg.title;
    String body = notificationMsg.body;

    print(message);
    print('BASE DATA : $data');
    _notification
        .showNotification(
            ReceivedNotification(title: title, body: body, id: 0, payload: ''))
        .catchError((e) {
      print("Error $e");
      return e;
    });
  }

  void onResume(RemoteMessage message) {
    print(message);
    _serialiseAndNavigate(message);
  }
}

void _serialiseAndNavigate(RemoteMessage message) {
  if (message != null) {
    var notificationData = message?.data;
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'document') {
        print('SUCCSS BASE');

        //BaseNavigate(mContext, const DocumentApprovalScreen());

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             DocumentApprovalScreen()));

      } else {
        print('FAILD BASE');
      }
    }
    // If there's no view it'll just open the app on the first view
  }
}

class FirebaseNotificationHelper {
  FirebaseMessaging _firebaseMessaging;

  static final FirebaseNotificationHelper _instance =
      FirebaseNotificationHelper._setUpFirebase();

  factory FirebaseNotificationHelper() {
    return _instance;
  }

  FirebaseNotificationHelper._setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    _checkIOSPermission();
    _firebaseMessaging.getToken().then((token) {
      print("Firebase token: $token");
    });
  }

  void configure() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      print('getInitialMessage data: ${message?.data}');
      _serialiseAndNavigate(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      print("onMessage data: ${message?.data}");
    });

    FirebaseMessaging.onMessage.listen((message) {
      FlutterAppBadger.updateBadgeCount(1);
      print("onMessage data: ${message?.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      FlutterAppBadger.removeBadge();
      print('onMessageOpenedApp data: ${message?.data}');
      _serialiseAndNavigate(message);
    });
    // FirebaseMessaging.onMessage
    // // _firebaseMessaging.getInitialMessage(
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     onMessage(message);
    //     print('ON MESSAGE CALLED');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     onResume(message);
    //     print('ON RESUME CALLED');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     onLaunch(message);
    //     print('ON LAUNCH CALLED');
    //   },
    // );
  }

  Future<List<String>> getSubscribedTopics() async {
    Map<String, dynamic> subscribed_topics =
        await BasePrefs.getMap(_FIREBASE_SUBSCRIPTION_KEY);
    return subscribed_topics == null
        ? <String>[]
        : (subscribed_topics[_SUBSCRIPTION_LIST_KEY] as List)
            .map<String>((e) => e)
            .toList();
  }

  Future<void> subscribeTopics(List<String> topics) async {
    List<String> subscribedTopics = await getSubscribedTopics();
    List<String> topicsToSubscribe =
        topics.where((topic) => !subscribedTopics.contains(topic)).toList();

    topicsToSubscribe.forEach((topic) => _subscribe(topic));
    List<String> subscriptionList = [...subscribedTopics, ...topicsToSubscribe];

    Map<String, dynamic> _kMap = Map<String, dynamic>();
    _kMap[_SUBSCRIPTION_LIST_KEY] = subscriptionList;

    await BasePrefs.setMap(_FIREBASE_SUBSCRIPTION_KEY, _kMap);
  }

  void _subscribe(String topic) async {
    print("Subscribing to topic : $topic");
    await _firebaseMessaging.subscribeToTopic('$topic').then((value) {
      print("Subscribed to topic : $topic");
    }).catchError((e) {
      print("failed to subscribe $topic $e");
      return e;
    });
  }

  void unsubscribeTopics(List<String> topics) async {
    List<String> subscribedTopics = await getSubscribedTopics();
    topics.forEach((element) {
      _unsubscribe(element);
    });

    List<String> subscriptionList =
        subscribedTopics.where((topic) => !topics.contains(topic)).toList();
    print("SubscribedTopics :  $subscribedTopics");
    print("topics to unsubscribe :  $topics");
    Map<String, dynamic> _kMap = Map<String, dynamic>();
    _kMap[_SUBSCRIPTION_LIST_KEY] = subscriptionList;

    print("subscribedTopics $_kMap");

    await BasePrefs.setMap(_FIREBASE_SUBSCRIPTION_KEY, _kMap);
  }

  void _unsubscribe(String topic) {
    print("Unsubscribing topic : $topic");

    _firebaseMessaging.unsubscribeFromTopic('$topic').then((value) {
      print("Unsubscribed to topic : $topic");
    }).catchError((e) {
      print("failed to unsubscribe $topic $e");
      return e;
    });
  }

  void _checkIOSPermission() async {
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true, // headsup notification in IOS
          badge: true,
          sound: true,
        );
      } else {
        //close the app
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }

      print('User granted permission: ${settings.authorizationStatus}');
      // _firebaseMessaging.requestNotificationPermissions(
      //     IosNotificationSettings(sound: true, badge: true, alert: true));
      // _firebaseMessaging.onIosSettingsRegistered
      //     .listen((IosNotificationSettings settings) {
      //   print("Settings registered: $settings");
      // });
    }
  }
}

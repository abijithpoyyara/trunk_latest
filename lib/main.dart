import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/store.dart';
import 'package:redstars/src/widgets/app.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // return showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var data = FirebaseMessaging.instance.getInitialMessage();
  print('terminated');
  print(data);
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);

  await App.initApp();
  var store = await createStore();
  runApp(new App(store));
}

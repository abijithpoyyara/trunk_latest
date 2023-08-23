import 'dart:convert';

import 'package:base/res/drawbles/base_vectors.dart';
import 'package:base/src/utils/base_navigate.dart';
import 'package:base/src/widgets/_partials/base_app_bar.dart';
import 'package:base/src/widgets/_partials/document_type_tile.dart';
import 'package:base/src/widgets/_partials/vector_document_type_tile.dart';
import 'package:base/src/widgets/_views/list_dialog.dart';
import 'package:base/src/widgets/screens/settings/appearance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/*const _channel = const EventChannel('ringtones');

typedef void Listener(dynamic msg);
typedef void CancelListening();

class RingtonesUriModel {
  String name;
  String uri;

  RingtonesUriModel({this.name, this.uri});

}*/

class BaseSettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<BaseSettingsView> {
  int nextListenerId = 1;
  bool fetching = false;

  final MethodChannel platform =
      MethodChannel('com.redstars.redawa/resourceResolver');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: Text("Settings")),
        body: Container(
            child: ListView(shrinkWrap: true,
                // padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                children: [
                  VectorDocumentTypeTile(
                    selected: true,
                    vector: BaseVectors.themeSettings,
                    title: "Notification Sound",
                    subTitle: "Notification",
                    onPressed: () async {
                      // fetchRingtones();
                      // var receivedTones =
                      await platform.invokeMethod('openNotificationSettings');
                      /*var receivedTones =
                      await platform.invokeMethod('getRingtoneUri');
                  Map<String, dynamic> map =
                      jsonDecode(json.encode(receivedTones));
                  List<RingtonesUriModel> tones = [];
                  map.forEach((key, value) {
                    tones.add(RingtonesUriModel(name: key, uri: value));
                  });
                  RingtonesUriModel selected =
                      await showListDialog<RingtonesUriModel>(context, tones,
                          builder: (data, position) => DocumentTypeTile(
                                icon: Icons.notifications_active,
                                title: data.name,
                                subTitle: data.uri,
                                onPressed: () => Navigator.pop(context, data),
                              ),
                          title: "Notification Tones");
                  print("selected : ${selected.toString()}");*/
                    },),
              VectorDocumentTypeTile(
                selected: true,
                vector: BaseVectors.appearance,
                title: "Appearance",
                subTitle: "Update app theme mode",
                onPressed: (){
                  BaseNavigate(context,Appearance());
                },
              )
            ])));
  }

 /* void fetchRingtones() async {
    if (fetching) return;
    fetching = true;
    var cancel = startListening((msg) {
      setState(() {
        print("onResult $msg");
      });
    });
    await Future.delayed(Duration(seconds: 4));
    cancel();
    fetching = false;
  }

  CancelListening startListening(Listener listener) {
    var subscription = _channel
        .receiveBroadcastStream(nextListenerId++)
        .listen(listener, cancelOnError: true);
    return () {
      subscription.cancel();
    };
  }*/
}

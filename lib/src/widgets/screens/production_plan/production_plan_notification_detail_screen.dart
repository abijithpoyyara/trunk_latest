import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:redstars/src/redux/actions/notifications/notification_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:redstars/src/services/model/response/notifications/notifications_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/alert_message_dialog.dart';

import '../../../../utility.dart';

class Production_plan_notification_detail extends StatefulWidget {
  final NotificationGeneratedViewModel viewmodel;
  final String optionId;
  final String approveOptionId;
  final String approvalOptionCode;
  final String clientIdFrmNoti;

  const Production_plan_notification_detail(
      {Key key,
      String transTableId,
      String transId,
      this.optionId,
      this.approveOptionId,
      this.approvalOptionCode,
      this.clientIdFrmNoti,
      this.viewmodel})
      : super(
          key: key,
        );
  @override
  _Production_plan_notification_detailState createState() =>
      _Production_plan_notification_detailState();
}

class _Production_plan_notification_detailState
    extends State<Production_plan_notification_detail> {
  bool selected = false;
  String showTextMore = "";
  String showTextLess = "";
  bool flag = false;

  ScrollController paginationController;

  List<NotificationDisplayListData> list = [];
  int count;
  String clientId;
  @override
  Widget build(BuildContext context) {
    count = list.length;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, NotificationGeneratedViewModel>(
        init: (store, context) async {
          clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
          if (widget.approvalOptionCode == "ANNOUNCEMENT") {
            if (clientId == widget.clientIdFrmNoti) {
            store.dispatch(fetchDataFromNotificationList());
          } else {
              showAlertMessageDialog(
                  context,
                  "Please login or switch the company to approve!",
                  "Alert", () {
                Navigator.pop(context);
              });
            }
          } else {
            store.dispatch(fetchNotificationReportList());
          }
        },
        onDispose: (store) {
          store.dispatch(OnClearAction());
        },
        converter: (store) => NotificationGeneratedViewModel.fromStore(store),
        builder: (context, viewmodel) {
          return Scaffold(
            appBar: BaseAppBar(title: Text('NOTIFICATION')),
            body: NotificationProductionScreen(
                notificationGeneratedViewModel: viewmodel),
          );
        });
  }
}

class NotificationProductionScreen extends StatefulWidget {
  final NotificationGeneratedViewModel notificationGeneratedViewModel;

  const NotificationProductionScreen(
      {Key key, this.notificationGeneratedViewModel})
      : super(key: key);

  @override
  _NotificationProductionScreenState createState() =>
      _NotificationProductionScreenState();
}

class _NotificationProductionScreenState
    extends State<NotificationProductionScreen> {
  int start = 0;
  int limit = 10;
  var items = [];
  String showTextLess = '';
  String showTextMore = '';
  bool flag = false;
  int _selectedIndex;

  _NotificationProductionScreenState();
  @override
  void dispose() {
    loadMoreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (limit >
          widget.notificationGeneratedViewModel.notificationDetailListData
              .length) {
        items.addAll(widget
            .notificationGeneratedViewModel.notificationDetailListData
            .getRange(
                start,
                start +
                    widget.notificationGeneratedViewModel
                        .notificationDetailListData.length));
      } else {
        items.addAll(widget
            .notificationGeneratedViewModel.notificationDetailListData
            .getRange(start, start + limit));
        start = start + limit;
      }
    });
    loadMoreController.addListener(() {
      if (loadMoreController?.position.pixels ==
          loadMoreController?.position.maxScrollExtent) {
        if (items.length <
            widget.notificationGeneratedViewModel.notificationDetailListData
                .length) {
          loadMore();
        }
      }
    });
  }

  ScrollController loadMoreController = ScrollController();

  void loadMore() {
    setState(() {
      if ((start + limit) >
          widget.notificationGeneratedViewModel.notificationDetailListData
              .length) {
        if (items.length <
            widget.notificationGeneratedViewModel.notificationDetailListData
                .length)
          items.addAll(widget
              .notificationGeneratedViewModel.notificationDetailListData
              .getRange(
                  start,
                  widget.notificationGeneratedViewModel
                      .notificationDetailListData.length));
      } else {
        items.addAll(widget
            .notificationGeneratedViewModel.notificationDetailListData
            .getRange(start, start + limit));
      }
      start = start + limit;
    });
  }

  var message;
  String timeAgo(DateTime d) {
    Duration diff = (DateTime.now().difference(d));
    print("anbfjiwqehg   $diff");
    print(diff.inDays);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).ceil()} ${(diff.inDays / 365).ceil() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).ceil()} ${(diff.inDays / 30).ceil() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).ceil()} ${(diff.inDays / 7).ceil() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${(diff.inDays).ceil()} ${(diff.inDays / 24).ceil() == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);

    return RefreshIndicator(
      onRefresh:
          widget.notificationGeneratedViewModel.onRefreshNotificationData,
      color: themeData.primaryColor,
      child: widget.notificationGeneratedViewModel.notificationDetailListData !=
                  null &&
              (widget.notificationGeneratedViewModel.notificationDetailListData
                      .isNotEmpty ??
                  false)
          ? ListView.builder(
              controller: loadMoreController,
              itemCount: (start <
                      widget.notificationGeneratedViewModel
                          .notificationDetailListData.length)
                  ? items.length
                  : items.length,
              itemBuilder: (context, index) {
                var message = parse(items[index].message);
                if (message.body.text.length > 109) {
                  showTextLess = message.body.text.substring(0, 109.toInt());
                  showTextMore = message.body.text
                      .substring(109, message.body.text.length);
                } else {
                  showTextLess = message.body.text;
                  showTextMore = "";
                }
                return (index == items.length)
                    ? BaseLoadingView(
                        message: "Loading",
                      )
                    : Card(
                        color: themeData.primaryColor,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  timeAgo(
                                      DateTime.parse(items[index].createddate)),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  items[index]?.title ??
                                      items[index]?.titlename ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 8),
                          ),
                          message.body.text.length > 109
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      flag && _selectedIndex == index
                                          ? Expanded(
                                              child: Text(
                                              showTextLess + showTextMore,
                                              style: TextStyle(fontSize: 18),
                                            ))
                                          : Expanded(
                                              child: Text(
                                              showTextLess,
                                              style: TextStyle(fontSize: 18),
                                              maxLines: 3,
                                            )),
                                      Container(
                                        child: new Row(children: <Widget>[
                                          flag && _selectedIndex == index
                                              ? InkWell(
                                                  child: Text(
                                                    "show less",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  onTap: () {
//                                                  if (_selectedIndex != null &&
//                                                      _selectedIndex != index) {
////                                                    flag = false;
//                                                  }
                                                    setState(() {
                                                      flag = !flag;
                                                      _selectedIndex = index;
                                                    });
                                                  },
                                                )
                                              : Container(
                                                  child: InkWell(
                                                    child: Text(
                                                        "....    show more",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white70)),
                                                    onTap: () {
                                                      if (_selectedIndex !=
                                                              null &&
                                                          _selectedIndex !=
                                                              index) {
                                                        flag = false;
                                                      }
                                                      setState(() {
                                                        flag = !flag;
                                                        _selectedIndex = index;
                                                      });
                                                    },
                                                  ),
                                                ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(message.body.text,
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    ],
                                  ),
                                )
                        ]));
              })
          : Center(
              child: Text("No Data Found"),
            ),
    );
  }
}

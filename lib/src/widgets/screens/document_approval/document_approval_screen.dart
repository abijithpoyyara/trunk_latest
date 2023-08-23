import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_summary_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_summary_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';

import '../../../../utility.dart';
import 'document_approval_screen_detail.dart';

var node;
var jsRespns;
var unreadCount;
String isDocInit;
String doc_key;

class DocumentApprovalScreen extends StatelessWidget {
  const DocumentApprovalScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, DocumentApprSummaryViewModel>(
      init: (store, context) async{
        int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
        store.dispatch(SelectBranchId(branchId: 0));

        await BasePrefs.setString(
            BaseConstants.SCREEN_STATE_KEY, "MOBILE_DOC_APRVL");
        store.dispatch(fetchInitialList(branchId: 0));
//        print("kkkk");
//         doc_key= await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY);

        void checkAndAddMessageListener() async {
          print("Document Approval Listener Function.");
          doc_key =
              await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";
          isDocInit = await BasePrefs.getString('isDocInit') ?? "";

          if (isDocInit == "") {
            await BasePrefs.setString("isDocInit", "true");

            print("Document Approval Listener Initilised");
            FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
              doc_key =
                  await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ??
                      "";
              log("branch id at notify level");
              print(doc_key);

              if (doc_key == "MOBILE_DOC_APRVL") {
                print("Document Approval Listener Calling.");
                print("Document Approval Listener event. $event");

                if (event != null) {
                  var notificationData = event?.data;
                  var approvalOptionCode = notificationData["approptioncode"];

                  if (approvalOptionCode != "MOB_TRAN_UNBLK_REQ_APRVL" ||
                      approvalOptionCode != "MOB_UNCFIRMD_TRNSCTION") {
                    print("Document Approval Listener Called refresh");
                    print("Document Approval Listener branchId is " +
                        store.state.docApprovalState.summaryState.branchId
                            .toString());
                    store.dispatch(fetchInitialList(
                        branchId: store
                            .state.docApprovalState.summaryState.branchId));
                  }
                }
              }
            });
          }
        }

        checkAndAddMessageListener();
      },
      converter: (store) => DocumentApprSummaryViewModel.fromStore(store),
      appBar: BaseAppBar(
        title: Text(
          "Document Approvals",
          style: TextStyle(fontFamily: "Roboto-Medium"),
        ),
        elevation: 0,
      ),
      builder: (context, viewModel) {
        return Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: (viewModel?.transactionTypeList?.isNotEmpty ?? false)
                    ? _DocumentApprovalGrid(viewModel: viewModel)
                    : (viewModel.transactionTypeList?.isEmpty ?? false) &&
                            (viewModel.statusCode == 1)
                        ? _EmptyListView()
                        : BaseLoadingView(
                            message: "Loading",
                          )),
            if (viewModel.isSuperUser)
              Positioned(
                left: 0,
                right: 0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Material(
                          type: MaterialType.transparency,
                          child: GestureDetector(
                            onVerticalDragStart: (DragStartDetails) async {
                              BranchList selectedBranch =
                                  await showBranchSheet(
                                context,
                                viewModel.branchList,
                                viewModel.selectedBranch);


                              if (selectedBranch?.name != "All Branches") {
                            viewModel.selectBranchList(selectedBranch??viewModel.selectedBranch);
                            viewModel.setBranchId(selectedBranch?.id??viewModel.branchId);
                            viewModel.loadTransactions(selectedBranch?.id??viewModel.branchId);
                              } else {

                                viewModel.selectBranchList(
                                    viewModel.selectedBranch);
                                viewModel.setBranchId(0);
                                viewModel.loadTransactions(0);
                              }

                          },
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * .09,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(0,-1),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),

                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Divider(
                                      color: Theme.of(context).primaryColorDark,
                                      thickness: 3,
                                      endIndent: MediaQuery.of(context).size.width/2.4,
                                      indent: MediaQuery.of(context).size.width/2.4,
                                     ),
                                    Text(
                                        "${viewModel.branchId != 0 ? viewModel.selectedBranch?.name : "All Branches"}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
          ],
        );
      },
      onDispose: (store) async {
        String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
        int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
        store.dispatch(
            fetchNotificationCount(clientid: clientId, userid: userId));
        store.dispatch(SummaryClearAction());
        await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");
        String dispose_key =
            await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY);
        print("dispose_key");
        print(dispose_key);
      },
    );
  }

  Future<BranchList> showBranchSheet(BuildContext context,
      List<BranchList> branches, BranchList selectedBranch) {
    return showModalBottomSheet<BranchList>(
      backgroundColor: Colors.transparent,
        context: context,
        builder: (_context) => BaseListDialog<BranchList>(
            list: branches,
            builder: (data, pos) => DocumentTypeTile(
                selected: data.id == selectedBranch?.id,
                title: data.name,
                icon: Icons.location_searching,
                onPressed: () => Navigator.pop(context, data)),
            title: "Branch List"));
  }
}

class _DocumentApprovalGrid extends StatefulWidget {
  final DocumentApprSummaryViewModel viewModel;

  const _DocumentApprovalGrid({Key key, this.viewModel}) : super(key: key);

  @override
  __DocumentApprovalGridState createState() => __DocumentApprovalGridState();
}

class __DocumentApprovalGridState extends State<_DocumentApprovalGrid>
    with FireBaseNotificationMixin {
  FirebaseMessaging firebaseMessaging;

  @override
  void initState() {
    super.initState();
  }

  getCount() async {
    await subOptionNotificationCountCall();
  }

  Future subOptionNotificationCountCall() async {
    print("working");
    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    var body = {
      "url": "/security/controller/cmn/getdropdownlist",
      "jsonArr":
          '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",\"key\":\"resultObject\",\"procName\":\"MobileNotificationProc\",'
              '\"actionFlag\":\"NOTIFICATION_COUNT\",\"subActionFlag\":\"\",'
              '\"xmlStr\":\"<List Flag = \\\"TRANS_OPTION_WISE\\\" /><User Clientid = \\\"$clientId\\\" UserId = \\\"$userId\\\"/>\"'
              '}]}]',
      'ssnidn': '$ssnId'
    };
    print(body);
    String url = Connections().generateUri() + 'getdata';
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print("response ----- ${response.body}");
    var jsonResponse = json.decode(response.body);
    print("yolo");
    node = jsonResponse;
    jsRespns = jsonResponse;

    return jsRespns;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    print("hio");
    // print(jsRespns["resultObject"]);

    return RefreshIndicator(
        color: themeData.primaryColorLight,
        onRefresh: () =>
            widget.viewModel.refreshList(widget.viewModel.branchId),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
            itemCount: widget.viewModel.transactionTypeList.length,
            itemBuilder: (context, int index) {
              int count;
              if(widget.viewModel.notificationDetails != null) {
                widget.viewModel.notificationDetails.forEach((element) {
                  if (element.refoptionid ==
                          widget
                              .viewModel.transactionTypeList[index].optionId &&
                      element.approvalsubtypeid ==
                          widget
                              .viewModel.transactionTypeList[index].subTypeId) {
                    count = element.notificationcount;
                  }
                });
              } else {
                print("No Notification Detail" );
              }
              return _TransactionTypes(
                  primaryTitle:
                      widget.viewModel.transactionTypeList[index].optionName,
                  primaryIcon: IconData(
                      widget.viewModel.transactionTypeList[index].icon,
                      fontFamily: 'MaterialIcons'),
                  primaryColor: Color(
                      widget.viewModel.transactionTypeList[index].iconColor),
                  secondaryColor: Color(
                      widget.viewModel.transactionTypeList[index].countColor),
                  count: widget.viewModel.transactionTypeList[index].transCount,
                  unreadCount: count,
                  onClick: () async{
                    widget.viewModel.onTransactionSelected(
                        widget.viewModel.transactionTypeList[index]);
                    await BasePrefs.setString(
                        BaseConstants.SCREEN_STATE_KEY, "");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentApprovalScreenDetail(
                              branchId: widget.viewModel.branchId,
                              // transts: transList[index],
                              transaction:
                                  widget.viewModel.transactionTypeList[index],
                              selectedBranch: widget.viewModel.selectedBranch)),
                    ).then((value) => widget.viewModel
                        .refreshList(widget.viewModel.branchId));
                  });
            }));
  }
}

var mContext = null;

void _serialiseAndNavigate(Map<String, dynamic> message) {
  var notificationData = message['data'];
  var view = notificationData['view'];

  print('NOTIFICATION VIEW : $view');
  print('NOTIFICATION DATA : $notificationData');

  if (view != null) {
    // Navigate to the create post view
    if (view == 'document') {
      print('SUCCSS');

      BaseNavigate(mContext, const DocumentApprovalScreen());

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             DocumentApprovalScreen()));

    } else {
      print('FAILDD');
    }
    // If there's no view it'll just open the app on the first view
  }
}

class _TransactionTypes extends StatelessWidget {
  final Color primaryColor;
  final IconData primaryIcon;
  final String primaryTitle;
  final Color secondaryColor;
  final int count;
  final int unreadCount;
  final VoidCallback onClick;

  _TransactionTypes({
    this.primaryColor,
    this.primaryIcon,
    this.primaryTitle,
    this.secondaryColor,
    this.count,
    this.onClick,
    this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
                onTap: onClick,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * .12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: count > 0
                          ? themeData.primaryColor
                          : themeData.primaryColor.withOpacity(.10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 18),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _CircleAvatar(
                                icon: primaryIcon ?? Icons.description,
                              ),
                                  Visibility(
                                      visible: unreadCount != null,
                                      child: Positioned(
                                        left: -5,
                                        top: -8,
                                        child: Visibility(
                                            visible: unreadCount != null,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "$unreadCount",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )),
                                      )),
                                ],
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Text(
                              primaryTitle,
                              style: style.subhead1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 18),
                            child: Text(
                              count.toString(),
                              style: style.subhead1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}

class _CircleAvatar extends StatelessWidget {
  final IconData icon;

  const _CircleAvatar({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: ThemeProvider.of(context).primaryColorDark,
        radius: 24,
        child: Icon(
          icon,
          color: Colors.white,
        ));
  }
}

class _CountItem extends StatefulWidget {
  final int count;

  _CountItem({@required this.count});

  @override
  _HomeCategoryItemState createState() => _HomeCategoryItemState(count);
}

class _HomeCategoryItemState extends State<_CountItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animationCount;
  Animation<double> animationHour;

  int count;

  _HomeCategoryItemState(this.count);

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        setState(() {});
      });

    animationCount = IntTween(begin: 0, end: count ?? 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    animationHour = _controller.drive(Tween<double>(begin: 0.6, end: 1));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);

    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) => Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RotationTransition(
                    turns: animationHour,
                    child: Icon(Icons.hourglass_empty,
                        size: 22, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(animationCount.value.toString(), style: style.display3),
                ]));
  }

  @override
  void didUpdateWidget(_CountItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.forward(from: 0);
  }
}

class _EmptyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.done, color: Colors.green, size: 54),
                SizedBox(height: 4),
                Text("All Caught up",
                    style:
                        BaseTheme.of(context).bodyMedium.copyWith(fontSize: 18))
              ]))
    ]);
  }
}

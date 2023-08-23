//import 'dart:convert';
//import 'dart:developer';
//import 'dart:io';
//import 'package:http/http.dart' as http;
//import 'package:animated_theme_switcher/animated_theme_switcher.dart';
//import 'package:base/constants.dart';
//import 'package:base/resources.dart';
//import 'package:base/services.dart';
//import 'package:base/utility.dart';
//import 'package:base/widgets.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
//import 'package:redstars/src/constants/app_constants.dart';
//import 'package:redstars/src/redux/actions/document_approval/document_approval_summary_actions.dart';
//import 'package:redstars/src/redux/actions/transaction_unblock_request/transaction_unblock_request_action.dart';
//import 'package:redstars/src/redux/states/app_state.dart';
//import 'package:redstars/src/redux/viewmodels/document_approval/da_summary_viewmodel.dart';
//import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
//import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
//import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
//import 'package:redstars/src/widgets/screens/document_approval/document_approval_screen_detail.dart';
//import '_partial/_pending_tiles.dart';
//import '_partial/transaction_tile.dart';
//
//
//class UnblockDetailRequestScreen extends StatelessWidget {
//  final UnblockListViewModel viewModel;
//  const UnblockDetailRequestScreen({Key key,
//    this.viewModel
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<AppState, UnblockListViewModel>(
//      init: (store, context) {
//        final selected = store.state.unblockRequestState.pendingTile;
////        store.dispatch(fetchDocumentDetails());
//        store.dispatch(fetchListHeadings());
//        store.dispatch(fetchListDetail());
//      },
//      converter: (store) => UnblockListViewModel.fromStore(store),
//      appBar: BaseAppBar(
//        title: Text(
//          "Transaction Unblock Request",
//          style: TextStyle(fontFamily: "Roboto-Medium"),
//        ),
//        elevation: 0,
//      ),
//      builder: (context, viewModel) {
//        return Stack(
//          fit: StackFit.expand,
//          children: [
//            // Padding(
//            //     padding: EdgeInsets.symmetric(horizontal: 4),
//            //     child: (viewModel?.ptListModel!=null && viewModel.ptListModel.isNotEmpty)
//            //         ?
//        TransactionTile(
//        tableModel:viewModel.pendingTile,
//        //tableModelDetail: viewModel.dtlModel?.ptDetailListModel,
//        )// _PendingTransGrid(
//                //   viewModel: viewModel,
//                //   pendingTrans: viewModel.dtlModelList,)
//                  //  : _EmptyListView()),
//          ],
//        );
//      },
//      onDispose: (store) => store.dispatch(SummaryClearAction()),
//    );
//  }
//}
//
//class _PendingTransGrid extends StatefulWidget {
//  final UnblockListViewModel viewModel;
//  final PendingTransactionDetailModelList pendingTrans;
//
//  const _PendingTransGrid({Key key,
//    this.viewModel, this.pendingTrans}) : super(key: key);
//
//  @override
//  __PendingTransGridState createState() => __PendingTransGridState();
//}
//
//class __PendingTransGridState extends State<_PendingTransGrid>
////  with FireBaseNotificationMixin
//    {
//  @override
//  void initState() {
//    mContext = context;
//    super.initState();
//    //   registerForCallback();
////    widget.viewModel.refreshList();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return
//    RefreshIndicator(
//      color: Colors.white,
//       onRefresh: () {},
//           //widget.viewModel.refreshList(),
//      child: ListView.builder(
//          itemCount: widget.viewModel.ptListModel.length,
//          itemBuilder: (context, int index) {
//            return TransactionTile(
//              tableModel: widget.viewModel.pendingTile,
//                tableModelDetail: widget.viewModel.dtlModel.ptDetailListModel,
//            );
//          }
//          ));
//  }
//
//// @override
//// void onLaunch(Map<String, dynamic> message) {
////   super.onLaunch(message);
////   widget.viewModel.refreshList();
////   _serialiseAndNavigate(message);
//// }
////
//// @override
//// void onMessage(Map<String, dynamic> message) {
////   super.onMessage(message);
////   widget.viewModel.refreshList();
//// }
////
//// @override
//// void onResume(Map<String, dynamic> message) {
////   super.onResume(message);
////   widget.viewModel.refreshList();
////   _serialiseAndNavigate(message);
////
//// }
//}
//
//var mContext = null;
//
//// void _serialiseAndNavigate(Map<String, dynamic> message) {
////   var notificationData = message['data'];
////   var view = notificationData['view'];
////
////   print('NOTIFICATION VIEW : $view');
////   print('NOTIFICATION DATA : $notificationData');
////
////   if (view != null) {
////     // Navigate to the create post view
////     if (view == 'document') {
////       print('SUCCSS');
////
////       BaseNavigate(mContext, const DocumentApprovalScreen());
////
////       // Navigator.push(
////       //     context,
////       //     MaterialPageRoute(
////       //         builder: (context) =>
////       //             DocumentApprovalScreen()));
////
////     } else {
////       print('FAILDD');
////     }
////     // If there's no view it'll just open the app on the first view
////   }
//// }
//
//
//class _CircleAvatar extends StatelessWidget {
//  final IconData icon;
//
//  const _CircleAvatar({Key key, this.icon}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return CircleAvatar(
//        backgroundColor: ThemeProvider.of(context).primaryColorDark,
//        radius: 24,
//        child: Icon(
//          icon,
//          color: Colors.white,
//        ));
//  }
//}
//
//class _CountItem extends StatefulWidget {
//  final int count;
//
//  _CountItem({@required this.count});
//
//  @override
//  _HomeCategoryItemState createState() => _HomeCategoryItemState(count);
//}
//
//class _HomeCategoryItemState extends State<_CountItem>
//    with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  Animation animationCount;
//  Animation<double> animationHour;
//
//  int count;
//
//  _HomeCategoryItemState(this.count);
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = new AnimationController(
//        duration: const Duration(milliseconds: 1000), vsync: this)
//      ..addListener(() {
//        setState(() {});
//      });
//
//    animationCount = IntTween(begin: 0, end: count ?? 0).animate(
//        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
//    animationHour = _controller.drive(Tween<double>(begin: 0.6, end: 1));
//
//    _controller.forward();
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    BaseTheme style = BaseTheme.of(context);
//
//    return AnimatedBuilder(
//        animation: _controller,
//        builder: (BuildContext context, Widget child) => Column(
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              RotationTransition(
//                turns: animationHour,
//                child: Icon(Icons.hourglass_empty,
//                    size: 22, color: Colors.white),
//              ),
//              SizedBox(height: 10),
//              Text(animationCount.value.toString(), style: style.display3),
//            ]));
//  }
//
//  @override
//  void didUpdateWidget(_CountItem oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _controller.forward(from: 0);
//  }
//}
//
//class _EmptyListView extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ListView(children: [
//      Container(
//          height: MediaQuery.of(context).size.height / 1.5,
//          child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Icon(Icons.done, color: Colors.green, size: 54),
//                SizedBox(height: 4),
//                Text("All Caught up",
//                    style:
//                    BaseTheme.of(context).bodyMedium.copyWith(fontSize: 18))
//              ]))
//    ]);
//  }
//}
//
//class PendingTransactionsDetails extends StatefulWidget {
//  const PendingTransactionsDetails({Key key}) : super(key: key);
//
//  @override
//  _PendingTransactionsDetailsState createState() => _PendingTransactionsDetailsState();
//}
//
//class _PendingTransactionsDetailsState extends State<PendingTransactionsDetails> {
//  Map<String, dynamic> data;
//  Map<String, dynamic> node;
//  String acccode;
//  String accname;
//  String blockdate;
//  String blockedyn;
//  int branchid;
//  int closingbal;
//  int companyid;
//  String chequeto;
//  int id;
//  int notificationid;
//  int openingbal;
//  int requestedamount;
//  String requestno;
//  String periodfrom;
//  String periodto;
//  String reconciledate;
//  String status;
//  int rowno;
//  String settledate;
//  int tableid;
//  String voucherdate;
//  String voucherno;
//  String transno;
//  String optioncode;
//  String paymenttype;
//  String description;
//  String duedate;
//  int amount;
//  String userName;
//  String password;
//  int userId;
//
//  @override
//  void initState() {
//    super.initState();
//    getPrefs();
//  }
//
//  getPrefs() async {
//    userName = await BasePrefs.getString(USERNAME_KEY);
//    password = await BasePrefs.getString(PASSWORD_KEY);
//    userId = await BasePrefs.getInt(USERID_KEY);
//    // await fetchDtlSection();
//  }
//  showLoaderDialog(BuildContext context) {
//    AlertDialog alert = AlertDialog(
//      content: new Row(
//        children: [
//          CircularProgressIndicator(
//            valueColor: new AlwaysStoppedAnimation<Color>(
//                ThemeProvider.of(context).primaryColor),
//          ),
//          Container(
//              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
//        ],
//      ),
//    );
//    showDialog(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) {
//        return alert;
//      },
//    );
//  }
//
//  Future fetchTransactData() async{
//    showLoaderDialog(context);
//    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
//    String jSessionId = await BasePrefs.getString(COOKIE_KEY);
//    var body = {
//      'jsonArr': '[{\"dropDownParams\":[{'
//          '\"list\":\"EXEC-PROC\",'
//          '\"key\":\"resultObject\",'
//          '\''"procName\":\"MobileNotificationProc\","
//          "\"actionFlag\":\"LIST\","
//          "\"subActionFlag\":\"DETAIL\","
//          "\"xmlStr\":\"<List OptionId  = \\\"799\\\" Id = \\\"1 \\\"> </List>\"}]}]'",
//      'url': '/security/controller/cmn/getdropdownlist',
//      'ssnidn': '$ssnId',
//    };
//    String url = Connections().generateUri() + 'getdata';
//    final headers = {
//      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
//      HttpHeaders.acceptCharsetHeader: "UTF-8",
//      HttpHeaders.cookieHeader:
//      await BasePrefs.getString(COOKIE_KEY)
//    };
//    log('DATA body: $body');
//    var response = await http.post(   Uri.parse(url) , headers: headers, body: body);
//    Navigator.pop(context);
//    print('Response status: ${response.statusCode}');
//    if (response.body.contains("ERROR")) {
//      var jsonResponse = json.decode(response.body);
//      node = jsonResponse;
//      String statusMsg = node["statusMessage"];
//
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

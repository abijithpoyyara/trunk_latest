import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/res/navigation/app_routes.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/sales_invoice/sales_invoice_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/home/home_viewmodel.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/back_date_main_page.dart';
import 'package:redstars/src/widgets/screens/branch_blocked_notification/blocedNotificationMainScreen.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/payLoadModel.dart';
import 'package:redstars/src/widgets/screens/document_approval/document_approval_notification.dart';
import 'package:redstars/src/widgets/screens/document_approval/document_approval_screen.dart';
import 'package:redstars/src/widgets/screens/gin/gin_screen.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/process_list_view.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/item_grade_rate_settings_view.dart';
import 'package:redstars/src/widgets/screens/job_progress_report/job_progress_screen.dart';
import 'package:redstars/src/widgets/screens/notification_statistics_report/notification_statistics_report_main_screen.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/payment_voucher_screen.dart';
import 'package:redstars/src/widgets/screens/po_acknowledge/po_acknowledge_screen.dart';
import 'package:redstars/src/widgets/screens/po_khat/po_khat_initial_screen.dart';
import 'package:redstars/src/widgets/screens/pricing/_partial/temp_view.dart';
import 'package:redstars/src/widgets/screens/production_plan/production_plan_notification_detail_screen.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/payment_requisition_header_view.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/purchase_requisition_view.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/stock_requisition_view.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/sales_enquiry_mis_screen.dart';
import 'package:redstars/src/widgets/screens/sales_insight/sales_insight_home.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/sales_invoice_screen.dart';
import 'package:redstars/src/widgets/screens/splash/splash.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request/pending_transactions_list.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/on_notification_view_page.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/transaction_unblock_req_appvl_main_screen.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/view/unconfirmed_notification_page.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/view/unconfirmed_transaction_main_screen.dart';
import 'package:redstars/src/widgets/screens/vehicle_enquiry/vehicle_enquiry_main_screen.dart';

import '_partials/module_list.dart';
import '_partials/top_button_bar.dart';

const double _kBottomBarHeight = 46.0;
const double _kBottomGridsHeight = 300.0;
const double _kStatGridsHeight = 40.0;

String tokenFcm;
PayloadModel payloadModel;

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool isNotificationScreenClosed = true;

Future onSelectNotification(String payload) async {
  print("onselection called");
  print('view');
  print('PAY LOAD $payload');
  String transOptionCode =
      await BasePrefs.getString(BaseConstants.TRANS_UNBLOCK_REQ_OPTIONCODE);
  print('PAY LOAD $payload');
// var spaceRemoved=payload.replaceAll(" ", "");
// print(spaceRemoved);

//  var notificationModelMap = jsonEncode(payload);
  final payloadJson = payload.replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
    return '"${match.group(0)}"';
  });

  // Map<String, dynamic> node = notificationModelMap;
  print('PAY LOAD DATA $payloadJson');

  var convertPost = json.decode(payloadJson);
  payloadModel = PayloadModel.fromJson(convertPost);
  print('PAY LOAD VALUES ${payloadModel.view}');

  var view = payloadModel.view;
  var optionId = payloadModel.optionid;
  var refoptionId = payloadModel.refoptionid;
  var approvalOptionId = payloadModel.approvaloptionid;
  var transId = payloadModel.transid;
  var transTableId = payloadModel.transtableid;
  var approvalOptionCode = payloadModel.approvalOptionCode;
  var refoptName = payloadModel.refoptnCode;
  var approvalOptnName = payloadModel.approvalOptName;
  var subTypeId = payloadModel.subTypeId;
  var clientIdFromNotification = payloadModel.clientid;
  print('PAY LOAD VALUES $view,$transTableId');

  if (view != null) {
    if (view == 'document') {
      print('SUCCSS');
      if (isNotificationScreenClosed) {
        Navigator.popUntil(mContext, (Route<dynamic> route) => route.isFirst);
        if (approvalOptionCode == transOptionCode ??
            "MOB_TRAN_UNBLK_REQ_APRVL") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              mContext,
              TransactionUnblockNotificationScreen(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                onUserClickNotification: true,
                    clientIdFrmNoti: clientIdFromNotification));
        });
      } else if (approvalOptionCode == "MOB_UNCFIRMD_TRNSCTION") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              mContext,
              UnconfirmedNotificationPage(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                refoptionid: refoptionId,
                // isFromNotificationClick: true,
                approvalOptnName: refoptName ?? "",
                    clientIdFrmNoti: clientIdFromNotification));
        });
      } else if (approvalOptionCode == "ANNOUNCEMENT") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              mContext,
              Production_plan_notification_detail(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                approvalOptionCode: approvalOptionCode,
                    clientIdFrmNoti: clientIdFromNotification));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              mContext,
              DocumentApprovalNotification(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                approvalOptionCode: approvalOptionCode,
                approvalOptnName: approvalOptnName,
                subTypeId: subTypeId,
                    clientIdFrmNoti: clientIdFromNotification));
        });
        }
      } else {
        if (approvalOptionCode == transOptionCode ??
            "MOB_TRAN_UNBLK_REQ_APRVL") {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pop(mContext);
            await Future.delayed(Duration(seconds: 1));
            BaseNavigate(
                mContext,
                TransactionUnblockNotificationScreen(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  onUserClickNotification: true,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else if (approvalOptionCode == "MOB_UNCFIRMD_TRNSCTION") {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pop(mContext);
            await Future.delayed(Duration(seconds: 1));
            BaseNavigate(
                mContext,
                UnconfirmedNotificationPage(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  refoptionid: refoptionId,
                  // isFromNotificationClick: true,
                  approvalOptnName: refoptName ?? "",
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else if (approvalOptionCode == "ANNOUNCEMENT") {
          log("executed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BaseNavigate(
                mContext,
                Production_plan_notification_detail(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  approvalOptionCode: approvalOptionCode,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pop(mContext);
            await Future.delayed(Duration(seconds: 1));
            BaseNavigate(
                mContext,
                DocumentApprovalNotification(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  approvalOptionCode: approvalOptionCode,
                  approvalOptnName: approvalOptnName,
                  subTypeId: subTypeId,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        }
      }
    } else {
      print('FAILED');
    }
  }
}

void showNotification(RemoteMessage message) async {
 final notificationId = UniqueKey().hashCode;
  var notificationDtl = message.notification;
  var title = notificationDtl.title;
  var body = notificationDtl.body;
  var notificationData = message.data;

  print('WWWWWWW ::$title,$body');

  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''));
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: ios);
  await flutterLocalNotificationsPlugin.show(
      notificationId, "$title", "$body", platform,
      payload: "$notificationData");
}

pushNotification() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Notif called");
    showNotification(message);
    print("onMessage datacvhgfjghj: ${message.data}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    FlutterAppBadger.removeBadge();
    print('onMessageOpenedApp data: ${message.data}');
    _serialiseAndNavigate(message);
  });
  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
    print('onMessageClosed data: ${message.data}');
  });
  _firebaseMessaging.getToken().then((token) {
    updateToken(token);
  });
}

var mContext = null;

void _serialiseAndNavigate(RemoteMessage message) async {
  if (message != null) {
    var notificationData = message?.data;
    var view = notificationData['view'] ?? "";
    var optionId = notificationData['optionid'];
    var refoptionId = notificationData['refoptionid'];
    var approvalOptionId = notificationData['approptionid'];
    var transId = notificationData['transid'];
    var transTableId = notificationData["transtableid"];
    var approvalOptionCode = notificationData["approptioncode"];
    var refoptName = notificationData["refoptioncode"];
    var approvalOptnName = notificationData["optionname"];
    var subTypeId = notificationData["subtypeid"];
    var clientIdFromNotification = notificationData["clientid"];

    String transOptionCode =
        await BasePrefs.getString(BaseConstants.TRANS_UNBLOCK_REQ_OPTIONCODE);
    log('DATA :: $notificationData');
    print('DATAS :: $optionId,$transTableId,$transId,$approvalOptionId');

    if (view != null) {
      if (view == 'document') {
        print('SUCCSS');
        if (approvalOptionCode == transOptionCode ??
            "MOB_TRAN_UNBLK_REQ_APRVL") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('unblock');
            BaseNavigate(
                Keys.navKey.currentState.context,
                TransactionUnblockNotificationScreen(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  onUserClickNotification: true,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else if (approvalOptionCode == "MOB_UNCFIRMD_TRNSCTION") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('confimrd');
            BaseNavigate(
                Keys.navKey.currentState.context,
                UnconfirmedNotificationPage(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  refoptionid: refoptionId,
                  // isFromNotificationClick: true,
                  approvalOptnName: refoptName ?? "",
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else if (approvalOptionCode == "ANNOUNCEMENT") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BaseNavigate(
                Keys.navKey.currentState.context,
                Production_plan_notification_detail(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  approvalOptionCode: approvalOptionCode,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('Approval');
            BaseNavigate(
                  Keys.navKey.currentState.context,
                DocumentApprovalNotification(
                  optionId: optionId,
                  transTableId: transTableId,
                  transId: transId,
                  approveOptionId: approvalOptionId,
                  approvalOptnName: approvalOptnName,
                  subTypeId: subTypeId,
                    clientIdFrmNoti: clientIdFromNotification));
          });
        }
      }
    } else {
      print('FAILED');
    }
  }
}

void updateToken(String token) {
  print(token);
  tokenFcm = token;
}

class HomePage extends StatelessWidget {
  final String userId;
  final String clientId;
  const HomePage({
    Key key,
    this.userId,
    this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => appChoiceDialog(
        context: context,
        message: "Are you leaving the app?",
      ),
      child: BaseStatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          //  resizeToAvoidBottomPadding: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const Opacity(
                  opacity: .5,
                  child: const DecoratedBox(decoration: const BoxDecoration())),
              __MenuBuilder(userId, clientId)
            ],
          ),
        ),
      ),
    );
  }
}

class __MenuBuilder extends StatelessWidget
    with BaseStoreMixin<AppState, HomeViewModel> {
  int userId;
  String clientId;
  LoginModel tempLogin=LoginModel();

  __MenuBuilder(String userId, String clientId);
  List<MenuModel> getAllMenuItem(BuildContext context) {
    List<MenuModel> menuItems = List();

    menuItems.add(MenuModel(
        // icon: Icons.assignment_late,
        color: Color(0xFF96562D),
        title: "Document Approval",
        hasBadge: true,
        vector: AppVectors.documentApproval_icon,
        subTitle: "",
        rightFlag: "MOBILE_DOC_APRVL",
        onPressed: () => BaseNavigate(context, DocumentApprovalScreen())));
    menuItems.add(MenuModel(
        icon: Icons.location_on_outlined,
        color: Color(0xFF96563D),
        title: "Transaction Unblock Request Approval",
        vector: AppVectors.remarks,
        hasBadge: true,
        subTitle: "",
        rightFlag: "MOB_TRAN_UNBLK_REQ_APRVL",
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (context) =>
                  TransactionUnblockApprovalPendingViewScreen(),
            ))
            .then((value) async {})));
    menuItems.add(MenuModel(
        icon: Icons.location_on_outlined,
        color: Color(0xFF96562D),
        title: "Transaction Unblock Request",
        vector: AppVectors.requestFrom,
        //publicItem: true,
        subTitle: "Hello",
        rightFlag: "MOBILE_TRANS_UNBLOCK_REQ",
        onPressed: () => BaseNavigate(context, TranUnblkRequestScreen())));
    menuItems.add(MenuModel(
        icon: Icons.assignment,
        color: Color(0xFF96563D),
        title: "UnConfirmed Transaction Details",
        //vector: AppVectors.ic_attachment,
        subTitle: "",
        hasBadge: true,
        // publicItem: true,
        rightFlag: "UNCONFIRMED_TRANSACTION",
        onPressed: () =>
            BaseNavigate(context, UnconfirmedTransactionMainScreen())));
    menuItems.add(MenuModel(
        //icon: Icons.dashboard,
        //  color: Color(0xFF96562D),
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Back Dated Entry Permission",
        icon: Icons.calendar_today_outlined,
        subTitle: "",
        rightFlag: "MOB_BCK_DTD_ENT_PRMSN",
        // publicItem: true,
        onPressed: () => BaseNavigate(context, BackDatedEntryView())));

    menuItems.add(MenuModel(
        //icon: Icons.dashboard,
        //  color: Color(0xFF96562D),
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Sales Insight",
        icon: Icons.dashboard,
        vector: AppVectors.salesInsight_icon,
        subTitle: "",
        rightFlag: "MOBILE_SALES_INSIGHT",
        onPressed: () => BaseNavigate(context, SalesInsightView())));
    menuItems.add(MenuModel(
        //icon: Icons.dashboard,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Job Progress Report",
        vector: AppVectors.jobProgress_icon,
        subTitle: "",
        rightFlag: "MOBILE_JOB_PROGRESS",
        onPressed: () => BaseNavigate(context, JobProgressScreen())));
    menuItems.add(MenuModel(
        icon: Icons.inventory,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Goods Inspect Note",
        vector: AppVectors.paymentType,
        subTitle: "",
        //publicItem: true,
        rightFlag: "GRN_KHAT",
        onPressed: () => BaseNavigate(context, GINScreen())));
    menuItems.add(MenuModel(
        //  icon: Icons.point_of_sale_sharp,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Sales Enquiry Mis",
        vector: AppVectors.salesEnquiryMis_icon,
        subTitle: "",
        rightFlag: "MOBILE_SALES_MIS",
        onPressed: () => BaseNavigate(context, SalesMisScreen())));
    menuItems.add(MenuModel(
        // icon: Icons.shopping_cart,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Purchase Requisition",
        vector: AppVectors.purchaseReq_icon,
        subTitle: "",
        rightFlag: "Purchase Requisition",
        onPressed: () => BaseNavigate(context, PurchaseRequisitionView())));
    menuItems.add(MenuModel(
        //icon: Icons.store,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Stock Requisition",
        vector: AppVectors.stockReq_icon,
        subTitle: "",
        rightFlag: "Stock Requisition",
        onPressed: () => BaseNavigate(context, StockRequisitionView())));
    menuItems.add(MenuModel(
        // icon: Icons.location_on_outlined,
        color: ThemeProvider.of(context).primaryColorDark,
        title: "Payment Requisition",
        vector: AppVectors.paymentReq_icon,
        subTitle: "",
        rightFlag: "Payment Requisition",
        onPressed: () =>
            BaseNavigate(context, PaymentRequisitionHeaderView())));
    menuItems.add(MenuModel(
        icon: Icons.assignment_late,
        color: Colors.greenAccent.shade400,
        title: "Sales Invoice",
        vector: AppVectors.transaction,
        subTitle: "",
        rightFlag: "SALES_INVOICE",
        onPressed: () => BaseNavigate(context, ProductListView())));
    menuItems.add(MenuModel(
        icon: Icons.assignment_late,
        color: Color(0xFF96562D),
        title: "Pricing",
        vector: AppVectors.advance,
        subTitle: "",
        rightFlag: "PRICING_CONSOLE",
        onPressed: () => BaseNavigate(context, PricingView())
        // onPressed: () => BaseNavigate(context, ItemGrp())
        ));
    menuItems.add(MenuModel(
        color: Color(0xFF96562D),
        title: "Grading and Costing",
        vector: AppVectors.itemBox,
        subTitle: "",
        rightFlag: "GRADING_COSTING",
        onPressed: () => BaseNavigate(context, ProcessListView())));
    menuItems.add(MenuModel(
        icon: Icons.pending_actions,
        color: Colors.greenAccent.shade400,
        title: "POAcknowledgement",
        vector: AppVectors.requestFrom,
        subTitle: "",
        rightFlag: "MOBILE_PO_Acknowledgement",
        onPressed: () => BaseNavigate(context, POAcknowledgeScreen())));
    menuItems.add(MenuModel(
        // icon: Icons.location_on_outlined,
        color: Color(0xFF96562D),
        title: "Payment Voucher",
        vector: AppVectors.info,
        subTitle: "",
        rightFlag: "PAYMENT_ENTRY",
        onPressed: () => BaseNavigate(context, PaymentVoucherListScreen())));
    menuItems.add(MenuModel(
        // icon: Icons.location_on_outlined,
        color: Color(0xFF96562D),
        title: "Item Grade Rate Settings",
        vector: AppVectors.addnew,
        subTitle: "",
        rightFlag: "ITM_GRD_RATE_SETTING",
        onPressed: () => BaseNavigate(context, ItemGradeRateView())));

    menuItems.add(MenuModel(
        icon: Icons.location_on_outlined,
        color: Color(0xFF96563D),
        title: "Po-Khat",
        vector: AppVectors.addnew,
        subTitle: "",
        rightFlag: "PURCHASE_ORDER_KHAT",
        // "PURCHASE_ORDER_KHAT",
        onPressed: () => BaseNavigate(context, POKhatInitialScreen())));

    menuItems.add(MenuModel(
        icon: Icons.store,
        color: Color(0xFF96563D),
        title: "Branch Block Notification",
        // vector: AppVectors.advance,
//        publicItem: true,
        subTitle: "",
        rightFlag: "BRANCH_BLOCK_NOTIFICATION",
        onPressed: () =>
            BaseNavigate(context, BranchblockedNotificationScreen())));
    menuItems.add(MenuModel(
        icon: Icons.addchart_sharp,
        color: Color(0xFF96563D),
        title: "Notification Statistics Report",
        subTitle: "",
        rightFlag: "MOB_NOTIFY_STATISTCS_RPT",
        onPressed: () =>
            BaseNavigate(context, NotificationStatisticsReport())));
    menuItems.add(MenuModel(
        icon: Icons.addchart_sharp,
        color: Color(0xFF96563D),
        title: "Vehicle Enquiry Production Details",
        subTitle: "",
        // publicItem: true,
        rightFlag: "MOB_VEHICLE_ENQUIRY",
        onPressed: () => BaseNavigate(context, VehicleEnquiryScreen())));

    return menuItems;
  }

  StreamSubscription fcmListener;

  @override
  Future<void> onDispose(Store store) async {
    await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");
    fcmListener.cancel();
    // TODO: implement onDispose
    super.onDispose(store);
  }

  @override
  Future<void> init(Store store, BuildContext context) async {
    log("Home_page_init");
    super.init(store, context);
    SignInState state= store.state.signInState;
    tempLogin.clientId=state.clientId;
    tempLogin.userName=state.userName;
    tempLogin.password=state.password;
    tempLogin=state?.uniqueCompanyList;

    mContext = context;
    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      print('getInitialMessage data: ${message?.data}');
      _serialiseAndNavigate(message);
    });
    log("first_line_home_init");
    await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");

    fcmListener = FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      doc_key = await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";

      print("doc_key "+ doc_key);

          if (doc_key == "HOME_SCREEN") {
            print("Home Screen Listener Calling.");

      SignInState state= store.state.signInState;
      print(event);
      tempLogin=state?.uniqueCompanyList;
      if (event != null) {
        print("BLUELIME Home");
        if (tempLogin != null) store.dispatch(getMoreDetails(tempLogin));
        store.dispatch(
            fetchNotificationCount(clientid: clientId, userid: userId));
      }
          }
    });

    store.dispatch(fetchNotificationCount(clientid: clientId, userid: userId));
    if (store?.state?.salesInvoiceState?.cartItems == null) {
      store.dispatch(
          removeListItemFromCart(store.state.salesInvoiceState.cartItems));
    }

    store.dispatch(LogInAction(user: store.state.signInState.user));
    store.dispatch(BuildMainMenuAction(
        menuItems: getAllMenuItem(context),
        modules: store.state.signInState.user.moduleList));

    var android = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    await Future.delayed(Duration(seconds: 1));
    log("last_line_home_init");
    await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");
  }

  @override
  Widget childBuilder(BuildContext context, HomeViewModel viewModel) =>
      _BodyBuilder(viewModel: viewModel);

  @override
  HomeViewModel converter(store) => HomeViewModel.fromStore(store);
}

class _BodyBuilder extends StatelessWidget {
  const _BodyBuilder({
    this.viewModel,
    Key key,
  }) : super(key: key);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    // Theme theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraint) {
        final bool isLandscape = constraint.maxWidth > constraint.maxHeight;

        final _height = constraint.maxHeight -
            (isLandscape
                ? _kBottomBarHeight
                : _kBottomGridsHeight + (_kBottomBarHeight * 1.45));
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Stack(children: [
                Container(
                  height: height / 3.5,
                  width: width,
                  decoration: BoxDecoration(
                      color: ThemeProvider.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(height * .19))),
                ),
                Positioned(
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .065, horizontal: width * .04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: AppImages.logoWithoutTitle,
                          ),
                          SizedBox(
                            height: _kStatGridsHeight / 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              //   showNotification(message);
                              //  onSelectNotification("{transid: 9146, approvaloptionid: 441, optionid: 454, view: document, click_action: FLUTTER_NOTIFICATION_CLICK, transtableid: 1113}");
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.user?.companyName.toUpperCase() ??
                                      "",
                                  style: theme.title.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ("Branch     :"),
                                      style: theme.bodyHint,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      (viewModel?.user?.companyLocation ??
                                              "") ??
                                          "",
                                      style: theme.appBarTitle
                                          .copyWith(fontSize: 13),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5,
                                ),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ("Location  :"),
                                      style: theme.bodyHint,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      (viewModel.user?.locationName ?? "") ??
                                          "",
                                      style: theme.appBarTitle
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          // Text(
                          //   BaseDates(DateTime.now(),
                          //           dd: "dd", month: "MMMM", year: "yyyy")
                          //       .format,
                          //   style: BaseTheme.of(context)
                          //       .body2
                          //       .copyWith(fontSize: 13, color: Colors.white),
                          // ),
                        ],
                      ),
                    )),
              ]),
            ),
            SafeArea(
                top: false,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.2,
                      ),
                      ModuleListWidget(
                          height: height * .06, viewModel: viewModel),
                    ])),
            TopButtonBar(
              viewModel: viewModel,
              onLogout: () async {
                FirebaseNotificationHelper _firebase =
                    FirebaseNotificationHelper();
                List<String> subscribedTopics =
                    await _firebase.getSubscribedTopics();
                print("subscribed Topics");
                subscribedTopics.forEach((element) {
                  print(element);
                });

                _firebase.unsubscribeTopics(subscribedTopics);

                await BasePrefs.setString(SSNIDN_KEY, "");
                await BasePrefs.setString(USERNAME_KEY, "");
                await BasePrefs.setString(PASSWORD_KEY, "");
                await BasePrefs.setString(CLIENTID_KEY, "");
                await BasePrefs.setString(TOKEN, "");
                await BasePrefs.setString("CompanyList", "");
                await BasePrefs.setString("notifCompany", "");

                viewModel.onLogout();
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  BaseNavigate.fadeIn<void>(
                    const SplashPage(isColdStart: false),
                    name: AppRoutes.login,
                  ),
                  (Route<void> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:badges/badges.dart';
//import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/rendering.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/resources.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/login/login_viewmodel.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/payLoadModel.dart';
import 'package:redstars/src/widgets/screens/document_approval/document_approval_notification.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';
import 'package:redstars/src/constants/app_constants.dart';

import 'package:redstars/src/widgets/screens/splash/_partials/login.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/on_notification_view_page.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/view/unconfirmed_notification_page.dart';

import '../../../../utility.dart';

bool isBranchList = true;
int branchId;
var ncontext;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future onSelectedNotification(String payload) async {
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
  print('PAY LOAD VALUES $view,$transTableId');

  if (view != null) {
    if (view == 'document') {
      print('SUCCSS');

      if (approvalOptionCode == "MOB_TRAN_UNBLK_REQ_APRVL") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              ncontext,
              TransactionUnblockNotificationScreen(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                onUserClickNotification: true,
              ));
        });
      } else if (approvalOptionCode == "MOB_UNCFIRMD_TRNSCTION") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              ncontext,
              UnconfirmedNotificationPage(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                refoptionid: refoptionId,
                // isFromNotificationClick: true,
                approvalOptnName: refoptName ?? "",
              ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BaseNavigate(
              ncontext,
              DocumentApprovalNotification(
                optionId: optionId,
                transTableId: transTableId,
                transId: transId,
                approveOptionId: approvalOptionId,
                approvalOptionCode: approvalOptionCode,
                approvalOptnName: approvalOptnName,
                subTypeId: subTypeId,
              ));
        });
      }
    } else {
      print('FAILED');
    }
  }
}


class SavedCompanyDetailListPage extends StatefulWidget {
  final List<LoginModel> data;
  final String client_id;
  final List<LoginModel> uniqueList;
  final Future<void> onPressed;
  final String userId;
  final LoginViewModel viewmodel;

  const SavedCompanyDetailListPage(
      {Key key,
      this.data,
      this.client_id,
      this.uniqueList,
      this.onPressed,
      this.viewmodel,
      this.userId})
      : super(key: key);

  @override
  _SavedCompanyDetailListPageState createState() =>
      _SavedCompanyDetailListPageState(client_id, uniqueList);
}

class _SavedCompanyDetailListPageState
    extends State<SavedCompanyDetailListPage> {
  final String client_id;
  LoginModel loginDetails = LoginModel();
  List<LoginModel> uniqueList = [];
  List<LoginModel> companyList = [];
  List<LoginModel> savedCompanyList = [];
  List count=[];
  _SavedCompanyDetailListPageState(this.client_id, List<LoginModel> uniqueList);
  LoginModel userWithCompanyDetails = LoginModel();
  LoginModel tempLogin=LoginModel();
  String doc_key;
  String IsCompanyDetailInit;
  List<LoginModel> branchList = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return BaseView<AppState, LoginViewModel>(
        converter: (store) => LoginViewModel.fromStore(store),
        init: (store,context) async{
          await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "COMPANY_DETAIL_LIST");
          ncontext=context;
//          tempLogin.clientId = widget?.viewmodel?.clientId;
//          tempLogin.userName = widget?.viewmodel?.userName;
//          tempLogin.password = widget?.viewmodel?.password;

          print("Comeback");
          print("loginModel");
          print(widget.uniqueList);

//          pushNotification();

          void checkAndAddMessageListener() async {
            print("Company Detail Listener Function.");
            doc_key= await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY)??"";
            IsCompanyDetailInit = await BasePrefs.getString('IsCompanyDetailInit')??"";

            if (IsCompanyDetailInit == "") {
              await BasePrefs.setString("IsCompanyDetailInit", "true");
              print("Company Detail Listener Initilised");
              FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
                doc_key= await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY)??"";
            SignInState state = store.state.signInState;
            LoginModel login = LoginModel();
            login.clientId = state.clientId;
            login.userName = state.userName;
            login.password = state.password;
                print(doc_key);

                if (doc_key == "COMPANY_DETAIL_LIST") {
                  print("Company Detail Listener Calling.");
                  print("Company Detail Listener event. $event");

            if (event != null) {
              store.dispatch(
                  getMoreDetails(login));
                    print("Company Detail Listener refreshed.");
                  }
            }
          });
            }
          }
          checkAndAddMessageListener();

          var android = AndroidInitializationSettings('app_icon');
          var ios = IOSInitializationSettings();
          var initSettings = InitializationSettings(android: android, iOS: ios);
          flutterLocalNotificationsPlugin.initialize(initSettings,
              onSelectNotification: onSelectedNotification);
        },
        onDispose: (store) async {
          print("Company Detail List disposed.");
          await BasePrefs.setString(
              BaseConstants.SCREEN_STATE_KEY, "COMPANY_LISTING");
          // await BasePrefs.setString(BaseConstants.COMPANY_LIST_SCREEN, "COMPANY_LISTING");
          store.dispatch(
              fetchNotificationCountFromDb(loginModel: widget.uniqueList));
//          FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//            print("Branch dispose called");
//            print(event);
//            if (event != null) {
//              store.dispatch(
//                  fetchNotificationCountFromDb(loginModel: widget.uniqueList));
//            }
//          });      
  },
        builder: (context, viewModel) {
          branchList = companyList
              .where((element) => element.clientId == uniqueList)
              .toList();

          return Scaffold(
            backgroundColor: ThemeProvider.of(context).primaryColor,
            body: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 5.0,
                    decoration: BoxDecoration(
                      color: ThemeProvider.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                  top: height * .03,
                                  left: width * 0.2,
                                  right: width * 0.25,
                                  child: Image(
                                      image: AppImages.logo,
                                      fit: BoxFit.scaleDown,
                                      height: height * 0.14,
                                      width: width * 0.49))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeProvider.of(context)
                                    .scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            height: MediaQuery.of(context).size.height / 28,
                            width: MediaQuery.of(context).size.width - 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Please choose a branch to login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                //RD2199-22 deleted
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        ///for first time login null issue found for branches
                        child: viewModel.branches?.levels?.isNotEmpty ?

                        ListView.builder(
//                          List<ClientLevelDetails> branches = widget.viewModel.branches?.levels

                          itemCount:viewModel.branches?.levels?.length?? 0,

                                itemBuilder: (BuildContext context, int index) {

//                                  viewModel.notificationCountOfBranchList
//                                      .forEach((element) {
//                                    if (element.clientid ==
//                                        branchList[index].clientId) {
//                                      if (element.filterbranchid ==
//                                          branchList[index].branch.id) {
//                                        notificationCountBranch =
//                                            element.notificationcount;
//                                        branchList[index].count =
//                                            element.notificationcount;
//                                      } else {
//                                        notificationCountBranch = null;
//                                      }
//                                      return branchList;
//                                    } else if (element.clientid !=
//                                        branchList[index].clientId) {
//                                      // branchList[index].count = null;
//                                    }
//                                    return branchList;
//                                  });
                                  return GestureDetector(
                                    onTap: () {
                                      ClientLevelDetails location = viewModel.locations?.levels
                                          ?.firstWhere((val) => val.parentLevelDataId == viewModel.branches?.levels[index].id);

                                      if (viewModel.branches.levels ==
                                          null) {
                                        viewModel.login(LoginModel(
                                          userName: viewModel.userName,
                                          password: viewModel.password,
                                          clientId: viewModel.clientId,
                                          userId:
                                          viewModel.user.userId.toString(),
                                          liveClientDetails: viewModel.selectedLiveCompany,
                                        ));
                                      } else {
                                        viewModel.login(LoginModel(
                                          userName: viewModel.userName,
                                          password: viewModel.password,
                                          clientId: viewModel.clientId,
//                                          userId:
//                                              viewModel.user.userId.toString(),
                                          company: viewModel.selectedCompany,
                                          branch: viewModel.branches?.levels[index],
                                          location: location,
                                          liveClientDetails: viewModel.selectedLiveCompany,
                                        ));
                                        print(client_id);

                                      }
                                      loginDetails?.userName= viewModel.userName;
                                      loginDetails?.password= viewModel.password;
                                      loginDetails?.clientId= viewModel.clientId;
//                                        loginUser.userId= viewModel.user.userId.toString();
                                      loginDetails?.company= viewModel.selectedCompany;
                                      loginDetails?.branch= viewModel.selectedBranch;
                                      loginDetails?.location= viewModel.selectedLocation;
                                      loginDetails?.liveClientDetails= viewModel.selectedLiveCompany;
                                       _save(loginDetails,viewModel);
                                    },
//                                    onLongPress: () async {
//                                      ThemeData themeData =
//                                          ThemeProvider.of(context); //RD2199-22
//                                      final String SharedCompanyString =
//                                          await BasePrefs.getString(
//                                              'CompanyList');
//                                      final List<LoginModel>
//                                          sharedPrefCompanyList =
//                                          LoginModel.decode(
//                                              SharedCompanyString);
//                                      /* RD2199-22 starts */
//                                      showDialog(
//                                          context: context,
//                                          builder: (context) {
//                                            return AlertDialog(
//                                              backgroundColor: themeData
//                                                  .scaffoldBackgroundColor,
//                                              title: Text(
//                                                  "Are you sure you want to Delete this?"),
//                                              actions: [
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceAround,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: [
//                                                    BaseRaisedButton(
//                                                        child: Row(
//                                                          children: [
//                                                            Text("Yes"),
//                                                          ],
//                                                        ),
//                                                        onPressed: () {
//                                                          setState(() {
//                                                            sharedPrefCompanyList
//                                                                .removeWhere((element) =>
//                                                                    element
//                                                                        .branch
//                                                                        .name ==
//                                                                    branchList[
//                                                                            index]
//                                                                        .branch
//                                                                        .name);
//                                                            branchList.removeAt(
//                                                                index);
//                                                            companyList =
//                                                                branchList;
//                                                            final String
//                                                                encodedData =
//                                                                LoginModel.encode(
//                                                                    sharedPrefCompanyList);
//                                                            BasePrefs.setString(
//                                                                'CompanyList',
//                                                                encodedData);
//                                                            if (branchList
//                                                                    .isEmpty &&
//                                                                branchList ==
//                                                                    null) {
//                                                              isBranchList =
//                                                                  false;
//                                                            }
//                                                            widget.onPressed;
//                                                            Navigator.pop(
//                                                                context,
//                                                                isBranchList);
//                                                            // return branchList;
//                                                          });
//                                                        }),
//                                                    BaseRaisedButton(
//                                                        child: Row(
//                                                          children: [
//                                                            Text("No"),
//                                                          ],
//                                                        ),
//                                                        onPressed: () {
//                                                          Navigator.pop(
//                                                              context);
//                                                        }),
//                                                  ],
//                                                ),
//                                              ],
//                                            );
//                                          });
//                                      /* RD2199-22 ends */
//                                    },
                                      child: new Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      color: themeData.scaffoldBackgroundColor,
                                        margin: EdgeInsets.all(10),
                                        child: new Row(
                                          children: <Widget>[
                                            //new Image.network(video[index]),
                                            new Padding(
                                              padding: new EdgeInsets.all(3.0)),

                                            Flexible(
                                              flex: 2,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                decoration: BoxDecoration(
                                                    color: ThemeProvider.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: CircleAvatar(
                                                      backgroundColor: themeData
                                                          .primaryColor,
                                                    radius: 25,
                                                    child: Icon(
                                                      Icons.home_work,
                                                      size: 30,
                                                        color: themeData
                                                            .accentColor,
                                                    ),
                                                  ),
                                                ),
                                                ),
                                                Visibility(
                                                  visible: viewModel.branches.levels[index].notificationcount!=null,
                                                    child: Positioned(
                                                      left: 4,
                                                      top: 4,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        margin:
                                                            EdgeInsets.all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            viewModel.branches.levels[index].notificationcount??"0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                              ),
                                            ),
                                            //
//                                                      /* RD2199-22 starts */
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                viewModel.branches.levels[index].name ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                    "No Company is available, \nPlease Save to Continue...")))),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    SizedBox(
//                      width: 40,
//                    ),
//                    Text("Long press to delete branch"),
//                  ],
//                ),
                SizedBox(
                  height: 25,


                )
              ],
            ),
          );
        });

  }
  _save(LoginModel loginUser, LoginViewModel viewmodel) async {
//    loginFormKey.currentState

//     viewmodel.getBusinessDetailss(loginUser); //RD2199-22
//    final FormState form = _loginFormKey.currentState;
//    final __BusinessLevelsState levelsState = _businessLevelKey.currentState;
//    if (form.validate()) {
//      form.save();
      final String SharedCompanyString =
      await BasePrefs.getString('CompanyList');
      if (viewmodel.isExpanded) {
        print("MSSSSS");
        print(viewmodel.locations.userId);
        // viewmodel.saveCredentials(loginUser.merge(levelsState.onSubmit()));
        userWithCompanyDetails = LoginModel(
          clientId: loginUser.clientId,
          userName: loginUser.userName,
          password: loginUser.password,
          liveClientDetails:
          loginUser?.liveClientDetails ?? viewmodel.selectedLiveCompany,
          userId: viewmodel.locations.userId.toString(),
          branch: loginUser.branch,
          location: loginUser.location,
          company: loginUser.company,
        ).merge(LoginModel( clientId: loginUser.clientId,
          userName: loginUser.userName,
          password: loginUser.password,
          liveClientDetails:
          loginUser?.liveClientDetails ?? viewmodel.selectedLiveCompany,
          userId: viewmodel.locations.userId.toString(),
        branch: viewmodel.selectedBranch,
        company: viewmodel.selectedCompany,
        location: viewmodel.selectedLocation));
        print("MSSSSS");
        print(viewmodel.locations.userId);
      } else {
        print("Enters");
        print(viewmodel.locations.userId);
        userWithCompanyDetails = LoginModel(
            clientId: loginUser.clientId,
            userName: loginUser.userName,
            password: loginUser.password,
            userId: viewmodel.locations.userId.toString(),
            branch: null,
            location: null,
            company: null,
            liveClientDetails: loginUser.liveClientDetails);
        /* RD2199-22 ends */
      }
      savedCompanyList = [];
      if (SharedCompanyString.isNotEmpty && SharedCompanyString != "[]") {
        final List<LoginModel> sharedPrefCompanyList =
        LoginModel.decode(SharedCompanyString);
        print(sharedPrefCompanyList.length);
        List SharedClientList = [];
        bool duplicateCompanyFlag = false;
        if (sharedPrefCompanyList.length > 0) {
          sharedPrefCompanyList.forEach((element) {
            print("sharedPrefCompanyList list  ${element.clientId} ${element.userName}");

            SharedClientList.add(element.clientId);
            SharedClientList.add(element.company.name);
            SharedClientList.add(element.branch.name); //RD2199-22


              if (element.clientId == userWithCompanyDetails.clientId) {
                duplicateCompanyFlag = true;
                sharedPrefCompanyList.remove(element);
                savedCompanyList = sharedPrefCompanyList;
                savedCompanyList.add(userWithCompanyDetails);
              }

            /* RD2199-22 starts */
          });
          // if (SharedClientList.contains(userWithCompanyDetails?.branch?.name) ||
          //     SharedClientList.contains(userWithCompanyDetails.company.name))
          if (duplicateCompanyFlag == true) {
            print("dup true");

            // savedCompanyList.add(loginUser123);
          } else {
            print("dup false");
            savedCompanyList = sharedPrefCompanyList;
            savedCompanyList.add(userWithCompanyDetails);
            // addToCompanyListFlag = false;
          }
        }
      } else {
        savedCompanyList.add(userWithCompanyDetails);
        // addToCompanyListFlag = false;
      }

      /* RD2199-22 ends */
      final String encodedData = LoginModel.encode(savedCompanyList);
      BasePrefs.setString('CompanyList', encodedData);
      viewmodel.resetIsExpanded();
    }
  }



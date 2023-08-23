import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/data_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/transaction_unblock_view_list_screen.dart';
import 'package:redstars/utility.dart';
import 'model/branch_model.dart';
import 'package:redstars/src/constants/app_constants.dart';


class TransactionUnblockApprovalPendingViewScreen extends StatefulWidget {
  final int branchId;
  final bool isBranchBlocked;
  final String branchname;
  final bool fromBlocked;
  final bool isUserRightToApprove;
  final int optionId;

  const TransactionUnblockApprovalPendingViewScreen(
      {Key key,
      this.branchId,
      this.isBranchBlocked,
      this.branchname,
      this.fromBlocked,
      this.optionId,
      this.isUserRightToApprove})
      : super(key: key);

  @override
  _TransactionUnblockApprovalPendingViewScreenState createState() =>
      _TransactionUnblockApprovalPendingViewScreenState();
}

class _TransactionUnblockApprovalPendingViewScreenState
    extends State<TransactionUnblockApprovalPendingViewScreen> {
  int branchopt;
  String brchNamedisplay;
  String brchNamedisplay2;
  List<List<DataModel>> dtlTransList = [];
int optionId;
int optionId2;
int optionId3;
  List<BranchesList> wholeBranchList = [];
  List<BranchesList> wholeBranchList2 = [];
  String doc_key;
  String isTransUnblockInit;
  int notifyBranch;
  bool allBranchYN;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
          onDispose: (store) async {
          String clientId =
              await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
            int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
            store.dispatch(
                fetchNotificationCount(clientid: clientId, userid: userId));

          store.dispatch(ClearTURPScreen());
	  await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");

          },


        init: (store, context) async {
          await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "MOB_TRAN_UNBLK_REQ_APRVL");

          int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
          log("branch id at page level is " + branchId.toString());
          allBranchYN =
              store.state.transactionUnblockReqApprlState.isAllBranchSelected;
         optionId = store.state.homeState.selectedOption.optionId;
          store.dispatch(ChangeBranchId(branch: branchId, branchName: store.state.homeState.user.companyLocation));
          final optionId2 = store.state.homeState.menuItems.indexWhere(
              (element) =>
                  element.title == "Transaction Unblock Request Approval");
          if (optionId2 != null && optionId2 > 0) {
            print("else part5");
            optionId3 =
              store.state.homeState.menuItems[optionId2].module.optionId;
          if (widget?.isBranchBlocked ?? false) {
            store.dispatch(
              fetchTransactionApprovalMainscreen(
                    optionId: optionId3 ?? widget.optionId,
                    branchId: widget.branchId ?? branchId),
            );
          } else {
              store.dispatch(fetchTransactionApprovalMainscreen(
                  optionId: optionId3 ?? widget.optionId ?? optionId,
                  branchId: widget.branchId ?? branchId));
            }
          } else {
            print(
                "User has no rights to access Transaction Unblock Request Approval");
            if (optionId2 != null && optionId2 > 0)
              optionId3 =
                  store.state.homeState.menuItems[optionId2].module.optionId;
            if (widget?.isBranchBlocked ?? false) {
              print("else part3");
              store.dispatch(
                fetchTransactionApprovalMainscreen(
                    optionId: optionId3 ?? widget.optionId ?? optionId,
                    branchId: widget?.branchId ?? branchId),
              );
            } else {
              print("else part2");
              store.dispatch(
                fetchTransactionApprovalMainscreen(
                    optionId: optionId3 ?? widget.optionId ?? optionId,
                    branchId: widget.branchId ?? branchId),
              );
            }
          }
          store.dispatch(fetchUnreadCount(
              branchId2: store.state.transactionUnblockReqApprlState?.branch ??
                  branchId,
              allBranchYN: store.state.transactionUnblockReqApprlState.isAllBranchSelected));
          store.dispatch(fetchActionTypes());
          store.dispatch(fetchFilterBranches());
          // store.dispatch(fetchHistoryData());
          branchopt = null;
          brchNamedisplay =
              store.state.homeState.user.companyLocation ?? "All Branches";
          brchNamedisplay2 = widget?.branchname;
          print("Option ID : $optionId");
          print("Option ID2: $optionId2");

          void checkAndAddMessageListener() async {
            print("Trans Approval Listener Function.");
            doc_key= await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY)??"";
            isTransUnblockInit = await BasePrefs.getString('isTransUnblockInit')??"";

            if (isTransUnblockInit == "") {
              await BasePrefs.setString("isTransUnblockInit", "true");

              print("Trans Approval Listener Initilised");
          FirebaseMessaging.onMessage.listen((RemoteMessage event) async{
                doc_key= await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY)??"";
                print(doc_key);

                if (doc_key == "MOB_TRAN_UNBLK_REQ_APRVL") {
                  print("Trans Approval Listener Calling.");
                  print("Trans Approval Listener event. $event");

            if (event != null) {
              notifyBranch = store.state.transactionUnblockReqApprlState.branch;
              log("current branch id on notify true is $notifyBranch");
              print("BLUELIME Here");
              store.dispatch(fetchUnreadCount(
                  branchId2:
                      store.state.transactionUnblockReqApprlState?.branch,
                  allBranchYN: store.state.transactionUnblockReqApprlState.isAllBranchSelected));
             optionId = store.state.homeState.selectedOption.optionId;

             final optionId2 = store.state.homeState.menuItems.indexWhere(
                     (element) =>
                 element.title == "Transaction Unblock Request Approval");
             if (optionId2 != null && optionId2 > 0) {
               print("else part5");
                optionId3 =
                    store.state.homeState.menuItems[optionId2].module.optionId;
               if (widget?.isBranchBlocked ?? false) {
                  log("one");
                 store.dispatch(
                   fetchTransactionApprovalMainscreen(
                       optionId: optionId3 ?? widget.optionId,
                        branchId: widget.branchId ??
                            store.state.transactionUnblockReqApprlState
                                ?.branch ??
                            8),
                 );
               } else {
                 store.dispatch(
                   fetchTransactionApprovalMainscreen(
                      optionId: optionId3 ?? widget.optionId ?? optionId,
                      branchId: notifyBranch,
                      allBranch: store.state.transactionUnblockReqApprlState.isAllBranchSelected,
                    ),
                  );
               }
             } else {
                print(
                    "User has no rights to access Transaction Unblock Request Approval");
               if (optionId2 != null && optionId2 > 0)
                  optionId3 = store
                      .state.homeState.menuItems[optionId2].module.optionId;
               if (widget?.isBranchBlocked ?? false) {
                 print("else part3");
                 store.dispatch(
                   fetchTransactionApprovalMainscreen(
                       optionId: optionId3 ?? widget.optionId ?? optionId,
                       branchId: widget?.branchId),
                 );
               } else {
                 print("else part2");
                 store.dispatch(
                   fetchTransactionApprovalMainscreen(
                        optionId: optionId3 ?? widget.optionId ?? optionId,
                        branchId: widget.branchId ??
                            store.state.transactionUnblockReqApprlState
                                ?.branch ??
                            10),
                 );
               }
             }
              store.dispatch(fetchUnreadCount(
                  branchId2:
                      store.state.transactionUnblockReqApprlState?.branch,
                  allBranchYN: store.state.transactionUnblockReqApprlState.isAllBranchSelected));
             store.dispatch(fetchActionTypes( ));
             store.dispatch(fetchFilterBranches( ));
             // store.dispatch(fetchHistoryData());
             branchopt = null;
              brchNamedisplay =
                  store.state.transactionUnblockReqApprlState.branchName;
             brchNamedisplay2 = widget?.branchname;
                print("Option ID : $optionId");
                print("Option ID2: $optionId2");
           }
                }
              });
            }
          }
          checkAndAddMessageListener();

          // print("Option ID3: $optionId3");
        },
        converter: (store) =>
            TransactionUnblockReqApprlViewModel.fromStore(store),
        appBar: BaseAppBar(
          actions: [
            // IconButton(
            //     onPressed: () {
            //       BaseNavigate(context, TransactionHistoryPage());
            //     },
            //     icon: Icon(Icons.access_time)),
          ],
          title: Text(
            "Transaction Unblock Request Approval",
          ),
          elevation: 0,
        ),
        builder: (context, viewModel) {
          print("selected OptionId: ${viewModel.optionId3}");
          return Column(
              // fit: StackFit.expand,
              children: [
                Column(children: [
                  // Text(viewModel.historyData.first.createduser),
                  GestureDetector(
                    onTap: ( ) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              backgroundColor: themeData.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              //this right here
                              child: Container(
                                height: 480,
                                child: Column(children: [
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Branch:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      ]),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            viewModel?.branchObjList?.length ??
                                                0,
                                        //  viewModel.pendingList.length,
                                        // itemCount: 20,
                                        itemBuilder:
                                            (BuildContext context, int num) {
                                              int unreadCount = 6;
                                              return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                branchopt = num;
                                                print("Branchhhh ${branchopt}");
                                                String data = viewModel
                                                        ?.branchObjList[num]
                                                        ?.name ??
                                                    "All Branches";
                                                bool allBranchYN;
                                                print(data);
                                                brchNamedisplay = data;
                                                brchNamedisplay2 = data;
                                                print(brchNamedisplay);

                                                viewModel.filterByBranch(
                                                  flg: 1,
                                                  branchId: viewModel
                                                      ?.branchObjList[branchopt]
                                                      ?.id,
                                                  optionId:
                                                      viewModel?.optionId3 ??
                                                          widget.optionId ??
                                                          optionId2 ??
                                                          optionId,
                                                );
                                                data == "All Branches"
                                                    ? allBranchYN = true
                                                    : allBranchYN = false;

                                                viewModel
                                                    .fetchUnreadCountFunction(
                                                        branchId: viewModel
                                                            ?.branchObjList[
                                                                branchopt]
                                                            ?.id,
                                                        allBranchYN:
                                                            allBranchYN);
//                                                vie
//                                                wModel.pendingList.isEmpty
//                                                    ? " ": viewModel.searchByUser(viewModel.userObjects[num].id);

//                                          : BaseNavigate(context, UnblockRequestScreen(id: viewModel.userObjects[index].id,));
                                                log("view model count is ${viewModel?.branchObjList[num]?.id}");
                                                if (data == "All Branches") {
                                                  viewModel.changeBranch(null,
                                                      true, "All Branches");
                                                } else {
                                                  viewModel.changeBranch(
                                                      viewModel
                                                          ?.branchObjList[num]
                                                          ?.id,
                                                      false,
                                                      viewModel
                                                          ?.branchObjList[num]
                                                          ?.name);
                                                }

                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: themeData
                                                          .primaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: themeData
                                                              .primaryColorDark,
                                                          blurRadius: 5.0,
                                                          offset: Offset(2, 4),
                                                        ),
                                                      ]),
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      18),
                                                          child: _CircleAvatar(
                                                            icon: Icons
                                                                .account_circle_outlined,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 30,
                                                          child: Text(viewModel
                                                                  ?.branchObjList[
                                                                      num]
                                                                  ?.name ??
                                                              ""),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      18),
//                                                              child: Text((index +
//                                                                      1)
//                                                                  .toString()),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          );
                                        }),
                                  )
                                ]),
                              ),
                            );
                          });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 5, bottom: 5, top: 5),
                              child: Container(
//                color: Colors.red,
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: themeData.primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Icon(
                                          Icons.filter_list,
                                          color: Colors.white,
                                        )),
                                    Flexible(
                                        child: Text(widget.fromBlocked == true
                                                ? brchNamedisplay2 ??
                                                    widget?.branchname ??
                                                    ""
                                                : brchNamedisplay ??
                                                    widget?.branchname ??
                                                    ""
                                        // brchNamedisplay ??
                                        //             widget.branchname
                                            )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 18),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            fontFamily: "Roboto-Medium"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: [
                        Icon(
                          Icons.home_repair_service_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Pending Transactions",
                          style: TextStyle(
                              fontFamily: "Roboto-Medium",
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  )
                ]),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: (viewModel?.tranansctionScreenDetl?.isNotEmpty ??
                                  false) &&
                              (viewModel?.tranansctionScreenDetl != null)
                          ? ListView.builder(
                              itemCount:
                                  viewModel?.tranansctionScreenDetl?.length ??
                                      0,
                              itemBuilder: (context, int index) {
                                int unreadCount;
                                print(viewModel.idOption);
                                viewModel.unreadCount.forEach((element) {
                                  if (element.notificationoptionid ==
                                      viewModel.idOption) {
                                    if (element.unblockrequestnotificationid ==
                                        viewModel?.tranansctionScreenDetl[index]
                                            .id) {
                                      unreadCount = element.notificationcount;
                                    }
                                  }
                                });
                                return GestureDetector(
                                    onTap: ( ) {
                                      print("Option ID : $optionId");
                                      print("Option ID2: $optionId2");
                                      print("Option ID3: $optionId3");
                                      print("Option ID3: ${widget.optionId}");
                                      print("branchID : ${viewModel.branch}");
                                      log("is all branch selected at main screen" +
                                          viewModel.isAllBranchSelected
                                              .toString());

                                      (widget?.fromBlocked ?? false) == true
                                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionUnblockApprovalDetailScreen(optionIdFromBranchBlock: widget.optionId, flg: branchopt == null ? 0 : 1, branchId: branchopt == null ? widget?.branchId : viewModel?.branchObjList[branchopt]?.id, optionId: viewModel?.optionId3, id: viewModel?.tranansctionScreenDetl[index]?.id, reportFormtId: viewModel?.tranansctionScreenDetl[index]?.reportengineformatid, start: 0, viewModel: viewModel, title: viewModel?.tranansctionScreenDetl[index]?.title, isBranchBlocked: widget?.isBranchBlocked ?? false, isUserRightToApprove: widget.isUserRightToApprove))).then((value) =>
                                              {
                                            viewModel.Refresh(
                                                isBranchBlocked:
                                                        widget?.isBranchBlocked,
                                                    optionId:
                                                        viewModel?.optionId3 ??
                                                            optionId3 ??
                                                            widget.optionId ??
                                                            optionId ??
                                                            optionId2,
                                                    branchId: widget?.branchId),
                                      branchopt = null,
                                                brchNamedisplay =
                                                    "All Branches",
                                                brchNamedisplay2 =
                                                    widget?.branchname,
                                      print("Option ID : $optionId"),
                                          print("Option ID2: $optionId2"),
                                      print("Option ID3: $optionId3"),
                                                print(
                                                    "Option ID3: ${widget.optionId}"),
                                              })
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TransactionUnblockApprovalDetailScreen(
                                                      allBranchYN: viewModel
                                                          .isAllBranchSelected,
                                              optionIdFromBranchBlock:
                                              optionId,
                                                      flg: branchopt == null
                                                          ? 0
                                                          : 1,
                                              branchId: branchopt == null
                                                          ? viewModel.branch
                                                  : viewModel
                                                  ?.branchObjList[
                                              branchopt]
                                                  ?.id,
                                                      optionId:
                                                          viewModel.optionId3 ??
                                                  widget.optionId ??
                                                  optionId ??
                                                  optionId2,
                                                      id: viewModel?.tranansctionScreenDetl[index]?.id,
                                              reportFormtId: viewModel?.tranansctionScreenDetl[index]?.reportengineformatid,
                                              start: 0,
                                              viewModel: viewModel,
                                              title: viewModel?.tranansctionScreenDetl[index]?.title,
                                              isBranchBlocked: widget?.isBranchBlocked,
                                                      isUserRightToApprove: widget.isUserRightToApprove)));
                                    },
                                    child: Container(
                                        child: Material(
                                            type: MaterialType.transparency,
                                            child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .12,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: themeData
                                                          .primaryColor),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        18),
                                                            child: Stack(
                                                              clipBehavior:
                                                                  Clip.none,
                                                              children: [
                                                                _CircleAvatar(
                                                              icon: Icons
                                                                    .description,
                                                                ),
                                                                Visibility(
                                                                    visible:
                                                                        unreadCount !=
                                                                            null,
                                                                    child:
                                                                        Positioned(
                                                                      left: -5,
                                                                      top: -8,
                                                                      child: Visibility(
                                                                          visible: unreadCount != null,
                                                                          child: Container(
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                            margin:
                                                                                EdgeInsets.all(2),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "$unreadCount",
                                                                                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
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
                                                              viewModel
                                                                      ?.tranansctionScreenDetl[
                                                                      index]
                                                                      ?.title ??
                                                                  "",
                                                              style: style.subhead1.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        18),
                                                            child: Text(
                                                              (viewModel?.tranansctionScreenDetl[index]
                                                                          ?.count ??
                                                                      "")
                                                                  .toString(),
                                                              style: style.subhead1.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )))));
                              })
                          : (viewModel.tranansctionScreenDetl?.isEmpty ??
                                      false) &&
                                  (viewModel.statusCode == 1)
                              ? _EmptyListView()
                              : Center(
                                  child: BaseLoadingView(
                                    message: "Loading",
                                  ),
                                )),
                ),
              ]);
        });
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

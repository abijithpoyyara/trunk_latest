//import 'dart:html';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request/transaction_unblock_request_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/user_object.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request/transaction_unblock_Req_listView.dart';

class TranUnblkRequestScreen extends StatefulWidget {
  int flag;
  int branchId;
  String title;
  bool type;
  final bool isUserRightToApprove;
  TranUnblkRequestScreen(
      {Key key,
      this.flag,
      this.branchId,
      this.title,
      this.type,
      this.isUserRightToApprove})
      : super(
          key: key,
        );

  @override
  _TranUnblkRequestScreenState createState() => _TranUnblkRequestScreenState();
}

class _TranUnblkRequestScreenState extends State<TranUnblkRequestScreen> {
  var items = [];
  int isSearching = 0;
  int usropt;
  int branchopt;
  int selopt;
  int startt;
  String usrNamedisplay;
  String brchNamedisplay;
  String userName;
int flag;
  bool allbranchSelct=false;
  @override
  Widget build(BuildContext context) {
//    TextEditingController editingController = TextEditingController();
    ThemeData themeData = ThemeProvider.of(context);
    List<BranchesList>a;

    return BaseView<AppState, TranUnblockReqViewmodel>(
      init: (store, context) {
//        int userId = await BasePrefs.getInt(USERID_KEY);
          final optionId = store.state.homeState.selectedOption.optionId;
if(widget.flag==1) {
  store.dispatch(fetchBranchNotificaion_TransactionReqinitList(
      branchId: widget.branchId));
  startt = 1;
        } else {
  store.dispatch(fetchTransactionReqinitList(optionId: optionId));
  store.dispatch(fetchFilterUsers());
  store.dispatch(fetchFilterBranches());
  store.dispatch(fetchActionTakenAgainstwhom());

  usropt = null;
  branchopt = null;
  selopt = null;
  startt = 0;
          usrNamedisplay = store.state.homeState.user.userName == "ADMIN"
              ? ""
              : store.state.homeState.user.userName;
  brchNamedisplay = "All Branch";
        }
        userName = store.state.homeState.user.userName;
      },
//      onDidChange:
//          (viewModel, context) {

//        if (viewModel.loading == true) {
//          showSuccessDialog(context, "Saved Successfully", "Success", () {
//viewModel.restLoading();
//          });
//        }
//      },
    converter: (store) => TranUnblockReqViewmodel.fromStore(store),
      appBar: BaseAppBar(
        title: widget.flag == 1
            ? Text(
          "Pending Transaction", //RD2111-22
          style: TextStyle(fontFamily: "Roboto-Medium"),
              )
            : Text(
          "Transaction Unblock Request",
          style: TextStyle(fontFamily: "Roboto-Medium"),
        ),
//        actions: [
//          IconButton(onPressed: (){
//            BaseNavigate(context, Sales());
//          }, icon: Icon(Icons.list))
//        ],
        elevation: 10,
      ),
      builder: (context, viewModel) {
//        if(userName!="ADMIN"){
//        viewModel.userObjects.forEach((a) {
//          if (a.name ==userName ) {
//            usropt = a.id;
//          }
////          return selectedPurchaser;
//        });};

//
    return RefreshIndicator(
        displacement: 20,
          onRefresh: (){
            if (widget.flag == 1) {
            } else {
            usropt = null;
            branchopt = null;
            selopt = null;
            startt = 0;
            usrNamedisplay = userName=="ADMIN"?"":userName;
            brchNamedisplay = "All Branch";
            viewModel.refreshmainscreen();
          }
          },
          child: Container(
            child: Column(
              children: [
                Visibility(
                    visible:widget.flag==1,
                    child:Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                        decoration: BoxDecoration(
//                            color: themeData.primaryColor,
//                            borderRadius: BorderRadius.circular(12)),

                        child: Text(
                          "${widget.title}  :",
                          style: BaseTheme.of(context).body2Medium,
                        ),
                      ),
                    ) ),
                Visibility(
                  visible: widget.flag!=1,
                  child: GestureDetector(
                    onTap: () {
                      print("aaaa ${userName}");
                      if(userName=="ADMIN"){
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
                                        Text("Users:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      ]),
                                  Expanded(
                                    child: ListView.builder(
                                          itemCount:
                                              viewModel.userObjects.length,
                                        //  viewModel.pendingList.length,
                                        // itemCount: 20,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                usropt = index;
                                                print("user- ${usropt}");
                                                setState(() {
                                                  usrNamedisplay = viewModel
                                                        .userObjects[index]
                                                        .name;
                                                });

//                                                  viewModel.pendingList.isEmpty
//                                                      ? " ": viewModel.searchByUser(viewModel.userObjects[index].id);
//                                          : BaseNavigate(context, UnblockRequestScreen(id: viewModel.userObjects[index].id,));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  height: 70,
                                                    width:
                                                        MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: themeData
                                                            .primaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: themeData
                                                              .primaryColorDark,
                                                          blurRadius: 5.0,
                                                            offset:
                                                                Offset(2, 4),
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
                                                            child:
                                                                _CircleAvatar(
                                                            icon: Icons
                                                                .account_circle_outlined,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 30,
                                                          child: Text(viewModel
                                                                    ?.userObjects[
                                                                        index]
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
                      }
                      ;
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 5, top: 5),
                              child: Container(
//                color: Colors.red,
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: themeData.primaryColor,
//                                    boxShadow: [
//                                      BoxShadow(
//                                        color: themeData.buttonColor,
//                                        blurRadius: 5.0,
//                                        offset: Offset(2, 4),
//                                      ),
//                                    ]
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
//                                  usropt!=null? Text("${viewModel.userObjects[usropt].name}"):Text("}"),

                                    Flexible(child: Text(usrNamedisplay??"")),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 18),
                                      child: Text(
                                        "User",
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
                ),
                Visibility(
                  visible: widget.flag!=1,
                  child: GestureDetector(
                    onTap: () {
                      (allbranchSelct == false)
                          ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              backgroundColor: themeData.primaryColor,
                              shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      ]),
                                  Expanded(
                                    child: ListView.builder(
                                            itemCount:
                                                viewModel.branchObjList.length,
                                        //  viewModel.pendingList.length,
                                        // itemCount: 20,
                                            itemBuilder: (BuildContext context,
                                                int num) {
                                          return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                branchopt = num;
                                                    print(
                                                        "Branchhhh ${branchopt}");
                                                setState(() {
                                                      brchNamedisplay =
                                                          viewModel
                                                              .branchObjList[
                                                                  num]
                                                              .name;
                                                      if (brchNamedisplay ==
                                                          "All Branches") {
                                                    allbranchSelct=true;
                                                          branchopt=null;
                                                  }
                                                });
//                                                viewModel.pendingList.isEmpty
//                                                    ? " ": viewModel.searchByUser(viewModel.userObjects[num].id);

//                                          : BaseNavigate(context, UnblockRequestScreen(id: viewModel.userObjects[index].id,));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  height: 70,
                                                      width:
                                                          MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: themeData
                                                              .primaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: themeData
                                                              .primaryColorDark,
                                                          blurRadius: 5.0,
                                                              offset:
                                                                  Offset(2, 4),
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
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          18),
                                                              child:
                                                                  _CircleAvatar(
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
                                                                      vertical:
                                                                          8,
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
                          })
                          :{};
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 5, top: 5),
                              child: Container(
//                color: Colors.red,
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: themeData.primaryColor,
//                                    boxShadow: [
//                                      BoxShadow(
//                                        color: themeData.buttonColor,
//                                        blurRadius: 5.0,
//                                        offset: Offset(2, 4),
//                                      ),
//                                    ]
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
                                        child: Text(brchNamedisplay ?? "")),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 18),
                                      child: Text(
                                        "Branch",
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
                ),
                Visibility(
                  visible: widget.flag!=1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 31),
                              child: Icon(
                                Icons.home_repair_service_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Text(
                                "Pending Transactions:",
                                style: TextStyle(
                                    fontFamily: "Roboto-Medium",
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                            child: Container(
                              child: Center(
                                  child: Text(
                                " Search ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                color: themeData.primaryColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onTap: () {
                              startt = 1;
                              if (usropt == null && branchopt != null) {
                                selopt = 1;
                                print("v ${selopt}");
                                 if(userName=="ADMIN"){
                                viewModel.searchByUser(
                                    selopt: selopt,
                                      branchId:
                                          viewModel.branchObjList[branchopt].id,
                                    optionId: viewModel.optionId);
                                } else {
                                   selopt = 2;
                                   print("selopt${selopt}");
                                   viewModel.searchByUser(
                                       userId: viewModel.userId,
                                       selopt: selopt,
                                      branchId:
                                          viewModel.branchObjList[branchopt].id,
                                       optionId: viewModel.optionId);
                                 }

//                                          : BaseNavigate(context, UnblockRequestScreen(id: viewModel.userObjects[index].id,));
                              }
                              if (usropt != null && branchopt != null) {
                                selopt = 2;
                                print("selopt${selopt}");
                                viewModel.searchByUser(
                                    userId: viewModel.userObjects[usropt].id,
                                    selopt: selopt,
                                    branchId:
                                        viewModel.branchObjList[branchopt].id,
                                    optionId: viewModel.optionId);
                              }
                              if(allbranchSelct==true){
                                if(usropt==null){
                            viewModel.allBranchFilter(
                              optionId: viewModel.optionId,
                                      allbranBYUser: false);
                                } else {
                                  viewModel.allBranchFilter(
                                      userId: viewModel.userObjects[usropt].id,
                                      allbranBYUser:true,
                                    optionId: viewModel.optionId,
                                  );
                                }
                              } else {
                                  print("error");
                                }
                            }),
                      )
                    ],
                  ),
                ),
                Flexible(
//                  flex: 4,
                  child: Container(
                    child: viewModel.pendingList.length != null
                        ? ListView.builder(
                              itemCount: viewModel.pendingList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                     if(widget.flag==1) {
                                      print(widget?.isUserRightToApprove);
                                       viewModel.getDtl(
                                           viewModel.pendingList[index]
                                               .reportengineformatid,
                                           viewModel.pendingList[index].id,
                                           startt,
                                           widget.branchId,
                                           viewModel.optionId);

                                       BaseNavigate(
                                           context,
                                           TransactionReqViewList(
                                             optionId: viewModel.optionId,
                                              id: viewModel
                                                  .pendingList[index].id,
                                             reportFormtId: viewModel
                                                 .pendingList[index]
                                                 .reportengineformatid,
                                             st: startt,
                                             branchId: widget.branchId,
                                             reqTitle: viewModel
                                                 .pendingList[index].title,
                                             flag: widget.flag,
                                              isUserRightToApprove: widget
                                                      ?.isUserRightToApprove ??
                                                  false));
                                    } else {
                                      print(widget?.isUserRightToApprove);
                                       viewModel.getDtl(
                                           viewModel.pendingList[index]
                                               .reportengineformatid,
                                           viewModel.pendingList[index].id,
                                           startt,
                                           branchopt != null
                                               ? viewModel
                                               .branchObjList[branchopt].id
                                               : 0,
                                           viewModel.optionId);

                                       BaseNavigate(
                                           context,
                                           TransactionReqViewList(
                                             optionId: viewModel.optionId,
                                            id: viewModel.pendingList[index].id,
                                             reportFormtId: viewModel
                                                 .pendingList[index]
                                                 .reportengineformatid,
                                             st: startt,
                                             branchId: branchopt != null
                                                 ? viewModel
                                                 .branchObjList[branchopt].id
                                                 : 0,
                                             reqTitle: viewModel
                                                 .pendingList[index].title,
                                             flag: widget.flag,
                                            isUserRightToApprove:
                                                widget?.isUserRightToApprove ??
                                                    false,
                                           ));
                                     }
//                                    usropt = null;
//                                    branchopt = null;
//                                    selopt = null;
//                                    startt = 0;
//                                    usrNamedisplay = "";
//                                    brchNamedisplay = "All Branch";
//                                    flag=0;
                                    },
                                  child: Container(
//                                            margin: EdgeInsets.symmetric(
//                                                vertical: 2, horizontal: 10),
//                                            height:  MediaQuery.of(context).size.height * .12,
//                                            width:  MediaQuery.of(context).size.width,
                                          height: 100,
                                          width: MediaQuery.of(context).size.width /
                                              2.5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: themeData.primaryColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: themeData.primaryColorDark,
                                                  blurRadius: 5.0,
                                                  offset: Offset(2, 4),
                                                ),
                                              ]),
                                          child: viewModel.pendingList.isNotEmpty
                                              ? Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 8,
                                                                horizontal: 18),
                                                        child: _CircleAvatar(
                                                          icon: Icons.home,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 30,
                                                        child: Text(viewModel
                                                            ?.pendingList[index]
                                                            ?.title ??
                                                        ""),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 8,
                                                                horizontal: 18),
                                                        child: Text((viewModel
                                                                ?.pendingList[
                                                                    index]
                                                                ?.count ??
                                                            0)
                                                            .toString()),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : _EmptyListView),
                                  ),
                                );
                              })
                        : Expanded(
                            child: Center(
                            child: Text(
                              "no data ",
                              style: TextStyle(fontSize: 30),
                            ),
                          )),
                      ),
                ),
              ],
            ),
          ),
        );
        EmptyResultView();
      },
    );
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

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/branch_blocked_notification/branch_blocked_notification_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/branch_blocked_notification/branch_blocked_notification_viewmodel.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request/pending_transactions_list.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/transaction_unblock_req_appvl_main_screen.dart';

class BranchblockedNotificationScreen extends StatefulWidget {
  const BranchblockedNotificationScreen({Key key}) : super(key: key);

  @override
  _BranchblockedNotificationScreenState createState() =>
      _BranchblockedNotificationScreenState();
}

class _BranchblockedNotificationScreenState
    extends State<BranchblockedNotificationScreen> {
  bool checkUserRight;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
//List <BLockedNotificaionList> blkdata;
//    List <BLockedNotificaionList> wardata;
    int optionId;

    return BaseView<AppState, BlockedNotificationViewmodel>(
        isShowErrorSnackBar: false,
        init: (store, context) {
          optionId = store.state.homeState.selectedOption.optionId;
          store.dispatch(fetchBlockedNotification());
          int unblockOptionId = store.state.homeState.menuItems.indexWhere(
              (element) =>
                  element.title == "Transaction Unblock Request Approval");
          print(unblockOptionId);
          if (unblockOptionId != null && unblockOptionId > 0) {
            print("if part");

            checkUserRight = true;

            print(checkUserRight);
          } else {
            print("else part");
            checkUserRight = false;
            print(checkUserRight);
          }
        },
        converter: (store) => BlockedNotificationViewmodel.fromStore(store),
        appBar: BaseAppBar(
          title: Text(
            "Branch Block Notification",
            style: TextStyle(fontFamily: "Roboto-Medium", fontSize: 18),
          ),
          elevation: 0,
        ),
        builder: (context, viewModel) {
          return
              //   Center(
              //   child: Column(
              //     children: [
              //       SizedBox(
              //         height: height * 0.4,
              //       ),
              //       Icon(Icons.warning_sharp),
              //       Text("No Data to Show")
              //     ],
              //   ),
              // );

              //working
              Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .06,
                        right: MediaQuery.of(context).size.width * .06,
                        top: 8,
                        bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Blocked Branches",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        viewModel
                                        .blockedNotificationData
                                        ?.bLockedNotificaionList
                                        ?.first
                                        ?.branchdtl !=
                                    null &&
                                viewModel
                                    .blockedNotificationData
                                    .bLockedNotificaionList
                                    .first
                                    .branchdtl
                                    .isNotEmpty &&
                                viewModel
                                        .blockedNotificationData
                                        .bLockedNotificaionList
                                        .first
                                        .notificationcount !=
                                    null &&
                                viewModel
                                    .blockedNotificationData
                                    .bLockedNotificaionList
                                    .first
                                    .notificationcount
                                    .isNotEmpty
                            ? Text(
                                viewModel
                                            .blockedNotificationData
                                            .bLockedNotificaionList
                                            .first
                                            .notificationcount
                                            .first
                                            .notificationtype ==
                                        "BLOCKED"
                                    // &&
                                    //     viewModel
                                    //             .blockedNotificationData
                                    //             .bLockedNotificaionList
                                    //             .first
                                    //             .notificationcount[0]
                                    //             .notificationtype
                                    //             .length >
                                    //         0
                                    ? viewModel
                                        .blockedNotificationData
                                        .bLockedNotificaionList
                                        .first
                                        .notificationcount
                                        .first
                                        .notificationcount
                                        .toString()
                                    : viewModel
                                        .blockedNotificationData
                                        .bLockedNotificaionList
                                        .first
                                        .notificationcount
                                        .last
                                        .notificationcount
                                        .toString(),
                                // "0",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Text("0"),
                      ],
                    ),
                  ),
                  if (viewModel.blockedNotificationData?.bLockedNotificaionList
                                  ?.first?.branchdtl !=
                              null &&
                          (viewModel
                                  .blockedNotificationData
                                  ?.bLockedNotificaionList
                                  ?.first
                                  ?.branchdtl
                                  ?.isNotEmpty ??
                              false) &&
                          viewModel
                                  .blockedNotificationData
                                  ?.bLockedNotificaionList
                                  ?.first
                                  ?.notificationcount !=
                              null &&
                          viewModel
                              ?.blockedNotificationData
                              ?.bLockedNotificaionList
                              ?.first
                              ?.notificationcount
                              ?.isNotEmpty ??
                      false)
                    Expanded(
                        child: Scrollbar(
                      thickness: 6,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel
                              ?.blockedNotificationData
                              ?.bLockedNotificaionList
                              ?.first
                              ?.branchdtl
                              ?.length,
                          itemBuilder: (context, int index) {
                            return InkWell(
                                onTap: () {
                                  print(index);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionUnblockApprovalPendingViewScreen(
                                                  fromBlocked: true,
                                                  isBranchBlocked: true,
                                                  branchId: viewModel
                                                      ?.blockedNotificationData
                                                      ?.bLockedNotificaionList
                                                      ?.first
                                                      ?.branchdtl[index]
                                                      ?.branchid,
                                                  optionId: viewModel
                                                      ?.blockedNotificationData
                                                      ?.bLockedNotificaionList
                                                      ?.first
                                                      ?.nextoptionid,
                                                  isUserRightToApprove:
                                                      // checkUserRight
                                                      viewModel
                                                          ?.blockedNotificationData
                                                          ?.bLockedNotificaionList
                                                          ?.first
                                                          ?.nextoptionuserrightyn,
                                                  branchname: viewModel
                                                      ?.blockedNotificationData
                                                      ?.bLockedNotificaionList
                                                      ?.first
                                                      ?.branchdtl[index]
                                                      ?.branchname))).then(
                                      (value) => viewModel.run());
                                },
                                child: viewModel
                                            .blockedNotificationData
                                            .bLockedNotificaionList
                                            .first
                                            .branchdtl[index]
                                            .notificationtype ==
                                        "BLOCKED"
                                    ? buildListTile(
                                        context,
                                        viewModel
                                            .blockedNotificationData
                                            .bLockedNotificaionList
                                            .first
                                            .branchdtl[index]
                                            .branchname,
                                        viewModel
                                            .blockedNotificationData
                                            .bLockedNotificaionList
                                            .first
                                            .branchdtl[index]
                                            .duemessage,
                                        true,
                                        viewModel
                                            .blockedNotificationData
                                            .bLockedNotificaionList
                                            .first
                                            .branchdtl[index]
                                            .branchid,
                                        viewModel,
                                        // checkUserRight
                                        viewModel
                                            ?.blockedNotificationData
                                            ?.bLockedNotificaionList
                                            ?.first
                                            ?.nextoptionuserrightyn,
                                      )
                                    : Container());
                          }),
                    ))
                ],
              )),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .06,
                          right: MediaQuery.of(context).size.width * .06,
                          top: 8,
                          bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Warning Generated Branches",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          viewModel.blockedNotificationData
                                          ?.bLockedNotificaionList?.first?.branchdtl !=
                                      null &&
                                  viewModel.blockedNotificationData.bLockedNotificaionList
                                      .first.branchdtl.isNotEmpty &&
                                  viewModel
                                          .blockedNotificationData
                                          .bLockedNotificaionList
                                          .first
                                          .notificationcount !=
                                      null &&
                                  viewModel
                                      .blockedNotificationData
                                      .bLockedNotificaionList
                                      .first
                                      .notificationcount
                                      .isNotEmpty
                              ? Text(
                                  viewModel
                                              .blockedNotificationData
                                              .bLockedNotificaionList
                                              .first
                                              .notificationcount
                                              .first
                                              .notificationtype ==
                                          "WARNING"
                                      ? viewModel
                                          .blockedNotificationData
                                          .bLockedNotificaionList
                                          .first
                                          .notificationcount
                                          .first
                                          .notificationcount
                                          .toString()
                                      : "0",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text("0")
                        ],
                      ),
                    ),
                    if (viewModel.blockedNotificationData
                                ?.bLockedNotificaionList?.first?.branchdtl !=
                            null &&
                        viewModel.blockedNotificationData.bLockedNotificaionList
                            .first.branchdtl.isNotEmpty &&
                        viewModel.blockedNotificationData.bLockedNotificaionList
                                .first.notificationcount !=
                            null &&
                        viewModel.blockedNotificationData.bLockedNotificaionList
                            .first.notificationcount.isNotEmpty)
                      Expanded(
                          child: Scrollbar(
                        thickness: 6,
                        child: ListView.builder(
                            itemCount: viewModel.blockedNotificationData
                                .bLockedNotificaionList.first.branchdtl.length,
                            itemBuilder: (context, int pos) {
                              return InkWell(
                                  onTap: () {
                                    print(pos);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionUnblockApprovalPendingViewScreen(
                                                    fromBlocked: true,
                                                    isBranchBlocked: true,
                                                    branchId: viewModel
                                                        ?.blockedNotificationData
                                                        ?.bLockedNotificaionList
                                                        ?.first
                                                        ?.branchdtl[pos]
                                                        ?.branchid,
                                                    optionId: viewModel
                                                        ?.blockedNotificationData
                                                        ?.bLockedNotificaionList
                                                        ?.first
                                                        ?.nextoptionid,
                                                    isUserRightToApprove: viewModel
                                                        ?.blockedNotificationData
                                                        ?.bLockedNotificaionList
                                                        ?.first
                                                        ?.nextoptionuserrightyn,
                                                    branchname: viewModel
                                                            ?.blockedNotificationData
                                                            ?.bLockedNotificaionList
                                                            ?.first
                                                            ?.branchdtl[pos]
                                                            ?.branchname ??
                                                        ""))).then(
                                        (value) => viewModel.run());
                                  },
                                  child: viewModel
                                              .blockedNotificationData
                                              .bLockedNotificaionList
                                              .first
                                              .branchdtl[pos]
                                              .notificationtype !=
                                          "BLOCKED"
                                      ? buildListTile(
                                          context,
                                          viewModel
                                              .blockedNotificationData
                                              .bLockedNotificaionList
                                              .first
                                              .branchdtl[pos]
                                              .branchname,
                                          viewModel
                                              .blockedNotificationData
                                              .bLockedNotificaionList
                                              .first
                                              .branchdtl[pos]
                                              .duemessage,
                                          false,
                                          viewModel
                                              .blockedNotificationData
                                              .bLockedNotificaionList
                                              .first
                                              .branchdtl[pos]
                                              .branchid,
                                          viewModel,
                                          // checkUserRight
                                          viewModel
                                              ?.blockedNotificationData
                                              ?.bLockedNotificaionList
                                              ?.first
                                              ?.nextoptionuserrightyn,
                                        )
                                      : Container(
                                          color: themeData.primaryColor,
                                        ));
                            }),
                      ))
                  ],
                ),
              ),
            ],
          );
        });
  }
}

Widget buildListTile(
    BuildContext context,
    String title,
    String message,
    bool isBlocked,
    int BranchId,
    BlockedNotificationViewmodel viewmodel,
    bool userRightToApprove) {
  print(userRightToApprove);
  BaseTheme theme = BaseTheme.of(context);
  return Row(
    children: [
      Flexible(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: isBlocked ? Colors.red : Colors.yellow,
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
              leading: CircleAvatar(
                  backgroundColor:
                      isBlocked ? Colors.redAccent : Colors.yellowAccent,
                  radius: 24,
                  child: Icon(
                    isBlocked ? Icons.home_work : Icons.home,
                    color: isBlocked ? Colors.white : Colors.black,
                  )),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.bodyMedium.copyWith(
                      color: isBlocked ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(message,
                      style: theme.bodyMedium.copyWith(
                        color: isBlocked ? Colors.white : Colors.black,
                      ))
                ],
              ),
              trailing: Icon(
                  isBlocked ? Icons.block : Icons.warning_amber_sharp,
                  color: isBlocked ? Colors.white : Colors.black)),
        ),
      ),
      IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TranUnblkRequestScreen(
                          flag: 1,
                          branchId: BranchId,
                          title: title,
                          type: isBlocked,
                          isUserRightToApprove: userRightToApprove,
                        ))).then((value) => viewmodel.run());
            ;
          },
          icon: Icon(
            Icons.pending_actions,
            color: isBlocked ? Colors.white : Colors.black,
          ))
    ],
  );
}

class _CircleAvatar extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconClr;

  const _CircleAvatar({Key key, this.icon, this.bg, this.iconClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: bg,
//        ThemeProvider.of(context).primaryColorDark,
        radius: 24,
        child: Icon(
          icon,
          color: iconClr,
        ));
  }
}

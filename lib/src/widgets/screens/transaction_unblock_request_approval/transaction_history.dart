import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_history_model.dart';

class TransactionHistoryPage extends StatefulWidget {
  final int tableId;
  final int tableDataId;
  const TransactionHistoryPage({
    Key key,
    this.tableId,
    this.tableDataId,
  }) : super(key: key);
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
        onDispose: (store) => store.dispatch(OnClearAction()),
        init: (store, context) {
          store.dispatch(fetchHistoryData(widget.tableId, widget.tableDataId));
        },
        converter: (store) =>
            TransactionUnblockReqApprlViewModel.fromStore(store),
        appBar: BaseAppBar(
          title: Text(
            "Approval History",
          ),
          elevation: 0,
        ),
        builder: (context, viewModel) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          final colors = BaseTheme.of(context).colors;
          ThemeData themeData = ThemeProvider.of(context);
          BaseTheme theme = BaseTheme.of(context);
          List<String> extendedDateList =[];
          String extendedDate;
          viewModel.historyData.forEach((element) {
            if(element.extendeddate != null){
              extendedDateList.add(element.extendeddate);
            }
          });
          extendedDateList.forEach((element) {
            if(element != "NA"){
              DateFormat dateFormate = DateFormat("dd-MM-yyyy");
              element = dateFormate.format(DateTime.parse(element));
            }
          });

          DateFormat dateFormate = DateFormat("dd-MM-yyyy");

          if (viewModel.historyData != null &&
              viewModel.historyData.isNotEmpty) {
            return Scaffold(
              body:
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: themeData.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Card(
                          color: themeData.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Column(mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              Padding(
                              padding:  EdgeInsets.only(left: 20.0,right: 20,top: 15, bottom: 25),
                              child: Card(
                                color: themeData.primaryColor,
                                elevation: 0,
                                child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text("Transaction No.",),
                                            SizedBox(width: width * 0.040,),
                                            Expanded(
                                              child: Center(
                                                child: Text(viewModel?.historyData?.first?.transno??"NA",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Transaction Date",textAlign: TextAlign.left,),
                                          SizedBox(width: width * 0.055,),

                                          Expanded(
                                            child: Center(
                                              child: Text(viewModel?.historyData?.first?.transdate??"NA" ,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                          ),textAlign: TextAlign.center,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Last Extended Date", textAlign: TextAlign.left,),
                                          Expanded(
                                            child: Center(
                                              child: Text(extendedDateList.isEmpty ? "NA" :
                                                      dateFormate.format(DateTime.parse(extendedDateList.first))??"NA",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                              Flexible(
                            child:ListView.builder(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:viewModel.historyData.length,
                                itemBuilder: (BuildContext context, int pos){
                                  String dt2;
                                  if(viewModel.historyData[pos].extendeddate != null){
                                    DateTime dt = DateTime.parse(viewModel?.historyData[pos]?.extendeddate?.substring(0, 10)??"");
                                    dt2 = DateFormat("dd-MM-yyyy").format(dt);
                                  }
                                  else{
                                    dt2 = "N/A";
                                  }
                                  final height = MediaQuery.of(context).size.height;
                                  final width = MediaQuery.of(context).size.width;
                                  List<HistoryDtlJson> dtlJson = viewModel.historyData[pos].historyDtl;
                                  dtlJson.removeWhere((element) => element.useraction == "PREPARED");
                                  String users =  viewModel.historyData[pos].actiontakenagainst;
                                  List<String> listOfUsers = users.split(',');

                                  String finalDate = viewModel?.historyData[pos]?.createddate;
                                  String subFinalDate = finalDate.substring(0,16);
                                  String subTime = finalDate.substring(19,22);
                                  String fullCreatedDate = subFinalDate + subTime;
                                  return
                                    Column(
                                      children: [
                                        Container(color: themeData.primaryColor
                                          ,child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                            Stack(
                                                children: [
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15.0)),
                                                    elevation: 0,
                                                    color: themeData.scaffoldBackgroundColor,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(15.0, 17.0, 15.0, 0.0),
                                                      child: Column(
                                                        children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Request No.",textAlign: TextAlign.left,),
                                                                  SizedBox(width: width * 0.1,),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text(viewModel?.historyData[pos]?.requestno??"NA",
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Request Date",textAlign: TextAlign.left,),
                                                                  SizedBox(width: width * 0.1,),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child:
                                                                      Text(viewModel?.historyData[pos]?.requestdate??"NA",
                                                                                style: TextStyle(fontWeight: FontWeight.bold,),
                                                                                textAlign: TextAlign.center,),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Created User",textAlign: TextAlign.left,),
                                                                  SizedBox(width: width * 0.1,),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text(viewModel?.historyData[pos]?.createduser??"NA",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.bold),
                                                                                textAlign: TextAlign.center,),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Created Date",textAlign: TextAlign.left,),
                                                                  SizedBox(width: width * 0.1,),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child:
                                                                      Text(fullCreatedDate ??"NA",
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Approval Status",textAlign: TextAlign.left,),
                                                                  SizedBox(width: width * 0.05,),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text(viewModel.historyData[pos].historyDtl.first.useraction ??"NA",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          Theme(
                                                            data: Theme.of(context).copyWith(
                                                              unselectedWidgetColor: Colors.white54,
                                                              dividerColor: Colors.transparent,
                                                            ),
                                                            child: ListTileTheme(
                                                              contentPadding: EdgeInsets.all(0),
                                                              dense: true,
                                                              horizontalTitleGap: 0.0,
                                                              minLeadingWidth: 0,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(bottom: 8),
                                                                child: ExpansionTile(
                                                                  trailing: Icon(Icons.expand_more,size: 36,),
                                                                  children: [
                                                                    Card(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(15.0)),
                                                                      elevation: 0,
                                                                      color: themeData.primaryColor,
                                                                      child: ListTileTheme(
                                                                        child: ListTile(
                                                                            title: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(height: 25,),
                                                                                  Text("Blocking Reason",
                                                                                    style: TextStyle(
                                                                                        fontSize: 14.4,
                                                                                        fontWeight: FontWeight.bold),),
                                                                                  Divider(color: Colors.white,thickness: 1.0,),
                                                                                  Text(viewModel.historyData[pos].blockedreason
                                                                                      ?? "No Blocked Reason",),
                                                                                  SizedBox(height: 25,),
                                                                                  Text("Action Taken",
                                                                                    style: TextStyle(
                                                                                        fontSize: 14.4,
                                                                                        fontWeight: FontWeight.bold),),
                                                                                  Divider(color: Colors.white,thickness: 1.0,),
                                                                                  Text(viewModel.historyData[pos].actiontaken
                                                                                      ?? "No Action Taken",),
                                                                                  SizedBox(height: 25,),
                                                                                  Text("Action Against Whom",
                                                                                    style: TextStyle(
                                                                                        fontSize: 14.4,
                                                                                        fontWeight: FontWeight.bold),),
                                                                                  Divider(color: Colors.white,thickness: 1.0,),
                                                                                  listOfUsers != null ?
                                                                                  Wrap(
                                                                                    children: List.generate(listOfUsers.length, (index) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                                                                                        child: Chip(
                                                                                          backgroundColor:  themeData.scaffoldBackgroundColor,
                                                                                          label: Text(listOfUsers[index], style: TextStyle(
                                                                                              color: Colors.white
                                                                                          ),),
                                                                                        ),
                                                                                      );
                                                                                    } ),
                                                                                  ) : Text("No Action Against Whom"),
                                                                                  SizedBox(height: 15,),
                                                                                  Text("Approval Detail",
                                                                                    style: TextStyle(
                                                                                        fontSize: 14.4,
                                                                                        fontWeight: FontWeight.bold),),
                                                                                  Divider(color: Colors.white,thickness: 1.0,),
                                                                                  Card(
                                                                                    shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(7.0)),
                                                                                    elevation: 0,
                                                                                    color: viewModel.historyData[pos].historyDtl.first.useraction
                                                                                        != "REJECTED" ? Colors.green : Colors.red,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          IntrinsicHeight(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text("Approval Status",textAlign: TextAlign.left,style: style.body2,),
                                                                                                SizedBox(width: width * 0.05,),
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child: Text(viewModel?.historyData[pos]?.
                                                                                                    historyDtl?.first?.useraction ?? "NA",
                                                                                                        style: style.body2.copyWith(fontSize: 13, fontWeight: FontWeight.w600)
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(height: 8,),
                                                                                          IntrinsicHeight(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(viewModel.historyData[pos].historyDtl
                                                                                                          .first.useraction != "REJECTED" ?
                                                                                                      "Approved On" :
                                                                                                      "Rejected On",
                                                                                                      textAlign: TextAlign.left,style: style.body2,),
                                                                                                SizedBox(width: width * 0.095,),
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child: Text(viewModel?.historyData[pos]?.historyDtl?.
                                                                                                          first?.actiondate?.substring(0,10) ?? "NA",  style: style.body2.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(height: 8,),
                                                                                          IntrinsicHeight(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(viewModel.historyData[pos].historyDtl
                                                                                                          .first.useraction != "REJECTED" ?
                                                                                                      "Approved By" :
                                                                                                      "Rejected By",
                                                                                                      textAlign: TextAlign.left,style: style.body2,),
                                                                                                SizedBox(width: width * 0.090,),
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child:
                                                                                                     Text(viewModel?.historyData[pos]?.historyDtl?.
                                                                                                     first?.username ??"NA",
                                                                                                         style: style.body2.copyWith(fontSize: 13, fontWeight: FontWeight.w600)
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(height: 8,),
                                                                                          IntrinsicHeight(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text("Extended Date",
                                                                                                      textAlign: TextAlign.left,style: style.body2,),
                                                                                                SizedBox(width: width * 0.065,),
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child:
                                                                                                        Text(viewModel?.historyData[pos]?.
                                                                                                        extendeddate == null ? "NA" :
                                                                                                        dateFormate.format(DateTime.parse(
                                                                                                            viewModel.historyData[pos].
                                                                                                            extendeddate)) ?? "NA",
                                                                                                            style: style.body2.copyWith(fontSize: 13, fontWeight: FontWeight.w600)
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 5,),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 8),
                                                                                    child: Card(
                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(7.0)),
                                                                                      elevation: 0,
                                                                                      color: themeData.scaffoldBackgroundColor,
                                                                                      child: Column(
                                                                                        children: [
                                                                                          SizedBox(height: 9),
                                                                                          Center(
                                                                                              child: Text("Approval Remarks",
                                                                                                style: TextStyle(fontWeight: FontWeight.w500),)),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(4.0),
                                                                                            child: Container(
                                                                                              height: height * 0.15,
                                                                                              width: width * 0.8,
                                                                                              child: Card(
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(7.0)),
                                                                                                  elevation: 0,
                                                                                                  color: themeData.primaryColor,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: SingleChildScrollView(
                                                                                                      child: Text(
                                                                                                        viewModel?.historyData[pos]?.historyDtl?.first?.remarks ?? "No Remarks",),
                                                                                                    ),
                                                                                                  )),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ])
                                                                        ),
                                                                        dense: true,
                                                                      )
                                                                      ,
                                                                    )
                                                                  ],
                                                                  title: Text("",style: TextStyle(fontSize: 15,),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: height * .001,
                                                      right: width * .001,
                                                      child: CircleAvatar(
                                                          backgroundColor: viewModel.historyData[pos].historyDtl
                                                              .first.useraction != "REJECTED"
                                                              ? Colors.green
                                                              : Colors.red,
                                                          radius: 10,
                                                          child: viewModel.historyData[pos].historyDtl.
                                                          first.useraction != "REJECTED"
                                                              ? Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 12,
                                                          )
                                                              : Icon(Icons.clear,
                                                              color: Colors.white,
                                                              size: 12))),
                                                ]
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                })

                          )],
                          ),
                        ),
                      ),
                    ),
                  )
          );
          } else {
            return Center(child: EmptyResultView(
            message: "No History",
          ));
          }
        });
  }
}

class ItemDialog extends StatefulWidget {
  final List<HistoryDtlJson> historydata;
  final HistoryModel historyModel;
  const ItemDialog({
    Key key, this.historydata, this.historyModel,
  }) : super(key: key);

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _formKey?.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2;
    final style = BaseTheme.of(context);
    final colors = BaseTheme
        .of(context)
        .colors;
    ThemeData themeData = ThemeProvider.of(context);
    return
      GestureDetector(
        onTap: () {
          FocusScopeNode().unfocus();
        },
        child: Container(
          height: MediaQuery.of(
              context)
              .size
              .height /
              1.4,
          decoration: BoxDecoration(
            color: themeData.primaryColor.withOpacity(.95),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Form(
            key: _formKey,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "History Detail",
                          style: style.title.copyWith(),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
                Divider(color: colors.borderColor),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      widget.historydata.isEmpty ?
                      Center(
                          heightFactor: height / 80,
                          child: EmptyResultView(
                            message: "No Data to Show",
                          )) :
                      Expanded(
                          child:
                          Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.historydata.length,
                                    itemBuilder: (BuildContext context, int pos){
                                      double width = MediaQuery.of(context).size.width;
                                      final colors = BaseTheme.of(context).colors;
                                      ThemeData themeData = ThemeProvider.of(context);
                                      BaseTheme theme = BaseTheme.of(context);
                                      bool _isExpanded = false;
                                      String action = widget.historydata[pos].useraction;
                                      String action2 = action[0].toUpperCase() + action.substring(1).toLowerCase();
                                      String _remarks = widget?.historydata[pos]?.remarks ?? "";
                                      if(_remarks.isEmpty){
                                        _remarks = "No Remarks";
                                      }
                                      else if(_remarks == null){
                                        _remarks = "No Remarks";
                                      }
                                      return Padding(
                                        padding: EdgeInsets.only(left: 5,right: 5),
                                        child: Card(
                                          elevation: 0,
                                          color: colors.primaryColor,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5,right: 5),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Status:"),
                                                    Text(widget?.historydata[pos]?.useraction??"")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("$action2 On:"),
                                                    Text(widget?.historydata[pos]?.actiondate?.substring(0,10)??"")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("$action2 By:"),
                                                    Text(widget?.historydata[pos]?.username??"")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: widget.historydata[pos].useraction == "APPROVED"
                                                      || widget.historydata[pos].useraction == "REJECTED" ?
                                                  0 : 5,
                                                ),
                                                Visibility(
                                                  visible: widget.historydata[pos].useraction == "APPROVED"
                                                      || widget.historydata[pos].useraction == "REJECTED",
                                                  child: ExpansionTile(

                                                    children: [
                                                      ListTileTheme(
                                                        child: ListTile(
                                                          title: Text(_remarks ?? "No Remarks",style: TextStyle(fontSize: 15),),
                                                        ),
                                                        dense: false,
                                                      )
                                                    ],
                                                    title: Text( "Remarks",
                                                      style: TextStyle(fontSize: 15
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ExpansionTile(
                                      children: [
                                        ListTileTheme(
                                          child: ListTile(
                                            title: Text(widget?.historyModel?.blockedreason ?? "No Blocked Reason",style: TextStyle(fontSize: 15),),
                                          ),
                                          dense: false,
                                        )
                                      ],
                                      title: Text( "Blocked Reason",
                                        style: TextStyle(fontSize: 15
                                        ),
                                      ),
                                    ),
                                    ExpansionTile(
                                      children: [
                                        ListTileTheme(
                                          child: ListTile(
                                            title: Text(widget?.historyModel?.actiontaken ?? "No Action Taken",style: TextStyle(fontSize: 15),),
                                          ),
                                          dense: false,
                                        )
                                      ],
                                      title: Text( "Action Taken",
                                        style: TextStyle(fontSize: 15
                                        ),
                                      ),
                                    ),
                                    ExpansionTile(
                                      children: [
                                        ListTileTheme(
                                          child: ListTile(
                                            title: Text(widget?.historyModel?.actiontakenagainst ?? "No Action Taken Against",style: TextStyle(fontSize: 15),),
                                          ),
                                          dense: false,
                                        )
                                      ],
                                      title: Text( "Against Whom",
                                        style: TextStyle(fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
  }
}
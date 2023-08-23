import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base/resources.dart';
import 'package:base/resources.dart';
import 'package:base/resources.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';
import 'package:redstars/utility.dart';

class HistoryListView extends StatelessWidget {
  final List<HistoryList> transactionData;
  final isApprovalHistory;

  const HistoryListView({Key key, this.transactionData, this.isApprovalHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return transactionData.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.only(top: 14),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: transactionData?.length ?? 0,
            itemBuilder: (_con, index) {
              HistoryList history = transactionData[index];
              return isApprovalHistory
                  ? _ApprovalList(history: history)
                  : _TransactionList(history: history);
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.history, color: colors.white, size: 45),
              SizedBox(height: 10),
              Text("No Previous Records Found",
                  style: textTheme.body2.copyWith(color: colors.white))
            ],
          );
  }
}

class _ApprovalList extends StatelessWidget {
  final HistoryList history;

  const _ApprovalList({Key key, this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    final color = history.userAction == "Approved" ? Colors.green : Colors.red;
    bool approved = history.userAction == "Approved";

    return Card(
        elevation: approved ? 2 : 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BaseBorderSide(color: color, width: 2)),
        child: Container(
          color: ThemeProvider.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(children: <Widget>[
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text("${history.userAction}",
                    style: textTheme.subhead1.copyWith(color: colors.white)),
                SizedBox(height: 6.0),
                Text("${history.userName}",
                    style: textTheme.subhead1.copyWith(
                        fontWeight: FontWeight.w300, color: colors.white)),
                SizedBox(height: 4.0),
                Text("${history.date}")
              ])),
          SizedBox(width: 4),
          CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(.5),
              child: Text(history.level, style: textTheme.display1))
        ])));
  }
}

class _TransactionList extends StatelessWidget {
  final HistoryList history;

  const _TransactionList({Key key, this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return Container(
        color: ThemeProvider.of(context).primaryColor,
        margin: EdgeInsets.only(bottom: 1),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(BaseStringCase("${history.userName}").sentenceCase,
                        style:
                            textTheme.subhead1.copyWith(color: colors.white)),
                    Text(
                      "${history.date}",
                      style:
                          textTheme.smallMedium.copyWith(color: colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Text(
                    BaseStringCase("${history.userAction}").sentenceCase,
                    style: textTheme.subhead1.copyWith(
                        fontWeight: FontWeight.w300, color: colors.white)),
              ),
              SizedBox(height: 12.0),
            ]));
  }
}

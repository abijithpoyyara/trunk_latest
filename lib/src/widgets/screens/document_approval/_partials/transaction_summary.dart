import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/widgets/screens/report_engine/report_summary_view.dart';
import 'package:redstars/utility.dart';

class TransactionSummaryView extends StatelessWidget {
  final ReportFormatModel reportHeader;
  final Map<String, dynamic> details;

  const TransactionSummaryView({Key key, this.reportHeader, this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reportHeader?.reportDtl != null &&
            reportHeader?.reportDtl?.isNotEmpty
        ? SummaryReport<_SummaryModel>(
            reportData: reportHeader?.reportDtl?.map((head) {
                  return _SummaryModel(
                      // icon: icon,
                      value: head.formatNumberYn
                          ? BaseNumberFormat(
                                  number:
                                      num.parse('${details[head.dataIndex]}'))
                              .formatCurrency()
                          : details[head.dataIndex] == null
                              ? '- -'
                              : '${details[head.dataIndex]}',
                      label: head.header,
                      isDescription: head.width > 500);
                })?.toList() ??
                List(),
            gridChildBuilder: (data, index) => _SummaryTile(model: data),
          )
        : Align(alignment: Alignment.center, child: EmptyResultView());
  }
}

class _SummaryTile extends StatelessWidget {
  final _SummaryModel model;

  const _SummaryTile({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    return Row(children: <Widget>[
      if (model.icon != null) Icon(model.icon),
      SizedBox(width: 8),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            SizedBox(
              height: 3,
            ),
            Text(
              model.label,
              style: style.body2.copyWith(fontSize: 14.0, color: Colors.white),
//                maxLines: 1,
              textAlign: TextAlign.start,
              softWrap: true,
            ),
            SizedBox(
              height: 6,
            ),
            Expanded(
              child: Text('${model.value ?? '--'}',
//                maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  // style: TextStyle(fontSize: 14,color: Colors.white,fontFamily: "AbyssinicaSIL"),
                  style: !model.isDescription
                      ? style.bodyBold.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        )
                      : style.body),
            )
          ]))
    ]);
  }
}

class _SummaryModel {
  IconData icon;
  String label;
  String value;
  bool isDescription;

  _SummaryModel(
      {this.icon, this.label, this.value, this.isDescription = false});
}

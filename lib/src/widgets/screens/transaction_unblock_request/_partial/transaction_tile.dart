//import 'package:base/res/values/base_style.dart';
//import 'package:base/res/values/base_theme.dart';
//import 'package:flutter/material.dart';
//import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
//import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtlHeadingModel l.dart';
//import 'package:redstars/src/widgets/screens/report_engine/report_engine.dart';
//
//class TransactionTile extends StatefulWidget {
//  final TransactionReqHeadingList tableModel;
//  final List<PendingTransactionDetailModelList> tableModelDetail;
//  const TransactionTile({Key key,
//    this.tableModel,
//    this.tableModelDetail
//  }) : super(key: key);
//
//  @override
//  _TransactionTileState createState() => _TransactionTileState();
//}
//
//class _TransactionTileState extends State<TransactionTile> {
//  @override
//  List<TableDetail> mainChild;
//  TableDetail editableColumn;
//  List<PendingTransactionDetailModelList> selectedData;
//
//  @override
//  void initState() {
//    mainChild = _getmainChildren(widget.tableModel);
//    selectedData = widget.tableModelDetail;
//    print("data123${widget.tableModelDetail.first.transno}");
//
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("data123${widget.tableModelDetail.first.transno}");
//    return ReportEngineView<PendingTransactionDetailModelList>(
//      reportData: selectedData,
//      childBuilder: (data, index) =>
//      _ChildBuilder(data: data.data, header: mainChild),
//    );
//  }
//}
//
//class _ChildBuilder extends StatelessWidget {
//  final Map<String, dynamic> data;
//  final List<TableDetail> header;
//
//  _ChildBuilder({this.data, this.header}) {
//    header?.sort((a, b) => a.sortorder > b.sortorder ? 1 : 0);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        padding: EdgeInsets.all(5),
//        child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            mainAxisSize: MainAxisSize.min,
//            children: header.map<Widget>((mode) {
//              return Row(children: <Widget>[
//                // if (mode.leadingIcon)
//                //   _IconWidget(
//                //       icon: IconData(data[mode.dataIndex]),
//                //       color: Color(mode.iconColor),
//                //       size: 14),
//                Expanded(
//                    child: _TextWidget(
//                        // alignment: mode.align,
//                        // isBold: mode.bold,
//                        // isTitle: mode.isTitle || mode.leadingIcon,
//                        value: "${data[mode.dataindex]}",
//                        fontColor: /*mode?.fontColor != null
//                            ? Color(mode.fontColor)
//                            : */Colors.black,
//                        header: mode.header)),
//                // if (mode.trailingIcon)
//                //   _IconWidget(
//                //       icon: IconData(data[mode.dataIndex]),
//                //       color: Color(mode.iconColor),
//                //       size: 14)
//              ]);
//            }).toList()));
//  }
//}
//
//List<TableDetail> _getmainChildren(TransactionReqHeadingList reportHeader) {
//  List<TableDetail> formats = List();
//  return formats;
//}
//
//
//class _TextWidget extends StatelessWidget {
//  final bool isTitle;
//  final bool isBold;
//  final String header;
//  final String value;
//  final String last;
//  final Color fontColor;
//
//  final TextAlign alignment;
//
//  const _TextWidget(
//      {Key key,
//        this.header,
//        this.isTitle,
//        this.value,
//        this.last,
//        this.fontColor = Colors.white,
//        this.isBold = false,
//        this.alignment = TextAlign.start})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    BaseTheme style = BaseTheme.of(context);
//    return isTitle
//        ? Text(
//      value,
//      textAlign: alignment,
//      style: style.bodyBold.copyWith(color: Colors.white),
//    )
//        : Row(
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.zero,
//          child: Text(
//            "${header ?? ""} : ",
//            style: style.body2.copyWith(color: Colors.white),
//          ),
//        ),
//        SizedBox(
//          height: 4,
//        ),
//        Expanded(
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                value,
//                textAlign: alignment,
//                style: style.body2.copyWith(
//                    color: Colors.white,
//                    fontWeight:
//                    isBold ? BaseTextStyle.bold : BaseTextStyle.light),
//              ),
//
//            )),
//
//      ],
//    );
//  }
//}
//
//class _IconWidget extends StatelessWidget {
//  final IconData icon;
//  final Color color;
//  final double size;
//
//  const _IconWidget({Key key, this.icon, this.color, this.size})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Icon(icon, color: color, size: size ?? 22);
//  }
//}

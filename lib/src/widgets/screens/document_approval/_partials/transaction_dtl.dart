import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/widgets/screens/document_approval/_views/input_dialog.dart';
import 'package:redstars/src/widgets/screens/report_engine/report_engine.dart';

class TransactionDtl extends StatefulWidget {
  final ReportFormatModel reportHeader;
  final List<TransactionDtlApproval> reportData;

  const TransactionDtl({Key key, this.reportHeader, this.reportData})
      : super(key: key);

  @override
  TransactionDtlState createState() => TransactionDtlState();
}

class TransactionDtlState extends State<TransactionDtl> {
  List<ReportFormatDtlModel> leadingChildren;
  List<ReportFormatDtlModel> mainChildren;
  List<ReportFormatDtlModel> trailingChildren;
  ReportFormatDtlModel editableColumn;
  List<TransactionDtlApproval> selectionReportData;

  List<Map<String, dynamic>> submitData() {
    bool hasSelection = false;

    final mappedList = selectionReportData.map((data) {
      Map<String, dynamic> _kMap = Map();
      hasSelection = hasSelection || data.selected;
      _kMap["table"] = data.table;
      _kMap["dtldataid"] = data.dtlDataId;
      _kMap["appyn"] = data.selected;
      _kMap["editcol"] = editableColumn?.dataIndex ?? "";
      if (editableColumn != null) {
        _kMap["editcolval"] = data.data[editableColumn.dataIndex];
      }
      return _kMap;
    }).toList();

    return hasSelection ? mappedList : null;
  }

  @override
  void initState() {
    leadingChildren = _getLeadingChildren(widget.reportHeader);
    mainChildren = _getMainChildren(widget.reportHeader);
    selectionReportData = widget.reportData;
    trailingChildren = _getTrailingChildren(widget.reportHeader);
    widget.reportHeader?.reportDtl?.forEach((head) {
      if (head.drillDown) editableColumn = head;
    });

    print("edit: ${editableColumn.toString()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReportEngineView<TransactionDtlApproval>(
      reportData: selectionReportData,
      leadingChildBuilder: (data, int index) =>
          _LeadingChildBuilder(data: data.data, header: leadingChildren),
      childBuilder: (data, index) =>
          _ChildBuilder(data: data.data, header: mainChildren),
      trailingChildBuilder: (data, index) =>
          _TrailingChildBuilder(data: data.data, header: trailingChildren),
      isExpandable: widget.reportHeader?.isExpandableList,
      overChildBuilder: (data, index) => data.selected
          ? Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2)),
              child: Icon(
                Icons.check,
                color: Colors.red,
                semanticLabel: "Selected",
              ))
          : null,
      onClick: (data, index) async {
//        if (!data.selected && editableColumn != null)
        if (editableColumn != null)
          data.data[editableColumn.dataIndex] = await _showInputDialog(
            initValue: data.data[editableColumn.dataIndex],
            title: editableColumn.header,
          );

        setState(() {
//          data.selected = !data.selected;
          selectionReportData[index] = data;
        });
      },
    );
  }

  List<ReportFormatDtlModel> _getLeadingChildren(
      ReportFormatModel reportHeader) {
    List<ReportFormatDtlModel> formats = List();
    reportHeader?.reportDtl?.forEach((element) {
      if (element.leading) formats.add(element);
    });
    return formats;
  }

  List<ReportFormatDtlModel> _getMainChildren(ReportFormatModel reportHeader) {
    List<ReportFormatDtlModel> formats = List();
    reportHeader?.reportDtl?.forEach((element) {
      if (!element.trailing && !element.leading) formats.add(element);
    });
    return formats;
  }

  List<ReportFormatDtlModel> _getTrailingChildren(
      ReportFormatModel reportHeader) {
    List<ReportFormatDtlModel> formats = List();

    reportHeader?.reportDtl?.forEach((element) {
      if (element.trailing) formats.add(element);
    });
    return formats;
  }

  Future<int> _showInputDialog({int initValue, String title}) async {
    print("initial val: $initValue");
    print("title: $title");

    return await baseShowChildDialog<int>(
        context: context,
        child: InputDialog(title: title, initValue: initValue),
        barrierDismissible: true);
  }
}

class _LeadingChildBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<ReportFormatDtlModel> header;

  _LeadingChildBuilder({this.data, this.header}) {
    header.sort((a, b) => a.sortOrder > b.sortOrder ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 4),
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: header.map<Widget>((mode) {
              if (mode.leadingIcon)
                return _IconWidget(
                    icon: IconData(data[mode.dataIndex]),
                    color: Color(mode.iconColor));
              else
                return _TextWidget(
                    alignment: mode.align,
                    isTitle: mode.isTitle,
                    isBold: mode.bold,
                    value: mode.formatNumberYn && data[mode.dataIndex] != null
                        ? BaseNumberFormat(
                                number: num.parse('${data[mode.dataIndex]}'))
                            .formatCurrency()
                        : data[mode.dataIndex] == null
                            ? '- -'
                            : "${data[mode.dataIndex]}",
                    fontColor: mode?.fontColor != null
                        ? Color(mode.fontColor)
                        : Colors.black,
                    header: mode.header);
            }).toList(),
          ),
        ));
  }
}

class _ChildBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<ReportFormatDtlModel> header;

  _ChildBuilder({this.data, this.header}) {
    header?.sort((a, b) => a.sortOrder > b.sortOrder ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: header.map<Widget>((mode) {
              return Row(children: <Widget>[
                if (mode.leadingIcon)
                  _IconWidget(
                      icon: IconData(data[mode.dataIndex]),
                      color: Color(mode.iconColor),
                      size: 14),
                Expanded(
                    child: _TextWidget(
                        alignment: mode.align,
                        isBold: mode.bold,
                        isTitle: mode.isTitle || mode.leadingIcon,
                        value: mode.formatNumberYn &&
                                data[mode.dataIndex] != null
                            ? BaseNumberFormat(
                                    number:
                                        num.parse('${data[mode.dataIndex]}'))
                                .formatCurrency()
                            : data[mode.dataIndex] == null
                                ? '- -'
                                : "${data[mode.dataIndex]}",
                        fontColor: mode?.fontColor != null
                            ? Color(mode.fontColor)
                            : Colors.black,
                        header: mode.header)),
                if (mode.trailingIcon)
                  _IconWidget(
                      icon: IconData(data[mode.dataIndex]),
                      color: Color(mode.iconColor),
                      size: 14)
              ]);
            }).toList()));
  }
}

class _TrailingChildBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<ReportFormatDtlModel> header;

  _TrailingChildBuilder({this.data, this.header}) {
    header.sort((a, b) => a.sortOrder > b.sortOrder ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: header.map<Widget>((mode) {
        if (mode.trailingIcon)
          return _IconWidget(
              icon: IconData(data[mode.dataIndex]),
              color: Color(mode.iconColor));
        else
          return _TextWidget(
              alignment: TextAlign.end,
              isBold: mode.bold,
              isTitle: mode.isTitle,
              value: mode.formatNumberYn && data[mode.dataIndex] != null
                  ? BaseNumberFormat(
                          number: num.parse('${data[mode.dataIndex]}'))
                      .formatCurrency()
                  : data[mode.dataIndex] == null
                      ? '- -'
                      : "${data[mode.dataIndex]}",
              fontColor: mode?.fontColor != null
                  ? Color(mode.fontColor)
                  : Colors.black,
              header: mode.header);
      }).toList(),
    );
  }
}

class _TextWidget extends StatelessWidget {
  final bool isTitle;
  final bool isBold;
  final String header;
  final String value;
  final String last;
  final Color fontColor;

  final TextAlign alignment;

  const _TextWidget(
      {Key key,
      this.header,
      this.isTitle,
      this.value,
      this.last,
      this.fontColor = Colors.white,
      this.isBold = false,
      this.alignment = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    return isTitle
        ? Text(
            value,
            textAlign: alignment,
            style: style.bodyBold.copyWith(color: Colors.white),
          )
        : Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  "${header ?? ""} : ",
                  style: style.body2.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: alignment,
                  style: style.body2.copyWith(
                      color: Colors.white,
                      fontWeight:
                          isBold ? BaseTextStyle.bold : BaseTextStyle.light),
                ),
              )),
            ],
          );
  }
}

class _IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _IconWidget({Key key, this.icon, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size ?? 22);
  }
}

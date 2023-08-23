import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';

class ApprovalButtons extends StatefulWidget {
  final void Function({String remarks}) onSubmit;
  final int id;
  final String sts;
  final String initsta;

  const ApprovalButtons(
      {Key key, @required this.onSubmit, this.id, this.sts, this.initsta})
      : super(key: key);

  @override
  ApprovalButtonsState createState() => ApprovalButtonsState();
}

class ApprovalButtonsState extends State<ApprovalButtons> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _remarks = "";

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Form(
        key: _formKey,
        child: Container(
            //  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.25),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: themeData.primaryColor,
              //  border: Border.all(color: colors.selectedColor),
            ),
            child: Row(
              children: [
                //  Text("${widget.sts}"),
                Flexible(
                    flex: 6,
                    child: BaseTextField(
                      initialValue: widget.initsta ?? "",
                      isEnabled: (widget.sts) != "APPROVED",
                      vector: AppVectors.remarks,
                      displayTitle: "Remarks",
                      onSaved: (val) => setState(() => _remarks = val),
                      hint: "Remarks",
                      //  initialValue:,
                    )),
                SizedBox(width: 4),
                SizedBox(width: 4),
              ],
            )));
  }

  Future<void> onSubmit(BuildContext context) async {
    _formKey.currentState.save();
    bool result = await baseChoiceDialog(
        title: "Confirmation",
        message: "Are you sure to save the Requisition ?",
        context: context);
    if (result) {
      widget.onSubmit(remarks: _remarks);
    }
  }
}

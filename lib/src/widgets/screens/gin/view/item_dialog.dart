import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/utility.dart';

class ItemDialog extends StatefulWidget {
  final GINItemModel item;
  final double height;

  const ItemDialog({Key key, this.item, this.height}) : super(key: key);

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  GlobalKey<FormState> _formKey;
  GINItemModel item;
  double difference;
  bool isNotReceived;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _formKey = GlobalKey<FormState>();
    difference = 0;
    isNotReceived = !(item?.isItemReceived ?? false);
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BaseTheme.of(context);
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode().unfocus();
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: themeData.primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
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
                child: Padding(
                  padding: EdgeInsets.only(top: 4, right: 15, left: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: colors.infoColor),
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            "Requested Qty",
                            style: style.textfieldLabel,
                          )),
                          Text(
                            (BaseNumberFormat(number: item.qty)
                                        .formatCurrency())
                                    .toString() +
                                ' ${item.uom}',
                            style: style.title,
                          )
                        ]),
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: BaseTextField(
                                icon: Icons.receipt,
                                isVector: true,
                                autoFocus: true,
                                isNumberField: true,
                                displayTitle: "Received Qty",
                                initialValue:
                                    (item.receivedQty ?? item.qty).toString(),
                                onChanged: (val) {
                                  print(val);
                                  var qty =
                                      double.parse(val.replaceAll(" ", ""));
                                  difference = item.qty - qty.toDouble();
                                },
                                onSaved: (val) {
                                  setState(() {
                                    var qty = double.parse(val);
                                    item.receivedQty = qty;
                                  });
                                }),
                          ),
                          Text(
                            ' ${item.uom}',
                            style: style.body2Medium,
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      // SwitchListTile(
                      //   value: isNotReceived,
                      //   onChanged: (val) {
                      //     setState(() {
                      //       isNotReceived = val;
                      //     });
                      //   },
                      //   title: Text('Item not received'),
                      // ),
                    ],
                  ),
                ),
              ),
              if (difference > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Lacking $difference ${item.uom} ',
                    style:
                        style.subhead1Bold.copyWith(color: colors.dangerColor),
                  ),
                )
              else if (difference < 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Additional ${(difference).abs()} ${item.uom} ',
                    style: style.subhead1Bold,
                  ),
                ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BaseRaisedButton(
                  backgroundColor: themeData.primaryColorDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: themeData.primaryColorDark,
                  child: Text(
                    "Save",
                    style: TextStyle(color: colors.white),
                  ),
                  onPressed: () {
                    _formKey.currentState.save();
                    item.isItemReceived = !isNotReceived;
                    Navigator.of(context).pop(item);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

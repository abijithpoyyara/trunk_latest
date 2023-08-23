import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/gin/gin_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/gin/view/item_dialog.dart';
import 'package:redstars/utility.dart';

class GINDetailScreen extends StatefulWidget {
  final PoModel order;
  final String selecedIndexStatus;
  final GINViewModel viewModel;

  const GINDetailScreen(
      {Key key, this.order, this.selecedIndexStatus, this.viewModel})
      : super(key: key);
  @override
  _GINDetailScreenState createState() => _GINDetailScreenState();
}

class _GINDetailScreenState extends State<GINDetailScreen> {
  BranchStockLocation location;

  // @override
  // void initState() {
  //   location = widget.viewModel.ginSelelctedLoc;
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, GINViewModel>(
        init: (store, context) {
          if (widget.order.refTableId != null) {
            store.dispatch(fetchPOSourceDetails(widget.order));
            store.dispatch(fetchPODetails(widget.order));
            store.dispatch(fetchInitialData());
          }
          location = widget.viewModel.ginSelelctedLoc;
        },
        converter: (store) => GINViewModel.fromStore(store),
        // onWillChange: (prev, viewModel) {
        //   if (!prev.saveStatus && viewModel.saveStatus) {
        //     Future.delayed(kThemeChangeDuration, () {
        //       showSuccessDialog(context, 'Acknowledgement Saved successfully',
        //           'Success', () => Navigator.pop(context));
        //     });
        //   }
        // },

        onDispose: (store) => store.dispatch(GINClearAction()),
        onDidChange: (viewModel, context) {
          if (viewModel.isginSave) {
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              Navigator.pop(context);
              Navigator.pop(context);
              viewModel.onClear();
              viewModel.onRefresh();
            });
          }
        },
        builder: (context, viewModel) {
          return Scaffold(
            appBar: BaseAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.order?.transactionNo ?? "PO Acknowledgement"),
                  Expanded(
                    child: Text(
                      '${widget.order?.transactionDate ?? ""}',
                      style: textStyle.smallMedium.copyWith(letterSpacing: .75),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              actions: [
                Visibility(
                  visible: (widget.selecedIndexStatus != null &&
                              widget.selecedIndexStatus == "Pending" ||
                          widget.selecedIndexStatus == "Rejected") ||
                      viewModel.ginEditedId == 0,
                  child: IconButton(
                      onPressed: () {
                        String message = viewModel.validateGINSave();
                        if (message != null && message.isEmpty) {
                          viewModel.onGINSaveClick();
                        } else {
                          BaseSnackBar.of(context).show(message);
                        }
                      },
                      icon: Icon(Icons.check)),
                ),
              ],
            ),
            body: Container(
              color: themeData.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 10),
                            AbsorbPointer(
                              absorbing:
                                  (widget.selecedIndexStatus == "Approved"),
                              // ? true
                              // : false),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeData.scaffoldBackgroundColor,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: colors.borderColor
                                                .withOpacity(.6)))),
                                child: BaseDialogField<BranchStockLocation>(
                                  // height: height * .26,
                                  // isChangeHeight: true,
                                  userStyle: textStyle.subhead1Semi.copyWith(
                                      color: colors.hintColor, fontSize: 18),
                                  isVector: true,
                                  hint: "Tap to select data",

                                  icon: Icons.add_location_alt_outlined,
                                  list: viewModel.ginLocations,
                                  initialValue: viewModel.ginSelelctedLoc,
                                  // viewModel.ginEditedId == 1
                                  //     ? viewModel.ginSelelctedLoc
                                  //     : null,
                                  isEnabled: true,
                                  listBuilder: (val, pos) => DocumentTypeTile(
                                    selected: true,
                                    icon: Icons.location_pin,
                                    title: val.name,
                                    onPressed: () =>
                                        Navigator.pop(context, val),
                                  ),
                                  fieldBuilder: (selected) => Text(
                                    selected.name,
                                    style: BaseTheme.of(context).textfield,
                                    textAlign: TextAlign.start,
                                  ),
                                  displayTitle: "Locations",
                                  validator: (val) {
                                    if (val == null) {
                                      return "Please select location";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    location = val;
                                  },
                                  onChanged: (val) {
                                    location = val;
                                    viewModel.onUserSelectLocation(val);
                                  },
//          onSaved: (val) {}
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.supervised_user_circle,
                                      color: colors.hintColor),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Supplier',
                                      style: textStyle.subhead1Semi
                                          .copyWith(color: colors.hintColor),
                                    ),
                                  ),
                                ]),
                            Divider(color: colors.borderColor),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${viewModel.supplier?.supplierName ?? ""}',
                                    style: textStyle.subhead1Semi.copyWith(),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${viewModel.supplier.address1}',
                                    style: textStyle.bodyMedium.copyWith(),
                                  ),
                                  Text(
                                    '${viewModel.supplier?.address2 ?? ""}',
                                    style: textStyle.bodyMedium.copyWith(),
                                  ),
                                  Text(
                                    '${viewModel.supplier?.address3 ?? ""}',
                                    style: textStyle.bodyMedium.copyWith(),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Icon(Icons.directions_bus_rounded,
                            //           color: colors.hintColor),
                            //       SizedBox(width: 4),
                            //       Expanded(
                            //         child: Text(
                            //           'Vehicles',
                            //           style: textStyle.subhead1Semi
                            //               .copyWith(color: colors.hintColor),
                            //         ),
                            //       ),
                            //       Container(
                            //           decoration: BoxDecoration(
                            //             color: colors.hintColor,
                            //             borderRadius:
                            //                 BorderRadius.all(Radius.circular(8)),
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Text(
                            //               '${viewModel.vehicles?.length ?? 0}',
                            //               style: textStyle.body.copyWith(
                            //                   color: themeData.primaryColor),
                            //             ),
                            //           )),
                            //     ]),
                            // Divider(color: colors.borderColor),
                            // VehicleList(
                            //   vehicles: viewModel?.vehicles,
                            // ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.shopping_cart_rounded,
                                      color: colors.hintColor),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Items',
                                      style: textStyle.subhead1Semi
                                          .copyWith(color: colors.hintColor),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: colors.hintColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${viewModel.orderItems?.length ?? 0}',
                                          style: textStyle.body.copyWith(
                                              color: themeData.primaryColor),
                                        ),
                                      )),
                                ]),
                            Divider(color: colors.borderColor),
                            AbsorbPointer(
                              absorbing:
                                  (widget.selecedIndexStatus == "Approved"),
                              // ? true
                              // : widget.selecedIndexStatus == "Rejected"
                              //     ? true
                              //     : false),
                              child: ItemList(
                                itemDetails: viewModel?.orderItems,
                                onTap: (item) async {
                                  final GINItemModel result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          elevation: 6,
                                          backgroundColor: Colors.transparent,
                                          child: ItemDialog(
                                            item: item,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                          ),
                                        );
                                      });
                                  if (result != null) {
                                    viewModel.updateItem(result);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 3,
                            child: AbsorbPointer(
                              absorbing:
                                  widget.selecedIndexStatus == "Approved",
                              child: _TextInputField(
                                displayTitle: "Remarks",
                                initialValue: "",
                                hint: "Enter Remarks",
                                icon: Icons.description,
                                onSaved: (data) {
                                  print(data);
                                  viewModel.onEnterRemarks(data);
                                },
                              ),
                            ),
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
        });
  }
}

// class GINDetailScreen extends StatelessWidget {
//   final PoModel order;
//   final String selecedIndexStatus;
//
//   const GINDetailScreen({Key key, this.order, this.selecedIndexStatus})
//       : super(key: key);
//
//   @override
//
// }

class ItemList extends StatelessWidget {
  final List<GINItemModel> itemDetails;
  final ValueChanged<GINItemModel> onTap;

  const ItemList({
    Key key,
    this.itemDetails,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return itemDetails != null && itemDetails.isNotEmpty
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: itemDetails.length ?? 0,
                itemBuilder: (context, position) {
                  bool isLast = position + 1 == itemDetails.length;
                  GINItemModel item = itemDetails[position];
                  return TextButton(
                    onPressed: () => onTap(item),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            color: item.isItemReceived
                                ? colors.infoColor.withOpacity(.45)
                                : colors.dangerColor.withOpacity(.45),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              item.isItemReceived
                                  ? Icon(
                                      Icons.check_circle_outline,
                                      color: item.receivedQty >= item.qty
                                          ? themeData.primaryColor
                                          : colors.dangerColor,
                                    )
                                  : Icon(
                                      Icons.remove_circle,
                                      color: colors.dangerColor,
                                    ),
                              SizedBox(width: 6),
                              Expanded(
                                  child: Text(
                                '${item.itemName}',
                                style:
                                    textStyle.textfield.copyWith(fontSize: 16),
                              )),
                              Text(
                                (BaseNumberFormat(number: item.qty)
                                        .formatCurrency())
                                    .toString(),
                                style: textStyle.subhead1Semi,
                              ),
                              SizedBox(width: 2.5),
                              Text('${item.uom}'),
                            ],
                          ),
                          // if (!item.isItemReceived)
                          //   Padding(
                          //     padding: const EdgeInsets.only(
                          //         top: 4.0, left: 6, right: 4),
                          //     child: Text(
                          //       'Item not received',
                          //       textAlign: TextAlign.start,
                          //       style: textStyle.body2MediumHint
                          //           .copyWith(fontStyle: FontStyle.italic),
                          //     ),
                          //   )
                          // else
                          if (item.qty != item.receivedQty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, left: 6, right: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Received :${BaseNumberFormat(number: item?.receivedQty ?? 0).formatCurrency()} ${item.uom} ',
                                    textAlign: TextAlign.start,
                                    style: textStyle.subhead1Bold
                                        .copyWith(fontStyle: FontStyle.italic),
                                  ),
                                  if (item.qty != null &&
                                      item.receivedQty != null)
                                    Text(
                                      '${(item?.qty ?? 0.0) - (item?.receivedQty ?? 0) > 0 ? "Difference" : "Additional"}  :${BaseNumberFormat(number: (item.qty - item.receivedQty).abs()).formatCurrency()} ${item.uom}   ',
                                      textAlign: TextAlign.start,
                                      style: textStyle.subhead1Bold.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: item.qty - item.receivedQty > 0
                                            ? colors.dangerColor
                                            : colors.greenColor,
                                      ),
                                    ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: GINEmptyResultView(
              icon: Icons.remove_shopping_cart,
              message: "No Items to show",
            ),
          );
  }
}

class VehicleList extends StatelessWidget {
  final List<VehicleModel> vehicles;

  const VehicleList({
    Key key,
    this.vehicles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context);

    return vehicles != null && vehicles.isNotEmpty
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: vehicles.length,
                itemBuilder: (context, position) {
                  bool isLast = position + 1 == vehicles.length;
                  final item = vehicles[position];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BaseBorderSide(
                                color: isLast
                                    ? Colors.transparent
                                    : colors.infoColor.withOpacity(.45)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${item.vehicleNo}',
                          style: textStyle.subhead2
                              .copyWith(fontWeight: BaseTextStyle.medium),
                        ),
                        SizedBox(height: 2),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.hintColor.withOpacity(.45)),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            BaseStringCase('${item.remarks}').sentenceCase,
                            style: textStyle.body
                                .copyWith(wordSpacing: 1.2, letterSpacing: .15),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: GINEmptyResultView(
              icon: Icons.directions_bus_rounded,
              message: "No Vehicles to show",
            ),
          );
  }
}

class GINEmptyResultView extends StatelessWidget {
  const GINEmptyResultView({
    Key key,
    this.message = "No results",
    this.icon = Icons.equalizer,
    this.onRefresh,
  }) : super(key: key);

  final String message;
  final IconData icon;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: height * .25,
            ),
            Icon(
              icon,
              color: ThemeProvider.of(context).primaryColor,
              size: height * 1 / 18,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.body2MediumHint.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themeData.primaryColorDark,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"))
          ]),
    );
  }
}

class _TextInputField extends StatelessWidget {
  final String initialValue;
  final String hint;
  final String displayTitle;
  final IconData icon;
  final Function(String val) validator;
  final Function(String val) onSaved;
  final bool isPassword;

  _TextInputField(
      {this.initialValue,
      this.hint,
      this.displayTitle,
      this.icon,
      this.isPassword = false,
      this.validator,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    BaseTheme _theme = BaseTheme.of(context);
    return TextFormField(
      enabled: true,
      obscureText: isPassword,
      textInputAction: TextInputAction.done,
      initialValue: initialValue,
      //autovalidate: false,
      validator: validator,
      keyboardType: TextInputType.text,
      minLines: isPassword ? 1 : 2,
      maxLines: isPassword ? 1 : 5,
      showCursor: true,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderSide: BaseBorderSide()),
          labelText: displayTitle,
          labelStyle: _theme.textfieldLabel.copyWith(),
          hintStyle: _theme.smallHint,
//            icon: Icon(icon, color: kHintColor, size: 18),
          contentPadding: EdgeInsets.symmetric(vertical: 1)),
      onChanged: onSaved,
      // onSaved: onSaved
    );
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/po_khat/po_khat_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/widgets/partials/lookup/item_lookup_field.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/utility.dart';

import 'model/pokhat_model.dart';

class SetPokhatitemView<T extends POkhatModel> extends StatefulWidget {
  final PokhatViewModel viewModel;
  final Function(POkhatModel pokhatModel) onNewItem;
  final T selected;
  final bool isEditPo;
  final int typeOfadding;
  const SetPokhatitemView({
    Key key,
    this.viewModel,
    this.isEditPo,
    this.typeOfadding,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _SetPokhatitemViewState createState() => _SetPokhatitemViewState();
}

class _SetPokhatitemViewState extends State<SetPokhatitemView> {
  double qty;
  ItemLookupItem selectedItem;
  UomTypes uom;
  List<LocationDtl> selectLocatn;
  List<LocationDtl> userSelectedLoc;
  TextEditingController qtyController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userSelectedLoc = [];
    qty = widget?.selected?.qty ?? 0;
    selectedItem = widget?.selected?.item;
    uom = widget?.selected?.uom ?? UomTypes(uomname: "PCS");
    selectLocatn = widget?.selected?.location;
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new Container(
          color: ThemeProvider.of(context).scaffoldBackgroundColor,
          height: height * .96,
          width: width,
          //alignment: Alignment.bottomCenter,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //SizedBox(height: height * .06),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: themeData.primaryColor,
                    child: Row(children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      widget.isEditPo == true
                          ? Text("Edit Item ",
                              textAlign: TextAlign.center,
                              style: theme.subhead1Bold.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500))
                          : Text("Add new Item ",
                              textAlign: TextAlign.center,
                              style: theme.subhead1Bold.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                    ]),
                  ),

                  _buildItemField(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: BaseTextField(
                            // isVector: true,
                            displayTitle: "qty",
                            controller: qtyController,
                            icon: Icons.account_balance_wallet_rounded,
                            //vector: AppVectors.direct,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,5}'))
                            ],
                            // initialValue: "",
                            isNumberField: true,
//                            onTap: () {
//                              qtyController.clear();
//                            },
                            onChanged: (val) {
                              var qtyData = double.parse(val);
                              qty = qtyData;

                              userSelectedLoc?.add(LocationDtl(
                                  id: 0,
                                  deliverylocationtabledataid:
                                      widget.viewModel.selectedLocation?.id,
                                  deliverylocationtableid: widget
                                      .viewModel.selectedLocation?.tableid,
                                  qty: qty));
                              selectLocatn = userSelectedLoc;
                              print("s ${selectLocatn.first.tableid}");
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter rate";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              var qtyData = double.parse(val);
                              qty = qtyData;
                              userSelectedLoc?.add(LocationDtl(
                                  id: 0,
                                  deliverylocationtabledataid:
                                      widget.viewModel.selectedLocation.id,
                                  deliverylocationtableid:
                                      widget.viewModel.selectedLocation.tableid,
                                  qty: qty));
                              selectLocatn = userSelectedLoc;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: uom != null ? false : true,
                        child: Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 12,
                                    right: width * .02,
                                    left: width * .043),
                                child: buildUomTypes())),
                      ),
                    ],
                  ),
                  // buildUomTypes(),

                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    margin:
                        EdgeInsets.only(right: width * .06, left: width * .06),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width,
                    child: BaseRaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor:
                          ThemeProvider.of(context).primaryColorDark,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (qty > 0) {
                            widget.viewModel.onAddNewItem(
                                khatItems: POKhatSaveModel(
                                    item: selectedItem,
                                    qty: qty,
                                    uom: uom ?? UomTypes(uomname: "PCS"),
                                    location: selectLocatn),
                                typeOfadding: widget.typeOfadding);
//
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Text("ADD"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    qtyController?.dispose();
  }

  Widget buildUomTypes() {
    return BaseDropDownField<UomTypes>(
      // style: TextStyle(color: Colors.white) ,
      label: "Tap to select",
      labelStyle: TextStyle(color: Colors.white),
      iconEnableColor: Colors.white,
      iconDisabledColor: Colors.white,
      errorStyle: TextStyle(color: Colors.white),
      validator: (val) =>
          selectedItem == null ? "Select UOM Type of item" : null,
      initialValue: uom ?? UomTypes(uomname: "PCS"),
      builder: (val) => Text("${val.uomname}"),
      items: <UomTypes>[...selectedItem?.uoms ?? []],
      onChanged: (val) => setState(() => uom = val),
    );
  }

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      // margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 2, left: 5),
            child: Icon(
              Icons.location_on_outlined,
              color: themeData.accentColor,
            ),
          ),
          Expanded(
            child: ItemLookupTextField(
              isVector: true,
              vector: AppVectors.itemBox,
              displayTitle: "Items",
              hint: "Select Item",
              initialValue: selectedItem,
              onChanged: (val) {
                var uomType = val.uoms.firstWhere((uom) => uom.defaultuomyn,
                    orElse: () => val?.uoms?.first);
                //setState(() {
                selectedItem = val;
                uom = uomType;
                //  });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PokhatItemView<T extends POkhatModel> extends StatelessWidget {
  final T pokhatItemModel;
  final Function(T, bool) onClick;
  final PokhatViewModel viewModel;
  final List<POKhatSaveModel> pokhatItems;

  PokhatItemView(
      {Key key,
      this.pokhatItemModel,
      this.onClick,
      this.viewModel,
      this.pokhatItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    bool isEditPo = false;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: themeData.primaryColor,
            // border: Border(bottom: BaseBorderSide())
          ),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            onPressed: () {
              isEditPo = true;
              onClick(pokhatItemModel, isEditPo = true);
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Name :",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(pokhatItemModel?.item?.description ?? "",
                            style: theme.subhead1),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Qty:",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                            (BaseNumberFormat(number: pokhatItemModel.qty)
                                        .formatCurrency())
                                    .toString() ??
                                "",
                            style: theme.subhead1),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Code :",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(pokhatItemModel?.item?.code ?? "",
                            style: theme.subhead1),
                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       "Uom:",
                    //       style: theme.smallHint,
                    //       textAlign: TextAlign.end,
                    //     ),
                    //     const SizedBox(
                    //       height: 3,
                    //     ),
                    //     Text(pokhatItemModel?.uom?.uomname ?? "",
                    //         style: theme.subhead1),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

showSelectedGradeInformation(
    BuildContext context,
    ItemGradeRateViewModel viewModel,
    GradeLookupItem selectedGrade,
    ItemLookupItem selectedItem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Information")),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          content: Container(
              height: height * .25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.announcement,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: Text(
                              "Grade ${selectedGrade.name}  is already selected for \n ${selectedItem.description}",
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: themeData.primaryColorDark,
                          color: _colors.white.withOpacity(.70),
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )));
    },
  );
}

showRateGraterThanZeroInformation(BuildContext context,
    ItemGradeRateViewModel viewModel, ItemLookupItem selectedItem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Information")),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          content: Container(
              height: height * .25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.announcement,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: Text(
                              "Please enter rate for ${selectedItem.description}",
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: themeData.primaryColorDark,
                          color: _colors.white.withOpacity(.70),
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )));
    },
  );
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/requisition/purchase_requisition/purchase_requestion_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/widgets/partials/lookup/item_lookup_field.dart';
import 'package:redstars/src/widgets/screens/requisition/model/requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

class ListPurchaseItem<T extends RequisitionModel> extends StatelessWidget {
  final T requisitionModel;
  final ValueSetter<T> onClick;
  final PurchaseRequisitionViewModel viewModel;

  const ListPurchaseItem(
      {Key key, this.requisitionModel, this.onClick, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Column(
      children: [
        Container(
          color: themeData.scaffoldBackgroundColor,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: themeData.scaffoldBackgroundColor,
                border: Border(
                    bottom: BaseBorderSide(color: themeData.primaryColor))),
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
              onPressed: () => onClick(requisitionModel),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(requisitionModel?.item?.description ?? "",
                            style: theme.subhead1
                                .copyWith(fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(requisitionModel?.item?.code ?? "",
                              style: theme.body),
                        ),
                      ],
                    )),
                    SizedBox(width: 22),
                    Column(
                      children: <Widget>[
                        Text(
                          "${requisitionModel?.qty ?? ""}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(requisitionModel?.uom?.uomname ?? "",
                              style: theme.body),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        //  SizedBox(height: 10),
      ],
    );
  }
}

class ListItemStock<T extends RequisitionModel> extends StatelessWidget {
  final T requisitionModel;
  final ValueSetter<T> onClick;
  final StockRequisitionViewModel viewModel;
  final List<StockRequisitionModel> requisitionItems;

  ListItemStock(
      {Key key,
      this.requisitionModel,
      this.onClick,
      this.viewModel,
      this.requisitionItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              border: Border(bottom: BaseBorderSide())),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            onPressed: () => onClick(requisitionModel),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(requisitionModel.item.description,
                          style: theme.subhead1),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child:
                            Text(requisitionModel.item.code, style: theme.body),
                      ),
                    ],
                  )),
                  SizedBox(width: 22),
                  Column(
                    children: <Widget>[
                      Text("${requisitionModel.qty}", style: theme.body),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Text(requisitionModel?.uom?.uomname ?? "",
                            style: theme.body),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class ItemStockView<T extends RequisitionModel> extends StatefulWidget {
  final StockRequisitionViewModel viewModel;
  final Function(RequisitionModel requisitionModel) onNewItem;
  final T selected;

  const ItemStockView({
    Key key,
    this.viewModel,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _ItemStockViewState createState() => _ItemStockViewState();
}

class _ItemStockViewState extends State<ItemStockView> {
  double quantity;
  ItemLookupItem selectedItem;
  UomTypes selectedUomType;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    quantity = widget?.selected?.qty ?? 0;
    selectedItem = widget?.selected?.item;
    selectedUomType = widget?.selected?.uom;
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
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //         bottom: BorderSide(
                    //             color: theme.colors.secondaryColor))),
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
                      Text("Add New Item",
                          textAlign: TextAlign.center,
                          style: theme.subhead1Bold.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ]),
                  ),

                  _buildItemField(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _NumberField(
                              quantity: quantity,
                              onSaved: (val) => setState(() => quantity = val)),
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 18,
                                    right: width * .02,
                                    left: width * .043),
                                child: buildUomTypes())),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    margin:
                        EdgeInsets.only(right: width * .05, left: width * .06),
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
                          widget.onNewItem(RequisitionModel(
                            item: selectedItem,
                            qty: quantity,
                            uom: selectedUomType,
                          ));
                          Navigator.pop(context);
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

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ItemLookupTextField(
            isVector: true,
            displayTitle: "Items",
            hint: "Select Item",
            initialValue: selectedItem,
            onChanged: (val) {
              widget.viewModel.onItemBudget(val);
              var uomType = val.uoms.firstWhere((uom) => uom.defaultuomyn,
                  orElse: () => val?.uoms?.first);
              //setState(() {
              selectedItem = val;
              selectedUomType = uomType;
              //  });
            },
          )),
        ],
      ),
    );
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
      initialValue: selectedUomType,
      builder: (val) => Text("${val.uomname}"),
      items: <UomTypes>[...selectedItem?.uoms ?? []],
      onChanged: (val) => setState(() => selectedUomType = val),
    );
  }
}

class ItemPurchaseView<T extends RequisitionModel> extends StatefulWidget {
  final PurchaseRequisitionViewModel viewModel;
  final Function(RequisitionModel requisitionModel) onNewItem;
  final T selected;

  const ItemPurchaseView({
    Key key,
    this.viewModel,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _ItemPurchaseViewState createState() => _ItemPurchaseViewState();
}

class _ItemPurchaseViewState extends State<ItemPurchaseView> {
  double quantity;
  ItemLookupItem selectedItem;
  UomTypes selectedUomType;
  DepartmentItem department;
  BranchStore branch;
  int departmentId;
  int branchId;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDepart = false;
  List<DepartmentItem> departs;

  @override
  void initState() {
    super.initState();
    quantity = widget?.selected?.qty ?? 0;
    selectedItem = widget?.selected?.item;
    selectedUomType = widget?.selected?.uom;
    department = widget?.selected?.department;
    branch = widget?.selected?.branch;
    departs = [];
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // List<DepartmentItem> departs = widget.viewModel.departmentList
    //     .where((element) => element?.branchid==branchId)
    //     .toList();
    // departs.forEach((element) {
    //   print(element.branchid);
    // });

    return new AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new Container(
          color: ThemeProvider.of(context).scaffoldBackgroundColor,
          height: height * .96,
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
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //         bottom: BorderSide(
                    //             color: theme.colors.secondaryColor))),
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
                      Text("Add New Item",
                          textAlign: TextAlign.center,
                          style: theme.subhead1Bold.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  BaseDialogField<BranchStore>(
                      initialValue: branch,
                      //  isEnabled: ,
                      list: widget.viewModel.branchStoreList,
                      listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            //  isVector: true,
                            vector: AppVectors.addnew,
                            // icon: Icons.approval,
                            title: val.name,
                            subTitle: val.code,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                      fieldBuilder: (selected) => Text(
                            selected.name,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                      onChanged: (val) {
                        setState(() {
                          isDepart = true;
                        });
                        branch = val;
                        isDepart = true;
                        branchId = val.id;
                        List<DepartmentItem> departs1 = widget
                            .viewModel.departmentList
                            .where((element) => element?.branchid == branchId)
                            .toList();
                        departs.addAll(departs1);
                        print("branch--${branch}+$branchId");
                      },
                      displayTitle: "Branch"),
                  BaseDialogField<DepartmentItem>(
                      isEnabled: isDepart,
                      list: departs,
                      initialValue: department,
                      // widget.viewModel.departmentList,
                      listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            isVector: true,
                            vector: AppVectors.transactionType,
                            icon: Icons.approval,
                            title: val.description,
                            subTitle: val.code,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                      fieldBuilder: (selected) => Text(
                            selected.description,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                      onChanged: (val) {
                        department = val;
                        departmentId = val.departmentid;
                        print("department--${department}+$departmentId");
                      },
                      displayTitle: "Department"),

                  _buildPurchaseItemField(),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _NumberField(
                              quantity: quantity,
                              onSaved: (val) => setState(() => quantity = val)),
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 18,
                                    right: width * .02,
                                    left: width * .043),
                                child: buildUomTypes())),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    margin:
                        EdgeInsets.only(right: width * .05, left: width * .06),
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
                          widget.onNewItem(RequisitionModel(
                            item: selectedItem,
                            qty: quantity,
                            uom: selectedUomType,
                          ));
                          Navigator.pop(context);
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

  Widget _buildPurchaseItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      padding: EdgeInsets.only(top: 4, left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
              widget.viewModel.onPurchaseItemBudget(val, department, branch);
              setState(() {
                selectedItem = val;
                selectedUomType = uomType;
              });
            },
          )),
        ],
      ),
    );
  }

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      padding: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ItemLookupTextField(
            isVector: true,
            displayTitle: "Items",
            hint: "Select Item",
            initialValue: selectedItem,
            onChanged: (val) {
              var uomType = val.uoms.firstWhere((uom) => uom.defaultuomyn,
                  orElse: () => val?.uoms?.first);
              // widget
              setState(() {
                selectedItem = val;
                selectedUomType = uomType;
              });
            },
          )),
        ],
      ),
    );
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
      initialValue: selectedUomType,
      builder: (val) => Text("${val.uomname}"),
      items: <UomTypes>[...selectedItem?.uoms ?? []],
      onChanged: (val) => setState(() => selectedUomType = val),
    );
  }
}

class ItemView<T extends RequisitionModel> extends StatefulWidget {
  final Function(RequisitionModel requisitionModel) onNewItem;
  final T selected;

  const ItemView({
    Key key,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  double quantity;
  ItemLookupItem selectedItem;
  UomTypes selectedUomType;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    quantity = widget?.selected?.qty ?? 0;
    selectedItem = widget?.selected?.item;
    selectedUomType = widget?.selected?.uom;
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
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //         bottom: BorderSide(
                    //             color: theme.colors.secondaryColor))),
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
                      Text("Add New Item",
                          textAlign: TextAlign.center,
                          style: theme.subhead1Bold.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  _buildItemField(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _NumberField(
                              quantity: quantity,
                              onSaved: (val) => setState(() => quantity = val)),
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 18,
                                    right: width * .02,
                                    left: width * .043),
                                child: buildUomTypes())),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    margin:
                        EdgeInsets.only(right: width * .05, left: width * .06),
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
                          widget.onNewItem(RequisitionModel(
                            item: selectedItem,
                            qty: quantity,
                            uom: selectedUomType,
                          ));
                          Navigator.pop(context);
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

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      padding: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
              // widget
              setState(() {
                selectedItem = val;
                selectedUomType = uomType;
              });
            },
          )),
        ],
      ),
    );
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
      initialValue: selectedUomType,
      builder: (val) => Text("${val.uomname}"),
      items: <UomTypes>[...selectedItem?.uoms ?? []],
      onChanged: (val) => setState(() => selectedUomType = val),
    );
  }
}

class _NumberField extends StatefulWidget {
  final double quantity;
  final ValueSetter<double> onSaved;

  const _NumberField({Key key, this.quantity, this.onSaved}) : super(key: key);

  @override
  __NumberFieldState createState() => __NumberFieldState();
}

class __NumberFieldState extends State<_NumberField> {
  double quantity;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    quantity = widget?.quantity ?? 0;
    _controller = TextEditingController(text: quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    BaseTheme _theme = BaseTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 12),
            child: TextFormField(
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _theme.colors.white.withOpacity(0.70))),
                  prefixIcon: IconButton(
                    color: quantity > 0 ? Colors.red : Colors.white,
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 0)
                        setState(() {
                          quantity--;
                          _controller =
                              TextEditingController(text: quantity.toString());
                        });
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Color(0xFF0F8B20),
                    ),
                    onPressed: () {
                      setState(() {
                        quantity += 1;
                        _controller =
                            TextEditingController(text: quantity.toString());
                      });
                    },
                  ),
                ),
                textAlign: TextAlign.center,
                style: BaseTheme.of(context).subhead1Bold,
                minLines: 1,
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                validator: (String val) => (val.isEmpty)
                    ? "Please enter quantity "
                    : double.parse(val) > 0
                        ? null
                        : "Quantity cannot be 0",
                onChanged: (val) =>
                    setState(() => quantity = double.parse(val)),
                onSaved: (String val) => widget.onSaved(double.parse(val))
//                      setState(() => quantity = double.parse(val))
                ),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

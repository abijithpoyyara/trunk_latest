import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/payment_requisition/payment_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

import '_model/tax_dtl_model.dart';

class PaymentRequisitionTaxView extends StatefulWidget {
  final PaymentRequisitionDtlModel requisitionModel;

  const PaymentRequisitionTaxView({
    Key key,
    this.requisitionModel,
  }) : super(key: key);

  @override
  _PaymentRequisitionTaxViewState createState() =>
      _PaymentRequisitionTaxViewState();
}

class _PaymentRequisitionTaxViewState extends State<PaymentRequisitionTaxView> {
  PaymentRequisitionDtlModel requisitionModel;
  List<TaxDetailModel> taxes;

  @override
  void initState() {
    super.initState();
    requisitionModel = widget.requisitionModel;
    taxes = requisitionModel?.taxes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PaymentRequisitionViewModel>(
      appBar: BaseAppBar(title: Text(requisitionModel.ledger.description)),
      builder: (context, viewModel) {
        BaseTheme theme = BaseTheme.of(context);
        BaseColors colors = BaseColors.of(context);
        ThemeData themeData = ThemeProvider.of(context);

        double height=MediaQuery.of(context).size.height;
        double width=MediaQuery.of(context).size.width;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Stack(children: <Widget>[
                if (taxes?.isNotEmpty ?? false)
                  ListView.builder(
                    itemBuilder: (con, position) {
                      TaxDetailModel object = taxes[position];
                      return Dismissible(
                          onDismissed: (direction) {
                            setState(() {
                              taxes.removeWhere((e) {
                                return e.tax.attachmentid ==
                                    object.tax.attachmentid;
                              });
                            });
                          },
                          background: Container(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: _buildDeleteButton(theme))),
                          secondaryBackground: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: _buildDeleteButton(theme))
                                  ])),
                          key: Key(object?.tax?.attachment ?? ""),
                          confirmDismiss: (direction) => appChoiceDialog(
                              message: "Do you want to delete this record",
                              context: con),
                          child: ListItem(
                            taxDtl: object,
                            onClick: (selected) async {
                              TaxDetailModel tax = await showItemAddSheet(
                                con,
                                viewModel,
                                selected: selected,
                              );
                              bool _found = false;
                              List tempTaxes = taxes.map((e) {
                                if (e.tax.attachmentid ==
                                    tax.tax.attachmentid) {
                                  _found = true;
                                  return tax;
                                } else
                                  return e;
                              }).toList();
                              if (!_found) tempTaxes.add(tax);
                              setState(() {
                                taxes = tempTaxes;
                              });
                            },
                          ));
                    },
                    itemCount: taxes?.length ?? 0,
                  )
                else
                  emptyView(theme, colors),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                        onPressed: () async {
                          TaxDetailModel tax =
                              await showItemAddSheet(context, viewModel);
                          bool _found = false;
                          List tempTaxes = taxes.map((e) {
                            if (e.tax.attachmentid == tax.tax.attachmentid) {
                              _found = true;
                              return tax;
                            } else
                              return e;
                          }).toList();
                          if (!_found) tempTaxes.add(tax);
                          setState(() {
                            taxes = tempTaxes;
                          });
                        },
                        heroTag: "items",
                        autofocus: true,
                        child: Icon(Icons.add_shopping_cart)))
              ])),
              if (taxes?.isNotEmpty ?? false)
                Container(
                  height:height*.12 ,
                  width: width*.2,
                 padding: EdgeInsets.all(12),
                 // margin: EdgeInsets.symmetric(horizontal: 8),
                  child: BaseRaisedButton(
                    backgroundColor: themeData.primaryColorDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                   // padding: EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () {
                      requisitionModel.taxes = taxes;
                      Navigator.pop(context, requisitionModel);
                    },
                    child: Text("ADD TO REQUISITION"),
                  ),
                )
            ]);
      },
      converter: (store) => PaymentRequisitionViewModel.fromStore(store),
    );
  }

  Future<TaxDetailModel> showItemAddSheet(
    BuildContext context,
    PaymentRequisitionViewModel viewModel, {
    TaxDetailModel selected,
  }) async {
    return showModalBottomSheet<TaxDetailModel>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => ItemView(
        selected: selected,
        taxes: viewModel.taxConfigs,
        requisitionAmount: requisitionModel.amount,
      ),
    );
  }

  Widget _buildDeleteButton(BaseTheme theme, {bool reverse = false}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget emptyView(BaseTheme theme, BaseColors colors) {
    return
      Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Icon(Icons.remove_shopping_cart,
                color: ThemeProvider.of(context).primaryColorDark.withOpacity(.4), size: 64),
            SizedBox(height: 8),
            Text(
              "No Taxes added",
              style: theme.body2.copyWith(fontSize: 16),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}

class ListItem extends StatelessWidget {
  final TaxDetailModel taxDtl;
  final ValueSetter<TaxDetailModel> onClick;

  const ListItem({
    Key key,
    this.taxDtl,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
      color: themeData.scaffoldBackgroundColor,

      child: Container(
          margin: EdgeInsets.only(right: 15,left: 15),
          decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              border: Border(
                  bottom: BaseBorderSide(
                      color: themeData.primaryColorDark.withOpacity(.70)))),
          child: IntrinsicHeight(
              child: FlatButton(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  onPressed: () => onClick(taxDtl),
                  child: IntrinsicHeight(
                      child: Row(children: <Widget>[
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(taxDtl.tax.attachment, style: theme.subhead1),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text('${taxDtl?.taxDtl?.taxperc??""} %',
                                  style: theme.body))
                        ])),
                    SizedBox(width: 22),
                    Column(children: <Widget>[
//                    Text("Amount", style: theme.body),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text("${taxDtl?.taxedAmount??""}"))
                    ]),
                    SizedBox(width: 4)
                  ]))))),
    );
  }
}

class ItemView extends StatefulWidget {
  final TaxDetailModel selected;
  final List<TaxConfigModel> taxes;
  final double requisitionAmount;

  const ItemView({
    Key key,
    this.selected,
    this.requisitionAmount,
    @required this.taxes,
  }) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  double amount;
  TaxConfigModel selectedItem;
  TaxDtlModel selectedTaxDtl;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amount = widget?.selected?.taxedAmount ?? 0;
    selectedItem = widget?.selected?.tax;
    selectedTaxDtl = widget?.selected?.taxDtl;
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
            height: height * .96,
            alignment: Alignment.topCenter,
            color: themeData.scaffoldBackgroundColor,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ]),
                          ),
                          _buildItemField(),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(children: <Widget>[
                                Expanded(child: buildTaxTypes()),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: 13,
                                  ),
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white
                                                  .withOpacity(.70)))),
                                  child: Column(
                                    children: [
                                      Text("Calculated Tax", style: theme.body),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(top: 4, left: 4),
                                          child: Text("${amount ?? 0}",
                                              style: theme.subhead1))
                                    ],
                                  ),
                                ))
                              ])),
                          SizedBox(height: height * .07),
                          Container(
                              height: height * .07,
                              width: width,
                              margin:
                                  EdgeInsets.only(left: width * .09, right: 20),
                              child: BaseRaisedButton(
                                  backgroundColor: themeData.primaryColorDark,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      Navigator.pop(
                                          context,
                                          TaxDetailModel(
                                              tax: selectedItem,
                                              taxDtl: selectedTaxDtl,
                                              taxedAmount: amount,
                                              totalAmount:
                                                  widget.requisitionAmount));
                                    }
                                  },
                                  child: Text("ADD")))
                        ])))));
  }

  Widget _buildItemField() {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: BaseDialogField(
                isVector: true,
                displayTitle: "Tax",
                initialValue: selectedItem,
                onChanged: (val) {
                  setState(() {
                    selectedItem = val;
                    selectedTaxDtl = selectedItem?.taxdtl?.first;
                    amount =
                        selectedTaxDtl.taxperc * widget.requisitionAmount / 100;
                  });
                },
                listBuilder: (TaxConfigModel value, int pos) {
                  return DocumentTypeTile(
                    vector: AppVectors.advance,
                    onPressed: () => Navigator.pop(context, value),
                    title: value.attachmentdesc,
                    subTitle: value.attachment,
                    selected: true,
                  );
                },
                list: widget.taxes,
                fieldBuilder: (TaxConfigModel selected) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected?.attachment ?? "",
                        style: BaseTheme.of(context).textfield,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (selected.effectonparty > 0)
                      Icon(Icons.add_box)
                    else
                      Icon(Icons.indeterminate_check_box)
                  ],
                ),
              ))
            ]));
  }

  Widget buildTaxTypes() {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width * .08),
      child: BaseDropDownField<TaxDtlModel>(
        iconDisabledColor: Colors.white,
        iconEnableColor: Colors.white,
        validator: (val) => selectedItem == null ? "Select tax type" : null,
        hint: "Tax Type",
        initialValue: selectedTaxDtl,
        builder: (val) => Text("${val.taxperc}"),
        items: <TaxDtlModel>[...selectedItem?.taxdtl ?? []],
        onChanged: (val) {
          setState(() {
            selectedTaxDtl = val;
            amount = val.taxperc * widget.requisitionAmount / 100;
          });
        },
      ),
    );
  }
}

class _NumberField extends StatefulWidget {
  final double amount;
  final ValueSetter<double> onSaved;

  const _NumberField({Key key, this.amount, this.onSaved}) : super(key: key);

  @override
  __NumberFieldState createState() => __NumberFieldState();
}

class __NumberFieldState extends State<_NumberField> {
  double amount;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    amount = widget?.amount ?? 0;
    _controller = TextEditingController(text: amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              color: amount > 0 ? Colors.red : Colors.grey,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (amount > 0)
                  setState(() {
                    amount--;
                    _controller =
                        TextEditingController(text: amount.toString());
                  });
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                  textAlign: TextAlign.center,
                  style: BaseTheme.of(context).subhead1Bold,
                  minLines: 1,
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  validator: (String val) => (val.isEmpty)
                      ? "Please amount"
                      : double.parse(val) > 0
                          ? null
                          : "amount cannot be 0",
                  onChanged: (val) =>
                      setState(() => amount = double.parse(val)),
                  onSaved: (String val) => widget.onSaved(double.parse(val))
//                      setState(() => quantity = int.parse(val))
                  ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  amount += 1;
                  _controller = TextEditingController(text: amount.toString());
                });
              },
            )
          ],
        ));
    ;
  }
}

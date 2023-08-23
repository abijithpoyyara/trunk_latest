import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/payment_voucher/payment_voucher_viewmodel.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';

class ItemAccountView<T extends PaymentVoucherDtlModel> extends StatefulWidget {
  final PaymentVoucherViewModel viewModel;
  final Function(PaymentVoucherDtlModel requisitionModel) onNewItem;
  final T selected;

  const ItemAccountView({
    Key key,
    this.viewModel,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _ItemAccountViewState createState() => _ItemAccountViewState();
}

class _ItemAccountViewState extends State<ItemAccountView> {
  ServiceList selectedItem;
  double amount;
  BudgetDtlModel budgeDt;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amount = widget?.selected?.amount ?? 0;
    selectedItem = widget?.selected?.serviceList;
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themedata = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String result = selectedItem.toString();

    return new AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new Container(
          color: themedata.primaryColor,
          height: height * .96,
          //alignment: Alignment.bottomCenter,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: height * .06),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: ThemeProvider.of(context).primaryColorDark,
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
                  _buildItemField(context, widget.viewModel),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: _NumberField(
                                amount: amount,
                                onSaved: (val) =>
                                    setState(() => amount = val))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
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
                      backgroundColor: themedata.primaryColorDark,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          widget?.onNewItem(PaymentVoucherDtlModel(
                              serviceList: selectedItem,
                              service: acctName,
                              // budgetList: budgeDt,
                              budgetList: widget.viewModel.budgetDtl.isNotEmpty
                                  ? widget.viewModel?.budgetDtl?.first
                                  : null,
                              currencyName: currencyName,
                              amount: amount,
                              exchangeRate: exrate));

                          print(widget.viewModel.acctDetails.length);
                          if (widget.viewModel.budgetDtl.isNotEmpty)
                            print(
                                "budget${widget.viewModel.budgetDtl.first.accountid}");

                          print(
                              "dtlModel${widget.selected?.serviceList?.description}");
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

  var acctName;
  List<ServiceList> serviceList;
  String findAccountName(String serviceAcct) {
    serviceList.forEach((element) {
      if (element.description == serviceAcct) {
        return acctName = element.accountname;
      }
    });
    return acctName;
  }

  int companyCurrencyId;
  int branchCurrencyId;
  var exrate;
  Future<double> findExchangeRate() async {
    branchCurrencyId = await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    companyCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);
    print(companyCurrencyId);
    widget.viewModel.currencyExchange.forEach((element) {
      if (element.fromcurrencyid == branchCurrencyId &&
          element.tocurrencyid == companyCurrencyId) {
        print("exe${element.conversionrate}");
        exrate = element.conversionrate;
      }
    });
    print(exrate);
    return exrate;
  }

  var currencyName;
  Future<String> findCurrency() async {
    branchCurrencyId = await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    companyCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);
    print(companyCurrencyId);
    widget.viewModel.currencyExchange.forEach((element) {
      if (element.fromcurrencyid == branchCurrencyId &&
          element.tocurrencyid == companyCurrencyId) {
        print("exe${element.conversionrate}");
        currencyName = element.fromcurrencyname;
      }
    });
    print(currencyName);

    return currencyName;
  }

  Widget _buildItemField(
      BuildContext context, PaymentVoucherViewModel viewModel) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    BaseColors colors = BaseColors.of(context);
    String data = selectedItem.toString();
    serviceList = viewModel.serviceList
        .where(
            (element) => element?.optioncode?.contains("PURCHASE_ORDER_KHAT"))
        .toList();
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
      margin: EdgeInsets.only(left: 3),
      // margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      padding: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              color: themedata.primaryColor,
              child: BaseDialogField<ServiceList>(
                isChangeHeight: false,
                vector: AppVectors.transaction,
                hint: "Tap select data",
                displayTitle: "Service Types",
                // icon: icon ?? Icons.dashboard,
                list: serviceList,
                initialValue: selectedItem,
                isEnabled: selectedItem?.description == null ? true : false,
                listBuilder: (val, pos) => DocumentTypeTile(
                  selected: true,
                  subTitle: val.code,
                  //isVector: true,,
                  // vector: vector,
                  icon: Icons.list,
                  title: val.description,
                  vector: AppVectors.transaction,
                  onPressed: () => Navigator.pop(context, val),
                ),
                fieldBuilder: (selected) => Text(
                  selected.description,
                  style: BaseTheme.of(context).textfield,
                  textAlign: TextAlign.start,
                ),
                onChanged: (val) {
                  setState(() {
                    selectedItem = val;
                    widget.viewModel.getBudgetDtl(val);
                    widget.selected?.budgetList =
                        widget?.viewModel.budgetDtl.isNotEmpty
                            ? widget.viewModel.budgetDtl.first
                            : null;
                    findAccountName(selectedItem.description);
                    findExchangeRate();
                    print("exchange${companyCurrencyId}");
                    findCurrency();
                  });
                },
                // onSaved: (val) {
                //   selectedItem = val;
                //   widget.viewModel.getBudgetDtl(val);
                //   widget.selected?.budgetList =
                //       widget.viewModel.budgetDtl.isNotEmpty
                //           ? widget.viewModel?.budgetDtl?.first
                //           : null;
                //   // widget.selected?.budgetList = budgeDt;
                // },

                // validator: (val) =>
                // (isMandatory && val == null) ? "Please select $title " : null,
                // displayTitle: title + (isMandatory ? " * " : ""),
                //
                // onSaved: onSaved,
                // onChanged: onChanged,
//          onSaved: (val) {}
              ),
            ),
          ),
        ],
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
    amount = widget?.amount;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(left: height * .05, right: 8),
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
//            IconButton(
//              color: amount > 0 ? Colors.red : Colors.grey,
//              icon: Icon(Icons.arrow_back_ios),
//              onPressed: () {
//                if (amount > 0)
//                  setState(() {
//                    amount--;
//                    _controller =
//                        TextEditingController(text: amount.toString());
//                  });
//              },
//            ),

            Expanded(
              child: TextFormField(
                  cursorColor: theme.colors.white.withOpacity(.70),
                  decoration: InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colors.white.withOpacity(.70))),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colors.white.withOpacity(.70))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colors.white.withOpacity(.70))),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colors.white.withOpacity(.70))),
                      errorStyle: theme.subhead1.copyWith(
                          fontSize: 14,
                          color: theme.colors.white.withOpacity(.70)),
                      labelStyle: theme.subhead1Bold
                          .copyWith(color: theme.colors.white.withOpacity(.70)),
                      hintText: "Enter Amount",
                      hintStyle: theme.subhead1Bold.copyWith(
                          color: theme.colors.white.withOpacity(.70))),
                  textAlign: TextAlign.left,
                  style: BaseTheme.of(context).subhead1Bold,
                  minLines: 1,
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  validator: (String val) => (val.isEmpty)
                      ? "Please enter amount"
                      : double.parse(val) > 0
                          ? null
                          : "Amount cannot be 0",
                  onChanged: (val) =>
                      setState(() => amount = double.parse(val)),
                  onSaved: (String val) => widget.onSaved(double.parse(val))
//                      setState(() => quantity = int.parse(val))
                  ),
            ),
            SizedBox(width: 8),
//            IconButton(
//              icon: Icon(
//                Icons.arrow_forward_ios,
//                color: Colors.green,
//              ),
//              onPressed: () {
//                setState(() {
//                  amount += 1;
//                  _controller = TextEditingController(text: amount.toString());
//                });
//              },
//            )
          ],
        ));
    ;
  }
}

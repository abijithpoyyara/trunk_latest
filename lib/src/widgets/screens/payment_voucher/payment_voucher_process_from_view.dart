import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/payment_voucher/payment_voucher_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/widgets/partials/lookup/payment_voucher/voucher_service_lookup_field.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/partial/account_detail_form.dart';

import '../../../../utility.dart';
import 'model/payment_voucher_model.dart';

class PaymentVoucherProcessFrom extends StatefulWidget {
  final VoucherPurchaseOder processedData;
  final String title;

  const PaymentVoucherProcessFrom({Key key, this.processedData, this.title})
      : super(key: key);

  @override
  _PaymentVoucherProcessFromState createState() =>
      _PaymentVoucherProcessFromState();
}

class _PaymentVoucherProcessFromState extends State<PaymentVoucherProcessFrom> {
  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    return BaseView<AppState, PaymentVoucherViewModel>(
      init: (store, con) {
        store.dispatch(fetchVoucherInitialData());
        store.dispatch(
            fetchVoucherPOFillDetails(id: widget.processedData.dtlid));
        store.dispatch(fetchServiceList());
      },
      converter: (store) => PaymentVoucherViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: BaseAppBar(
            title: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.processedData?.transno ?? ""),
                  Text(widget.processedData?.transactiondate ?? "")
                ],
              ),
            ),
          ),
          body: PaymentVoucherForm(
            viewModel: viewModel,
          ),

          // : EmptyResultView(),
        );
      },
    );
  }
}

Row buildRow({String title, String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, textAlign: TextAlign.left),
      Text(
        value,
        textAlign: TextAlign.right,
      )
    ],
  );
}

class PaymentVoucherForm extends StatefulWidget {
  final PaymentVoucherViewModel viewModel;

  const PaymentVoucherForm({Key key, this.viewModel}) : super(key: key);
  @override
  _PaymentVoucherFormState createState() => _PaymentVoucherFormState();
}

class _PaymentVoucherFormState extends State<PaymentVoucherForm> {
  String pay;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PaymentVoucherHdrModel paymentHdr;
  ServiceLookupItem _selectedCashier;
  String selectedPaymentMode;
  BCCModel _selectedPaidFrom;
  BCCModel _selectedInstrumentType;
  BCCModel _selectSettlementypes;
  BCCModel _selectedBankPaidFrom;
  BCCModel _selectedBankInstrumentType;
  String remarks;
  String instNo;
  DateTime currentDate = DateTime.now();
  int settlewithin;
  DateTime tillDate;

  @override
  void initState() {
    paymentHdr = PaymentVoucherHdrModel();
    selectedPaymentMode = widget.viewModel.paymentMode;
    _selectedInstrumentType = widget.viewModel.selectedInstrumentType;
    _selectedPaidFrom = widget.viewModel.selectedPaidFrom;
    _selectedBankInstrumentType = widget.viewModel.selectedBankInstrumentType;
    _selectedBankPaidFrom = widget.viewModel.selectedBankPaidFrom;
    _selectedCashier = widget.viewModel.cashier;
    _selectSettlementypes = widget.viewModel.selectedSettlementType;
    //paymentHdr.settlementTypes;
    remarks = widget.viewModel.remarks;
    instNo = widget.viewModel.instNo;
    settlewithin = widget.viewModel.settlewithin;
    tillDate = widget.viewModel.tillDate;
    //paymentHdr.settleWithinDays;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    ThemeData themedata = ThemeProvider.of(context);
    print(widget.viewModel.paymentMode);
    BCCModel _selectedTransType;
    BCCModel _selectedServiceType;
    bool hasRequestRights, hasDtlRights, hasTaxRights;
    DateTime withinDate;

    BaseTheme style = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);

    String findPaidToType(int id) {
      var paidToType;
      widget.viewModel.requesters.forEach((element) {
        if (element.id == id) {
          paidToType = element.description;
        }
      });
      return paidToType;
    }

    String findPaymentType(int id) {
      var paymentType;
      widget.viewModel.paymentTypes.forEach((element) {
        if (element.id == id) {
          print("payment Type ${element.description}");
          paymentType = element.description;
        }
      });
      return paymentType;
    }

    List<BCCModel> paidFromCash = widget.viewModel.voucherTypes
        .where((element) => element?.typebcccode?.contains("CASH"))
        .toList();
    List<BCCModel> paidFromBank = widget.viewModel.voucherTypes
        .where((element) => element?.typebcccode?.contains("BANK"))
        .toList();

    List<BCCModel> instBank = widget.viewModel.instrumentTypes
        .where((element) => !element.code.contains("CA"))
        .toList();
    List<BCCModel> instCash = widget.viewModel.instrumentTypes
        .where((element) => element.code.contains("CA"))
        .toList();

    return Container(
      color: themedata.primaryColor.withOpacity(.19),
      child: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Column(children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Flexible(
                          flex: 1,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.viewModel.poProcessList.length,
                              itemBuilder: (context, index) {
                                var order =
                                    widget.viewModel.poProcessList[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Card(
                                    elevation: 0,
                                    color: themedata.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          buildRow(
                                              title: "Paid To ",
                                              value: widget
                                                      .viewModel
                                                      .poProcessList[index]
                                                      ?.paidto ??
                                                  ""),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          buildRow(
                                              title: "Paid To Type",
                                              value: findPaidToType(order
                                                      .analysiscodetypeid) ??
                                                  ""),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          buildRow(
                                              title: "Date",
                                              value: (BaseDates(DateTime.now())
                                                          .formatDate)
                                                      .toString() ??
                                                  ""),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          buildRow(
                                              title: "Payment Type ",
                                              value: findPaymentType(
                                                      order.transtypebccid) ??
                                                  ""),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      // Divider(
                      //   color: themedata.primaryColor,
                      // ),
                      Flexible(
                        child: Container(
                          //  margin: EdgeInsets.only(bottom: 2),
                          color: themedata.primaryColor,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 0),
                                child: Text("Payment Mode"),
                              ),
                              Flexible(
                                child: RadioListTile<String>(
                                    title: Text(
                                      "Cash",
                                      style: TextStyle(fontSize: 11.5),
                                    ),
                                    value: 'cash',
                                    selected: true,
                                    groupValue: selectedPaymentMode,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.viewModel
                                            .onPaymentModeChange(val);
                                        // widget.viewModel.onModeClear();
                                        selectedPaymentMode = val;
                                        _selectedBankInstrumentType = null;
                                        _selectedBankPaidFrom = null;
                                        _selectedInstrumentType = null;
                                        _selectedPaidFrom = null;
                                        print(widget.viewModel.paymentMode);
                                        paymentHdr.paymentMode =
                                            selectedPaymentMode;
                                      });
                                    }),
                              ),
                              Flexible(
                                child: RadioListTile<String>(
                                    title: Text(
                                      "Bank",
                                      style: TextStyle(fontSize: 11.5),
                                    ),
                                    value: 'bank',
                                    groupValue: selectedPaymentMode,
                                    selected: false,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.viewModel
                                            .onPaymentModeChange(val);
                                        // widget.viewModel.onModeClear();
                                        String data = val;
                                        selectedPaymentMode = data;
                                        _selectedCashier = null;
                                        _selectedInstrumentType = null;
                                        _selectedBankInstrumentType = null;
                                        _selectedBankPaidFrom = null;
                                        _selectedPaidFrom = null;
                                        // widget.viewModel.voucherTypes.clear();
                                        //  widget.viewModel.instrumentTypes
                                        //.clear();
                                        print("paymode$val");
                                        print("paymode$selectedPaymentMode");
                                        paymentHdr.paymentMode =
                                            selectedPaymentMode;
                                        print("re${paymentHdr.paymentMode}");
                                        print(widget.viewModel.paymentMode);
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Divider(
                      //   color:themedata.primaryColor,
                      // ),

                      Visibility(
                        visible: selectedPaymentMode == 'cash',
                        child: Flexible(
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            color: themedata.primaryColor,
                            child: BaseDialogField<BCCModel>(
                              isChangeHeight: false,
                              vector: AppVectors.transaction,
                              hint: "Tap select data",
                              validator: (val) {
                                return val == null
                                    ? "Please select instrument type"
                                    : null;
                              },

                              displayTitle: "Instrument Types",
                              // icon: icon ?? Icons.dashboard,
                              list: instCash,
                              initialValue: _selectedInstrumentType,
                              // paymentHdr.instrumentTypes,
                              isEnabled: true,
                              listBuilder: (val, pos) => DocumentTypeTile(
                                selected: true,
                                subTitle: val.code,
                                icon: Icons.list,
                                title: val.name,
                                vector: AppVectors.transaction,
                                onPressed: () => Navigator.pop(context, val),
                              ),
                              fieldBuilder: (selected) => Text(
                                selected.name,
                                style: BaseTheme.of(context).textfield,
                                textAlign: TextAlign.start,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _selectedInstrumentType = val;
                                  widget.viewModel.setField(paymentHdr.copyWith(
                                      instrumentTypes: val));
                                  paymentHdr.instrumentTypes = val;
                                });
                              },

                              onSaved: (val) {
                                setState(() {
                                  paymentHdr.instrumentTypes = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedPaymentMode == 'bank',
                        child: Flexible(
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            color: themedata.primaryColor,
                            child: BaseDialogField<BCCModel>(
                              isChangeHeight: false,
                              vector: AppVectors.transaction,
                              hint: "Tap select data",
                              validator: (val) {
                                return val == null
                                    ? "Please select instrument type"
                                    : null;
                              },
                              displayTitle: "Instrument Types",
                              // icon: icon ?? Icons.dashboard,
                              list: instBank,
                              initialValue: _selectedBankInstrumentType,
                              //paymentHdr.instrumentTypes,
                              isEnabled: true,
                              listBuilder: (val, pos) => DocumentTypeTile(
                                selected: true,
                                subTitle: val.code,
                                //isVector: true,,
                                // vector: vector,
                                icon: Icons.list,
                                title: val.name,
                                vector: AppVectors.transaction,
                                onPressed: () => Navigator.pop(context, val),
                              ),
                              fieldBuilder: (selected) => Text(
                                selected.name,
                                style: BaseTheme.of(context).textfield,
                                textAlign: TextAlign.start,
                              ),
                              // validator: (val) => val != null
                              //  ? "Please select instrument type"
                              // : null,
                              onChanged: (val) {
                                widget.viewModel.setField(paymentHdr.copyWith(
                                    instrumentBankTypes: val));
                                paymentHdr.instrumentBankTypes = val;
                                _selectedBankInstrumentType = val;
                              },
                              onSaved: (val) {
                                paymentHdr.instrumentBankTypes = val;
                              },
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: selectedPaymentMode == 'cash',
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          color: themedata.primaryColor,
                          child: BaseDialogField<BCCModel>(
                            isChangeHeight: false,
                            vector: AppVectors.requestFrom,
                            hint: "Tap select data",
                            displayTitle: "Paid From",
                            list: paidFromCash,
                            initialValue: _selectedPaidFrom,
                            validator: (val) {
                              return val == null
                                  ? "Please select paid from"
                                  : null;
                            },
                            // paymentHdr.voucherTypes,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                              selected: true,
                              subTitle: val.currencycode,
                              //isVector: true,,
                              vector: AppVectors.requestFrom,
                              icon: Icons.list,
                              title: val.bookaccountname,
                              onPressed: () => Navigator.pop(context, val),
                            ),
                            fieldBuilder: (selected) => Text(
                              selected.bookaccountname,
                              style: BaseTheme.of(context).textfield,
                              textAlign: TextAlign.start,
                            ),
                            onChanged: (val) {
                              paymentHdr.voucherTypes = val;
                              _selectedPaidFrom = val;
                              widget.viewModel.onGetCashBalance(val);
                              widget.viewModel.setField(
                                  paymentHdr.copyWith(voucherTypes: val));
                            },
                            onSaved: (val) {
                              paymentHdr.voucherTypes = val;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedPaymentMode == 'bank',
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          color: themedata.primaryColor,
                          child: BaseDialogField<BCCModel>(
                            isChangeHeight: false,
                            vector: AppVectors.requestFrom,
                            hint: "Tap select data",
                            displayTitle: "Paid From",
                            validator: (val) {
                              return val == null
                                  ? "Please select paid from"
                                  : null;
                            },
                            list: paidFromBank,
                            initialValue: _selectedBankPaidFrom,
                            //paymentHdr.voucherTypes,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                              selected: true,
                              subTitle: val.currencycode,
                              //isVector: true,,
                              vector: AppVectors.requestFrom,
                              icon: Icons.list,
                              title: val.bookaccountname,
                              onPressed: () => Navigator.pop(context, val),
                            ),
                            fieldBuilder: (selected) => Text(
                              selected.bookaccountname,
                              style: BaseTheme.of(context).textfield,
                              textAlign: TextAlign.start,
                            ),
                            onChanged: (val) {
                              // setState(() {
                              _selectedBankPaidFrom = val;
                              paymentHdr.voucherBankTypes = val;
                              widget.viewModel.onGetBalance(val);
                              widget.viewModel.setField(
                                  paymentHdr.copyWith(voucherBankTypes: val));

                              //  });
                            },
                            onSaved: (val) {
                              paymentHdr.voucherBankTypes = val;
                            },
                          ),
                        ),
                      ),
                      //  if (widget.viewModel.cashAcctBalanceList.isNotEmpty)
                      Visibility(
                          visible: selectedPaymentMode == 'cash',
                          child: _buildTextField(
                              widget.viewModel.cashAcctBalanceList.isNotEmpty
                                  ? widget.viewModel?.cashAcctBalanceList?.first
                                      ?.closing
                                      ?.toString()
                                  : "0.0",
                              false,
                              "Balance",
                              AppVectors.paymentType,
                              Icons.account_circle,
                              isEnabled: false, onChanged: (val) {
                            paymentHdr?.accountBalance?.closing = val as double;
                          }, onSaved: (val) {
                            setState(() {
                              paymentHdr?.accountBalance?.closing =
                                  val as double;
                            });
                          })),
                      // if (hasRequestRights)

                      Visibility(
                        visible: selectedPaymentMode == 'cash',
                        child: Container(
                            color: themedata.primaryColor,
                            padding: EdgeInsets.only(top: 10),
                            child: VoucherServiceLookupTextField(
                              isEnabled: true,
                              vector: BaseVectors.appearance,
                              initialValue: _selectedCashier,
                              //paymentHdr?.requestFromName,
                              flag: 10,
                              hint: "Tap select data",
                              displayTitle: "Cashier" + " * ",
                              onChanged: (val) {
                                paymentHdr?.requestFromName = val;
                                _selectedCashier = val;
                                widget.viewModel.onCashierBalance(val);
                                widget.viewModel.setField(
                                    paymentHdr.copyWith(requestFromName: val));
                              },
                              onSaved: (val) {
                                paymentHdr?.requestFromName = val;
                                _selectedCashier = val;
                              },
                            )),
                      ),
                      if (widget.viewModel.cashierBalanceList.isNotEmpty)
                        Visibility(
                          visible: selectedPaymentMode == 'cash',
                          child: _buildTextField(
                              widget.viewModel.cashierBalanceList.isNotEmpty
                                  ? widget.viewModel?.cashierBalanceList?.first
                                      ?.closing
                                      ?.toString()
                                  : "0.0",
                              false,
                              "CashierBalance",
                              AppVectors.paymentType,
                              Icons.account_circle,
                              isEnabled: false, onChanged: (val) {
                            paymentHdr?.cashierBalance?.closing = val as double;
                          }, onSaved: (val) {
                            setState(() {
                              paymentHdr?.cashierBalance?.closing =
                                  val as double;
                            });
                          }),
                        ),

                      _buildTextField(
                          instNo,
                          selectedPaymentMode == 'bank' &&
                                  _selectedBankInstrumentType?.code == 'CQ'
                              ? true
                              : false,
                          "Instrument  No",
                          AppVectors.direct,
                          Icons.account_circle,
                          isEnabled: true, onChanged: (val) {
                        paymentHdr.instNo = val;
                      }, onSaved: (val) {
                        paymentHdr.instNo = val;
                      }),
                      Visibility(
                          visible: selectedPaymentMode == 'bank',
                          child: _buildTextField(
                              widget.viewModel.accountBalanceList.isNotEmpty
                                  ? widget.viewModel?.accountBalanceList?.first
                                      ?.closing
                                      ?.toString()
                                  : "0.0",
                              false,
                              "Balance",
                              AppVectors.paymentType,
                              Icons.account_circle,
                              isEnabled: false, onChanged: (val) {
                            paymentHdr?.accountBalance?.closing = val as double;
                          }, onSaved: (val) {
                            setState(() {
                              paymentHdr?.accountBalance?.closing =
                                  val as double;
                            });
                          })),
                      // _buildTextField(
                      //   "0",
                      //   // paymentHdr?.referenceNo,
                      //   true,
                      //   "Total Amount",
                      //   Icons.account_circle,
                      //   isEnabled: false,
                      //   onChanged: (val) =>
                      //       onValueChange(paymentHdr.copyWith(total: val)),
                      //   onSaved: (val) =>
                      //       onValueSave(paymentHdr.copyWith(total: val)),
                      // ),

                      Container(
                        color: themedata.primaryColor,
                        child: BaseDatePicker(
                          vector: AppVectors.calenderSettlement,
                          hint: "Instrument Date",
                          icon: Icons.date_range,
                          initialValue: DateTime.now(),
                          isEnabled: true,
                          autovalidate: true,
                          validator: (val) {
                            return (val == null ? "Please select date" : null);
                          },
                          onSaved: (val) {
                            setState(() {
                              paymentHdr.insDate = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        color: themedata.primaryColor,
                        child: BaseDialogField<BCCModel>(
                          isChangeHeight: false,
                          vector: AppVectors.advance,
                          hint: "Tap select data",
                          validator: (val) {
                            return val == null
                                ? "Please select settlement type"
                                : null;
                          },

                          displayTitle: "Settlement Types" + " * ",
                          // icon: icon ?? Icons.dashboard,
                          list: widget.viewModel.settlementTypes,
                          initialValue: _selectSettlementypes,
                          isEnabled: true,
                          listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            subTitle: val.code,
                            icon: Icons.list,
                            title: val?.description ?? "Tap to select",
                            vector: AppVectors.transaction,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                          fieldBuilder: (selected) => Text(
                            selected?.description ?? "Tap to select",
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                          onChanged: (val) {
                            setState(() {
                              paymentHdr.settlementTypes = val;
                              print("types---- ${paymentHdr.settlementTypes}");

                              _selectSettlementypes = val;
                              print("types---- ${_selectSettlementypes}");
                              widget.viewModel.setField(
                                  paymentHdr.copyWith(settlementTypes: val));
                              paymentHdr.settlementTypes = val;
                              if (val.description == "Normal") {
                                settlewithin = 7;
                                widget.viewModel.setField(paymentHdr.copyWith(
                                    settleWithinDays: settlewithin));

                                tillDate = DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day + settlewithin);
                                widget.viewModel.setField(
                                    paymentHdr.copyWith(tillDate: tillDate));
                                print(BaseDates(tillDate,
                                        month: "MMM", year: "yyyy", day: "dd")
                                    .format);
                                // DateTime k = DateTime.parse((BaseDates(
                                //         tillDate,
                                //         month: "MMM",
                                //         year: "yyyy",
                                //         day: "dd")
                                //     .format));

                                // print(k);
                                print("settlewithin $settlewithin" +
                                    "tilldate $tillDate" +
                                    "currentDate $currentDate");
                              }
                            });
                          },

                          onSaved: (val) {
                            setState(() {
                              paymentHdr.settlementTypes = val;
                              paymentHdr.tillDate = tillDate;
                              paymentHdr.settleWithinDays = settlewithin;
                              _selectSettlementypes = val;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            paymentHdr?.settlementTypes?.description == "Normal"
                                ? true
                                : false,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          color: themedata.primaryColor,
                          child: BaseTextField(
                            vector: AppVectors.transaction,
                            initialValue: settlewithin.toString(),
                            displayTitle: "Settle Within",
                            // onChanged: (val) {
                            //   paymentHdr?.remarks = val;
                            //   widget.viewModel.setField(
                            //       paymentHdr.copyWith(remarks: val));
                            //   remarks = val;
                            // }
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            paymentHdr?.settlementTypes?.description == "Normal"
                                ? false
                                : true,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          color: themedata.primaryColor,
                          child: BaseTextField(
                              vector: AppVectors.transaction,
                              initialValue: "",
                              displayTitle: "Settle Within",
                              onSaved: (val) {
                                int settle = int.parse(val);
                                settlewithin = settle;
                                tillDate = DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day + settlewithin);
                                widget.viewModel.setField(paymentHdr.copyWith(
                                    settleWithinDays: settlewithin));
                                widget.viewModel.setField(
                                    paymentHdr.copyWith(tillDate: tillDate));
                              },
                              onChanged: (val) {
                                int settle = int.parse(val);
                                setState(() {
                                  settlewithin = settle;
                                  tillDate = DateTime(
                                      currentDate.year,
                                      currentDate.month,
                                      currentDate.day + settlewithin);
                                  widget.viewModel.setField(paymentHdr.copyWith(
                                      settleWithinDays: settlewithin));
                                  widget.viewModel.setField(
                                      paymentHdr.copyWith(tillDate: tillDate));
                                });
                              }),
                        ),
                      ),
                      Container(
                        color: themedata.primaryColor,
                        child: BaseDatePicker(
                          vector: AppVectors.calenderSettlement,
                          hint: "",
                          displayTitle: "Till Date" + " * ",
                          icon: Icons.date_range,
                          initialValue:
                              tillDate != null ? tillDate : currentDate,
                          isEnabled: true,
                          autovalidate: true,
                          validator: (val) {
                            return (val == null ? "Please select date" : null);
                          },
                          onSaved: (val) {
                            setState(() {
                              paymentHdr.tillDate = tillDate;
                              widget.viewModel.setField(
                                  paymentHdr.copyWith(tillDate: tillDate));
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 10),
                        color: themedata.primaryColor,
                        child: BaseTextField(
                            vector: AppVectors.remarks,
                            onSaved: (val) {
                              paymentHdr.remarks = val;
                              remarks = val;
                            },
                            initialValue: paymentHdr?.remarks,
                            hint: "Type to enter reason",
                            displayTitle: "Reason" + " * ",
                            validator: (val) {
                              return val.isEmpty ? "Please enter reason" : null;
                            },
                            onChanged: (val) {
                              paymentHdr?.remarks = val;
                              widget.viewModel
                                  .setField(paymentHdr.copyWith(remarks: val));
                              remarks = val;
                            }),

                        // TextFormField(
                        //     initialValue: paymentHdr?.remarks,
                        //     maxLines: 25,
                        //     minLines: 15,
                        //     enabled: true,
                        //     scrollPadding: EdgeInsets.all(4),
                        //     textInputAction: TextInputAction.done,
                        //     onSaved: (val) => paymentHdr?.remarks = val,
                        //     decoration: InputDecoration(
                        //       errorBorder: InputBorder.none,
                        //       errorStyle:
                        //           TextStyle(color: colors.accentColor),
                        //       errorText: "Please enter reason",
                        //       enabledBorder: InputBorder.none,
                        //       focusedBorder: InputBorder.none,
                        //       border: InputBorder.none,
                        //       hintText: 'Type to enter reason....',
                        //     ))
                      ),
                    ]))),
                _buildButtons(context, paymentHdr),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                )
              ]))),
    );
  }

  void onValueChange(PaymentVoucherHdrModel model) {
    formKey?.currentState?.save();
    widget?.viewModel?.setField(model);
  }

  void onValueSave(PaymentVoucherHdrModel model) {
    widget?.viewModel?.setField(model);
  }

  Widget _buildTextField(
    String initialVal,
    bool isMandatory,
    String title,
    String vector,
    IconData icon, {
    bool isEnabled = true,
    ValueSetter<String> onChanged,
    ValueSetter<String> onSaved,
  }) {
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
      color: themedata.primaryColor,
      padding: EdgeInsets.only(top: 10),
      child: BaseTextField(
        isEnabled: isEnabled,
        onEditingCompleted: onChanged,
        hint: "Type to enter data",
        validator: (String val) =>
            (isMandatory && val.isEmpty) ? "Please enter $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),
        initialValue: initialVal,
        onSaved: onSaved,
        vector: vector,
//        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDialogField(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        height: height * .26,
        isChangeHeight: true,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: vector,
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildRequestFromDialogField(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        isChangeHeight: false,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: vector,
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildDialogFieldWithVectorList(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    List<String> listVectors = [
      AppVectors.localPurchaseOrder,
      AppVectors.importPurchaseOrder,
      AppVectors.direct,
      AppVectors.advance,
      AppVectors.transactionType,
      AppVectors.paymentType,
      AppVectors.transaction
    ];
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        height: height * .53,
        isChangeHeight: true,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: listVectors[pos],
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildDateField({
    DateTime initialVal,
    bool isMandatory,
    bool isEnabled,
    String title,
    IconData icon,
    ValueSetter<DateTime> onChanged,
    ValueSetter<DateTime> onSaved,
  }) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: BaseDatePicker(
            vector: AppVectors.calenderSettlement,
            isEnabled: isEnabled,
            hint: "Tap to select date",
            initialValue: initialVal ?? DateTime.now(),
            displayTitle: title + (isMandatory ? " * " : ""),
            validator: (val) =>
                (isMandatory && val == null) ? "Please select $title" : null,
            onSaved: (val) => {}));
  }

  Widget _buildButtons(
    BuildContext context,
    PaymentVoucherHdrModel paymentHdr,

    // bool hasDtlRights,
    // bool hasTaxRights
  ) {
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
        height: MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width,
        child: BaseRaisedButton(
          backgroundColor: themedata.primaryColorDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            final FormState form = formKey.currentState;
            if (form.validate()) {
              form.save();
              widget.viewModel.onEntrySave(paymentHdr);
              print("==========details===========================");
              print("data==>${paymentHdr?.requestFromName?.name}");
              print("data==>${paymentHdr?.voucherBankTypes?.description}");
              print("data==>${paymentHdr?.instrumentBankTypes?.name}");
              print("data==>${paymentHdr?.paymentMode = selectedPaymentMode}");
              print("data==>${paymentHdr?.voucherTypes?.description}");
              print("data==>${paymentHdr?.instrumentTypes?.name}");
              print("data==>${paymentHdr?.insDate}");
              print("data==>${paymentHdr?.instNo}");
              print("data==>${paymentHdr?.remarks}");
              print("data==>${selectedPaymentMode}");

              BaseNavigate(
                  context,
                  PaymentVoucherView(
                    viewModel: widget.viewModel,
                  ));
            }
          },
          child: Text('PROCEED'),
        ));
  }
}

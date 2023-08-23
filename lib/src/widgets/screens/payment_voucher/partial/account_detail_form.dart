import 'package:base/constants.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/payment_voucher/payment_voucher_viewmodel.dart';
import 'package:redstars/src/services/repository/payment_voucher/payment_voucher_repository.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/approval_button.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '../../../../../utility.dart';
import 'new_account_sheet.dart';

final keyForm = GlobalKey<ApprovalButtonsState>();

class PaymentVoucherView extends StatefulWidget {
  final PaymentVoucherViewModel viewModel;

  const PaymentVoucherView({Key key, this.viewModel}) : super(key: key);
  @override
  _PaymentVoucherViewState createState() => _PaymentVoucherViewState();
}

class _PaymentVoucherViewState extends State<PaymentVoucherView> {
  String amount;
  @override
  void initState() {
    amount = widget?.viewModel?.poProcessList?.first?.dtljson?.amount;
    super.initState();
  }

  int companyCurrencyId;
  int branchCurrencyId;
  double exrate;
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

  String currencyName;
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

  @override
  Widget build(BuildContext context) {

    ThemeData themedata =ThemeProvider.of(context);
    ServiceList serviceList;
    findExchangeRate();
    findCurrency();

    widget.viewModel.serviceList.forEach((element) {
      if (element.accountid ==
          widget.viewModel.poProcessList.first.dtljson.accountid) {
        return serviceList = element;
      }
      print(serviceList);
      return serviceList;
    });
    widget.viewModel.acctDetails.clear();

    PaymentVoucherDtlModel data = PaymentVoucherDtlModel(
        serviceList: serviceList,
        amount: 0,
        currencyName: currencyName ?? "Birr",
        exchangeRate: exrate ?? 1.0,
        budgetList: widget.viewModel.poProcessList.first.dtljson.budgetdtljson,
        service: widget.viewModel?.poProcessList?.first?.dtljson?.servicename);

    widget.viewModel.acctDetails.add(data);
    print(
        "fstAcct${widget.viewModel.poProcessList.first.dtljson.budgetdtljson.accountid}");

    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return BaseView<AppState, PaymentVoucherViewModel>(
      init: (store, con) {
        store.dispatch(fetchVoucherInitialData());
        store.dispatch(fetchServiceList());
        store.dispatch(fetchCurrencyExchangeList());
      },
      onDidChange: (viewModel, context) {
        if (viewModel.isSaved)
          showSuccessDialog(context, r + "Saved Successfully", "Success", () {
            viewModel.onClear();
            // Navigator.popUntil(
            //  context, ModalRoute.withName(AppRoutes.paymentvoucher));
            Navigator.pop(context);
            Navigator.pop(context);

            viewModel.onRefresh();
          });
      },
      builder: (context, viewModel) {
        return Scaffold(
          appBar: BaseAppBar(
            title: Text("Payment Voucher"),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    String message = viewModel.validateItems();
                    if (message != null && message.isEmpty) {
                      viewModel.onSave();
                    } else {
                      BaseSnackBar.of(context).show(message);
                    }

                    //  keyForm.currentState.onSubmit(context);
                  })
            ],
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                FloatingActionButton(
                    onPressed: () {
                      showItemAddSheet(context, viewModel: viewModel);
                    },
                    heroTag: "items",
                    autofocus: true,
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: themedata.primaryColorDark,
                    ))
              ]),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Stack(children: <Widget>[
                  if (viewModel.acctDetails?.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (con, position) {
                        PaymentVoucherDtlModel object =
                            viewModel.acctDetails[position];
                        return Dismissible(
                            onDismissed: (direction) {
                              viewModel.onRemoveItem(object);
                            },
                            key: Key(object.service),
                            background: Container(
                                decoration: BoxDecoration(color: Colors.red)),
                            confirmDismiss: (direction) => appChoiceDialog(
                                message: "Do you want to delete this record",
                                context: context),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              child: ListItemAccount(
                                voucherModel: object,
                                onClick: (selected) => showItemAddSheet(
                                  context,
                                  selected: selected,
                                  viewModel: viewModel,
                                ),
                              ),
                            ));
                      },
                      itemCount: viewModel.acctDetails?.length ?? 0,
                    )
                  else
                    Container(
                      color: colors.primaryColor,
                    )
                  // emptyView(theme, colors, context),
                ])),
                SizedBox(
                  height: 10,
                ),
                //  if (viewModel.requisitionItems.isNotEmpty)
                // ApprovalButtons(
                //     key: keyForm,
                //     onSubmit: ({String remarks}) {
                //       String validation = viewModel.validateSave();
                //       if (validation != null)
                //         BaseSnackBar.of(con).show(validation);
                //       else
                //         viewModel.saveRequisition(remarks: remarks);
                //     }),
              ]),
        );
      },
      converter: (store) => PaymentVoucherViewModel.fromStore(store),
      // onDispose: (store) => store.dispatch(OnClearAction())
    );
  }

  void showItemAddSheet(BuildContext context,
      {PaymentVoucherViewModel viewModel, PaymentVoucherDtlModel selected}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => ItemAccountView<PaymentVoucherDtlModel>(
          viewModel: viewModel,
          onNewItem: (reqItem) => viewModel.onAdd(reqItem),
          selected: selected),
    );
  }

  Widget _buildButton(BaseTheme theme,
      {bool reverse = false, IconData icon, String title}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(icon ?? Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          title ?? "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget emptyView(BaseTheme theme, BaseColors colors, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Container(
          height: height / 4.5,
          width: width / 2,
          child: Stack(children: [
            Positioned.fill(
              // top: MediaQuery.of(context).size.height * .14,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AppVectors.emptyBox
                    // color: Colors.black,
                    ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ServiceList serviceList;
// String refNo;
// DateTime refDate;
// double amount;
// String currencyName;
// double exchangeRate;
// String service;

class ListItemAccount<T extends PaymentVoucherDtlModel>
    extends StatelessWidget {
  final T voucherModel;
  final ValueSetter<T> onClick;
  final PaymentVoucherViewModel viewModel;

  ListItemAccount({Key key, this.voucherModel, this.onClick, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themedata =ThemeProvider.of(context);
    return Column(
      children: [
        Container(
          color:themedata.primaryColor,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: themedata.primaryColor,
                border: Border(
                    bottom: BaseBorderSide(color:themedata.primaryColor))),
            child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
                onPressed: () => onClick(voucherModel),
                child: IntrinsicHeight(
                    child: Row(children: [
                  Expanded(
                      child: FlatButton(
                          padding:
                              EdgeInsets.only(left: 12, top: 12, bottom: 12),
                          onPressed: () => onClick(voucherModel),
                          child: IntrinsicHeight(
                              child: Row(children: <Widget>[
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                  Text(
                                      voucherModel.serviceList?.accountname ??
                                          "",
                                      style: theme.subhead1Bold),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0),
                                      child: Text(voucherModel?.service ?? "",
                                          style: theme.body))
                                ])),
                            SizedBox(width: 22),
                            Column(children: <Widget>[
                              Text(
                                voucherModel?.currencyName ?? "",
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6.0, left: 8.0),
                                child: Text(
                                    voucherModel?.exchangeRate.toString() ?? "",
                                    style: theme.body),
                              ),
                            ]),
                            SizedBox(width: 22),
                            Column(children: <Widget>[
                              Text("Amount", style: theme.body),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0),
                                  child: Text(
                                    BaseNumberFormat(
                                            number: voucherModel.amount)
                                        .formatCurrency(),
                                    // "${voucherModel.amount}",
                                    style: theme.subhead1Bold.copyWith(
                                        color: themedata.accentColor),
                                  ))
                            ]),
                            SizedBox(width: 4)
                          ])))),
                ]))),
          ),
        ),
        //  SizedBox(height: 10),
      ],
    );
  }
}

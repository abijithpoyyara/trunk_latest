import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/account_balance_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';

class LoginModel {
  String userName;
  String password;
  String clientId;
  LiveClientDetails liveClientDetails;
  ClientLevelDetails company;
  ClientLevelDetails branch;
  ClientLevelDetails location;

  LoginModel(
      {this.userName = "",
      this.password = "",
      this.clientId = "",
      this.liveClientDetails,
      this.company,
      this.branch,
      this.location});

  LoginModel merge(LoginModel copy) {
    return LoginModel(
      userName: this.userName ?? copy.userName,
      password: this.password ?? copy.password,
      clientId: this.clientId ?? copy.clientId,
      company: this.company ?? copy?.company,
      branch: this.branch ?? copy?.branch,
      location: this.location ?? copy?.location,
      liveClientDetails: this.liveClientDetails ?? copy.liveClientDetails,
    );
  }
}

class PaymentVoucherHdrModel {
  BCCModel voucherTypes;
  BCCModel instrumentTypes;
  BCCModel voucherBankTypes;
  BCCModel instrumentBankTypes;
  BCCModel paymentTypes;
  BCCModel name;
  BCCModel paidTo;
  DateTime insDate;
  TransTypeLookupItem transNo;
  BCCModel cashier;
  BCCModel paidToType;
  ServiceLookupItem requestFromName;
  BCCModel settlementTypes;
  List<ServiceLookupItem> names;
  double requestAmount;
  DateTime date;
  String remarks;
  String referenceNo;
  String total;
  String balance;
  String instNo;
  String paymentMode;
  CashierBalance cashierBalance;
  AccountBalance accountBalance;
  int settleWithinDays;
  DateTime tillDate;

  PaymentVoucherHdrModel(
      {this.voucherTypes,
      this.instrumentTypes,
      this.date,
      this.transNo,
      this.names,
      this.paidTo,
      this.paymentTypes,
      this.voucherBankTypes,
      this.cashierBalance,
      this.instrumentBankTypes,
      this.requestFromName,
      this.requestAmount,
      this.settlementTypes,
      this.paidToType,
      this.insDate,
      this.remarks,
      this.name,
      this.cashier,
      this.referenceNo,
      this.total,
      this.balance,
      this.instNo,
      this.accountBalance,
      this.paymentMode,
      this.settleWithinDays,
      this.tillDate});

  PaymentVoucherHdrModel merge(PaymentVoucherHdrModel copy) {
    return PaymentVoucherHdrModel(
        voucherTypes: voucherTypes ?? copy.voucherTypes,
        instrumentTypes: instrumentTypes ?? copy.instrumentTypes,
        paymentMode: paymentMode ?? copy.paymentMode);
  }

  PaymentVoucherHdrModel copyWith({
    BCCModel voucherTypes,
    BCCModel instrumentTypes,
    BCCModel paymentTypes,
    BCCModel name,
    BCCModel paidTo,
    DateTime insDate,
    TransTypeLookupItem transNo,
    BCCModel voucherBankTypes,
    BCCModel instrumentBankTypes,
    BCCModel cashier,
    BCCModel paidToType,
    ServiceLookupItem requestFromName,
    double requestAmount,
    List<ServiceLookupItem> names,
    DateTime date,
    String remarks,
    String referenceNo,
    String total,
    String balance,
    String instNo,
    String paymentMode,
    AccountBalance accountBalance,
    CashierBalance cashierBalance,
    BCCModel settlementTypes,
    int settleWithinDays,
    DateTime tillDate,
  }) {
    return PaymentVoucherHdrModel(
        voucherTypes: voucherTypes ?? this.voucherTypes,
        insDate: insDate ?? this.insDate,
        transNo: transNo ?? this.transNo,
        paidTo: paidTo ?? this.paidTo,
        instrumentTypes: instrumentTypes ?? this.instrumentTypes,
        requestFromName: requestFromName ?? this.requestFromName,
        requestAmount: requestAmount ?? this.requestAmount,
        instrumentBankTypes: instrumentBankTypes ?? this.instrumentBankTypes,
        voucherBankTypes: voucherBankTypes ?? this.voucherBankTypes,
        paidToType: paidToType ?? this.paidToType,
        paymentTypes: paymentTypes ?? this.paymentTypes,
        settlementTypes: settlementTypes ?? this.settlementTypes,
        date: date ?? this.date,
        cashierBalance: cashierBalance ?? this.cashierBalance,
        names: names ?? this.names,
        name: name ?? this.name,
        cashier: cashier ?? this.cashier,
        remarks: remarks ?? this.remarks,
        referenceNo: referenceNo ?? this.referenceNo,
        balance: balance ?? this.balance,
        instNo: instNo ?? this.instNo,
        paymentMode: paymentMode ?? this.paymentMode,
        accountBalance: accountBalance ?? this.accountBalance,
        settleWithinDays: settleWithinDays ?? this.settleWithinDays,
        tillDate: tillDate ?? this.tillDate);
  }
}

class PaymentVoucherDtlModel {
  ServiceList serviceList;
  BudgetDtlModel budgetList;
  String refNo;
  DateTime refDate;
  double amount;
  String currencyName;
  double exchangeRate;
  String service;

  PaymentVoucherDtlModel(
      {this.serviceList,
      this.budgetList,
      this.amount,
      this.refDate,
      this.refNo,
      this.currencyName,
      this.exchangeRate,
      this.service});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentVoucherDtlModel &&
          runtimeType == other.runtimeType &&
          serviceList == other.serviceList;
  // budgetList == other.budgetList;

  @override
  int get hashCode => serviceList.hashCode;

  PaymentVoucherDtlModel copyWith({
    double amount,
  }) {
    return PaymentVoucherDtlModel(
      serviceList: serviceList ?? this.serviceList,
      refDate: refDate ?? this.refDate,
      budgetList: budgetList ?? this.budgetList,
      refNo: refNo ?? this.refNo,
      amount: amount ?? this.amount,
      currencyName: currencyName ?? this.currencyName,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      service: service ?? this.service,
    );
  }
}

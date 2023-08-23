import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/tax_dtl_model.dart';

class PaymentRequisitionHdrModel {
  List<FileDetails> fileDetails;
  BCCModel transactionType;
  BCCModel processType;
  DateTime transDate;
  TransTypeLookupItem transNo;
  String paidTo;
  BCCModel requestFrom;
  ServiceLookupItem requestFromName;
  double requestAmount;
  BCCModel paymentType;
  DateTime settleWithin;
  String remarks;

  PaymentRequisitionHdrModel({
    this.fileDetails,
    this.transactionType,
    this.processType,
    this.transDate,
    this.transNo,
    this.paidTo,
    this.requestFrom,
    this.requestFromName,
    this.requestAmount,
    this.paymentType,
    this.settleWithin,
    this.remarks,
  });

  PaymentRequisitionHdrModel copyWith({
    List<FileDetails> fileDetails,
    BCCModel transactionType,
    BCCModel processType,
    DateTime transDate,
    TransTypeLookupItem transNo,
    String paidTo,
    BCCModel requestFrom,
    ServiceLookupItem requestFromName,
    double requestAmount,
    BCCModel paymentType,
    DateTime settleWithin,
    String remarks,
  }) {
    return PaymentRequisitionHdrModel(
      fileDetails: fileDetails ?? this.fileDetails,
      transactionType: transactionType ?? this.transactionType,
      processType: processType ?? this.processType,
      transDate: transDate ?? this.transDate,
      transNo: transNo ?? this.transNo,
      paidTo: paidTo ?? this.paidTo,
      requestFrom: requestFrom ?? this.requestFrom,
      requestFromName: requestFromName ?? this.requestFromName,
      requestAmount: requestAmount ?? this.requestAmount,
      paymentType: paymentType ?? this.paymentType,
      settleWithin: settleWithin ?? this.settleWithin,
      remarks: remarks ?? this.remarks,
    );
  }
}

class PaymentRequisitionDtlModel {
  ServiceModel serviceType;
  AccountLookupItem ledger;
  List<AccountLookupItem> ledgerList;
  double amount;
  bool taxApplicable;
  String itemGroup;
  double budgeted;
  double actual;
  double remaining;

  List<TaxDetailModel> taxes;
  BudgetDtlModel budget;

  PaymentRequisitionDtlModel(
      {this.ledger,
      this.amount,
      this.taxApplicable,
      this.itemGroup,
      this.budgeted,
      this.actual,
      this.remaining,
      this.taxes,
        this.budget,
        this.serviceType,
        this.ledgerList
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentRequisitionDtlModel &&
          runtimeType == other.runtimeType &&
          ledger == other.ledger;

  @override
  int get hashCode => ledger.hashCode;

  PaymentRequisitionDtlModel copyWith({
    double amount,
    List<TaxDetailModel> taxes,
  }) {
    return PaymentRequisitionDtlModel(
      ledger: ledger ?? this.ledger,
      amount: amount ?? this.amount,
      taxApplicable: taxApplicable ?? this.taxApplicable,
      itemGroup: itemGroup ?? this.itemGroup,
      budgeted: budgeted ?? this.budgeted,
      actual: actual ?? this.actual,
      remaining: remaining ?? this.remaining,
      taxes: taxes ?? this.taxes,
      budget: budget ?? this.budget,
      serviceType: serviceType ?? this.serviceType,
      ledgerList: ledgerList ?? this.ledgerList
    );
  }
}

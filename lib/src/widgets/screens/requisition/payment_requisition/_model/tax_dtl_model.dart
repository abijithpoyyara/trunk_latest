import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';

class TaxDetailModel {
  TaxConfigModel tax;
  TaxDtlModel taxDtl;
  double totalAmount;
  double taxedAmount;

  TaxDetailModel({this.tax, this.taxDtl, this.totalAmount, this.taxedAmount});


}

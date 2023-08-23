class PoKhatModel {
  String remarks;
  POKhatPaymentTypesModel selectedPaymentMode;
  PoKhatModel({this.remarks,this.selectedPaymentMode});
}

class POKhatPaymentTypesModel {
  String code;
  String name;

  POKhatPaymentTypesModel({this.name, this.code});
}

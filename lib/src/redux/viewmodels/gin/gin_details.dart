import 'package:redstars/src/services/model/response/gin/gin_model.dart';

class SupplierModel {
  int supplierId;
  String supplierName;
  int companyId;
  int branchId;
  String address1;
  String address2;
  String address3;

  SupplierModel.fromGIN(GINModel ginDetails) {
    supplierId = ginDetails?.supplierid;
    supplierName = ginDetails?.suppliername;
    companyId = ginDetails?.companyid;
    branchId = ginDetails?.branchid;
    address1 = ginDetails?.address1;
    address2 = ginDetails?.address2;
    address3 = ginDetails?.address3;
  }
}

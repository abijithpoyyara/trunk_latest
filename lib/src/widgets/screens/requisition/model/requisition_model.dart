import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';

class RequisitionModel {
  ItemLookupItem item;
  UomTypes uom;
  double qty;
  BudgetDtlModel budgetDtl;
  DepartmentItem department;
  BranchStore branch;
  String remark;
  int id;
  int detailListId;
  int rate;
  int detailId;
  SelectedStockViewModel objId;
  String remarks;

  RequisitionModel(
      {this.item,
      this.uom,
      this.qty,
      this.budgetDtl,
      this.branch,
      this.department,
      this.remark,
      this.id,
      this.detailListId,
      this.rate,
      this.detailId,
      this.objId,
      this.remarks});
}

import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/widgets/screens/requisition/model/requisition_model.dart';

class PurchaseRequisitionModel extends RequisitionModel {
  PurchaseRequisitionModel(
      {ItemLookupItem item,
      UomTypes uom,
      double qty,
      BudgetDtlModel itemBudget,
      DepartmentItem department,
      BranchStore branch,
      String remark,
      int id,
      int detailListId})
      : super(
            item: item,
            uom: uom,
            qty: qty,
            budgetDtl: itemBudget,
            department: department,
            branch: branch,
            remark: remark,
            id: id,
            detailListId: detailListId);

  PurchaseRequisitionModel merge(PurchaseRequisitionModel model) {
    return PurchaseRequisitionModel(
        uom: model.uom ?? uom,
        item: model.item ?? item,
        qty: model.qty,
        itemBudget: model.budgetDtl ?? budgetDtl,
        department: model.department ?? department,
        branch: model.branch ?? branch,
        remark: model.remark ?? remark,
        id: model.id ?? id,
        detailListId: model.detailListId ?? detailListId);
  }

  factory PurchaseRequisitionModel.fromRequisitionModel(
      RequisitionModel model) {
    return PurchaseRequisitionModel(
        item: model.item,
        uom: model.uom,
        qty: model.qty,
        itemBudget: model.budgetDtl,
        department: model.department,
        branch: model.branch,
        remark: model.remark,
        id: model.id,
        detailListId: model.detailListId);
  }

  void addQty(int val) {
    qty += val;
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is PurchaseRequisitionModel &&
            runtimeType == other.runtimeType &&
            item == other.item &&
            remark == other.remark &&
            uom == other.uom &&
            id == other.id;
  }

  @override
  int get hashCode => item.hashCode ^ uom.hashCode;
}

import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/widgets/screens/requisition/model/requisition_model.dart';

class StockRequisitionModel extends RequisitionModel {
  StockRequisitionModel({
    ItemLookupItem item,
    UomTypes uom,
    double qty,
    BudgetDtlModel itemBudget,
    int rate,
    int detailId,
    SelectedStockViewModel objId,
    String remark,
  }) : super(
            item: item,
            uom: uom,
            qty: qty,
            budgetDtl: itemBudget,
            rate: rate,
            detailId: detailId,
            objId: objId,
            remarks: remark);

  factory StockRequisitionModel.fromRequisitionModel(RequisitionModel model) {
    return StockRequisitionModel(
        item: model.item,
        uom: model.uom,
        qty: model.qty,
        itemBudget: model.budgetDtl,
        rate: model.rate,
        detailId: model.detailId,
        objId: model.objId,
        remark: model.remarks);
  }

  StockRequisitionModel merge(StockRequisitionModel model) {
    return StockRequisitionModel(
      uom: model.uom ?? uom,
      item: model.item ?? item,
      qty: model.qty,
      itemBudget: model.budgetDtl ?? budgetDtl,
      rate: model.rate ?? rate,
      detailId: model.detailId ?? detailId,
      objId: model.objId ?? objId,
      remark: model.remarks ?? remarks,
    );
  }

  void addQty(int val) {
    qty += val;
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is StockRequisitionModel &&
            runtimeType == other.runtimeType &&
            item == other.item &&
            uom == other.uom;
  }

  @override
  int get hashCode => item.hashCode ^ uom.hashCode;
}

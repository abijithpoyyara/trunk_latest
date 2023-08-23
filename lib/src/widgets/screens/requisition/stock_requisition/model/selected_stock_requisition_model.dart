import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

class SelectedStockRequisitionModel{
  SelectedStockViewList itemCode;
  SelectedStockViewList itemName;
  SelectedStockViewList uomName;
  SelectedStockViewList qty;
  SelectedStockViewList balanceQty;
  SelectedStockViewList status;
  SelectedStockViewList usedQty;

  SelectedStockRequisitionModel({
    this.itemCode, this.itemName, this.uomName,this.qty,this.balanceQty,this.status, this.usedQty});
}
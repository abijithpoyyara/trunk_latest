import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_payment_types_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

class POKhatSaveModel extends POkhatModel {
  POKhatSaveModel({
    ItemLookupItem item,
    UomTypes uom,
    double qty,
    BranchStockLocation selectedLocation,
    KhatPurchasers selectedPurchaser,
    SupplierQuotaItem selectedSupplier,
    POKhatPaymentTypesModel selectedPaymentType,
    BCCModel selectedTransactionType,
    DateTime selectedDate,
    String remarks,
    int pokhatId,
    int statusBccId,
    String statusDate,
    String deliveryDueDate,
    double exchangeRate,
    List<LocationDtl> location,
  }) : super(
            item: item,
            qty: qty,
            uom: uom,
            selectedDate: selectedDate,
            pokhatId: pokhatId,
            remarks: remarks,
            statusDate: statusDate,
            deliveryDueDate: deliveryDueDate,
            statusBccId: statusBccId,
            exchangeRate: exchangeRate,
            location: location,
            selectedPaymentType: selectedPaymentType,
            selectedPurchaser: selectedPurchaser,
            selectedTransactionType: selectedTransactionType,
            selectedSupplier: selectedSupplier);

  factory POKhatSaveModel.fromRequisitionModel(POkhatModel model) {
    return POKhatSaveModel(
        item: model.item,
        qty: model.qty,
        uom: model.uom,
        statusBccId: model.statusBccId,
        statusDate: model.statusDate,
        exchangeRate: model.exchangeRate,
        deliveryDueDate: model.deliveryDueDate,
        selectedSupplier: model.selectedSupplier,
        selectedTransactionType: model.selectedTransactionType,
        selectedPurchaser: model.selectedPurchaser,
        selectedDate: model.selectedDate,
        selectedLocation: model.selectedLocation,
        selectedPaymentType: model.selectedPaymentType,
        location: model.location,
        remarks: model.remarks,
        pokhatId: model.pokhatId);
  }

  POKhatSaveModel merge(POKhatSaveModel model) {
    return POKhatSaveModel(
        item: model.item ?? item,
        qty: model.qty ?? qty,
        uom: model.uom ?? uom,
        location: model.location ?? location,
        exchangeRate: model.exchangeRate ?? exchangeRate,
        statusDate: model.statusDate ?? statusDate,
        deliveryDueDate: model.deliveryDueDate ?? this.deliveryDueDate,
        statusBccId: model.statusBccId ?? statusBccId,
        selectedSupplier: model.selectedSupplier ?? selectedSupplier,
        selectedTransactionType:
            model.selectedTransactionType ?? selectedTransactionType,
        selectedPurchaser: model.selectedPurchaser ?? selectedPurchaser,
        selectedDate: model.selectedDate ?? selectedDate,
        selectedLocation: model.selectedLocation ?? selectedLocation,
        remarks: model.remarks ?? remarks,
        selectedPaymentType: model.selectedPaymentType ?? selectedPaymentType,
        pokhatId: model.pokhatId ?? pokhatId);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is POKhatSaveModel &&
            runtimeType == other.runtimeType &&
            item == other.item &&
            uom == other.uom;
  }

  @override
  int get hashCode => item.hashCode;
}

import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_payment_types_model.dart';

class PoKhatHdrModel {
  BranchStockLocation selectedLocation;
  KhatPurchasers selectedPurchaser;
  SupplierQuotaItem selectedSupplier;
  BCCModel selectedTransactionType;
  DateTime selectedDate;
  POKhatPaymentTypesModel selectedPaymentType;
  String remarks;

  PoKhatHdrModel(
      {this.selectedLocation,
      this.selectedPurchaser,
      this.selectedSupplier,
      this.selectedPaymentType,
      this.remarks,
      this.selectedDate,
      this.selectedTransactionType});

  PoKhatHdrModel copyWith({
    BranchStockLocation selectedLocation,
    KhatPurchasers selectedPurchaser,
    SupplierQuotaItem selectedSupplier,
    BCCModel selectedTransactionType,
    DateTime selectedDate,
    POKhatPaymentTypesModel selectedPaymentType,
    String remarks,
  }) {
    return PoKhatHdrModel(
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedPurchaser: selectedPurchaser ?? this.selectedPurchaser,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedTransactionType:
          selectedTransactionType ?? this.selectedTransactionType,
      remarks: remarks ?? this.remarks,
    );
  }
}

class POkhatModel {
  ItemLookupItem item;
  double qty;
  BranchStockLocation selectedLocation;
  KhatPurchasers selectedPurchaser;
  SupplierQuotaItem selectedSupplier;
  BCCModel selectedTransactionType;
  DateTime selectedDate;
  POKhatPaymentTypesModel selectedPaymentType;
  String remarks;
  int pokhatId;
  UomTypes uom;
  int statusBccId;
  String statusDate;
  String deliveryDueDate;
  double exchangeRate;
  List<LocationDtl> location;

  POkhatModel(
      {this.item,
      this.qty,
      this.selectedLocation,
      this.selectedPurchaser,
      this.selectedSupplier,
      this.selectedPaymentType,
      this.selectedTransactionType,
      this.selectedDate,
      this.remarks,
      this.uom,
      this.pokhatId,
      this.statusBccId,
      this.deliveryDueDate,
      this.statusDate,
      this.exchangeRate,
      this.location});
}

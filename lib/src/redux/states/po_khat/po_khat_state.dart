import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_payment_types_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

@immutable
class POkhatState extends BaseState {
  final List<KhatPurchasers> purchasers;
  final List<BranchStockLocation> locations;
  final List<BCCModel> transportModeTypes;
  final BranchStockLocation selectedLocation;
  final bool isPoKhatsaved;
  final DateTime selectedDate;
  final FilterModel filterModel;
  final POKhatDetailListModel poKhatDetailListModel;
  final POKhatPendingListModel poKhatPendingListModel;
  final double scrollPosition;
  final DateTime frmDate;
  final DateTime toDate;
  final int pokhatDetailId;
  final List<POKhatSaveModel> pokhatItems;
  final KhatPurchasers selectedPurchaser;
  final BCCModel selectedTransportTypes;
  final SupplierQuotaItem selectedSupplier;
  final POKhatPaymentTypesModel selectedPaymentMode;
  final List<dynamic> suppliers;
  final List<BranchStockLocation> khatLocations;
  final PoKhatHdrModel khatHdrModel;
  final String purchaserName;
  final List<POKhatDetailList> pokhatPendingDetailList;
  final KhatPurchasers p;

  POkhatState({
    this.filterModel,
    this.transportModeTypes,
    this.poKhatDetailListModel,
    this.poKhatPendingListModel,
    this.purchasers,
    this.locations,
    this.pokhatDetailId,
    this.isPoKhatsaved,
    this.selectedLocation,
    this.selectedDate,
    this.scrollPosition,
    this.frmDate,
    this.toDate,
    this.pokhatItems,
    this.selectedPurchaser,
    this.selectedSupplier,
    this.selectedPaymentMode,
    this.selectedTransportTypes,
    this.suppliers,
    this.khatLocations,
    this.khatHdrModel,
    this.purchaserName,
    this.pokhatPendingDetailList,
    this.p,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  POkhatState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<KhatPurchasers> purchasers,
    List<StockLocation> locations,
    List<BCCModel> transportModeTypes,
    BranchStockLocation selectedLocation,
    bool isPoKhatsaved,
    DateTime selectedDate,
    FilterModel filterModel,
    POKhatDetailListModel poKhatDetailListModel,
    POKhatPendingListModel poKhatPendingListModel,
    double scrollPosition,
    DateTime frmDate,
    DateTime toDate,
    int pokhatDetailId,
    List<POKhatSaveModel> pokhatItems,
    KhatPurchasers selectedPurchaser,
    BCCModel selectedTransportTypes,
    SupplierQuotaItem selectedSupplier,
    POKhatPaymentTypesModel selectedPaymentMode,
    List<dynamic> suppliers,
    PoKhatHdrModel khatHdrModel,
    List<BranchStockLocation> khatLocations,
    String purchaserName,
    List<POKhatDetailList> pokhatPendingDetailList,
    KhatPurchasers p,
  }) {
    // fb()async{
    //   int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    //   itemGradeRateLocationObj.forEach((element) {
    //     if(element.id==branchId) {
    //      locationObj=element;
    //     }
    //
    //   });
    // }

    return POkhatState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        poKhatDetailListModel:
            poKhatDetailListModel ?? this.poKhatDetailListModel,
        pokhatDetailId: pokhatDetailId ?? this.pokhatDetailId,
        poKhatPendingListModel:
            poKhatPendingListModel ?? this.poKhatPendingListModel,
        purchasers: purchasers ?? this.purchasers,
        isPoKhatsaved: isPoKhatsaved ?? this.isPoKhatsaved,
        locations: locations ?? this.locations,
        filterModel: filterModel ?? this.filterModel,
        transportModeTypes: transportModeTypes ?? this.transportModeTypes,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        selectedDate: selectedDate ?? this.selectedDate,
        pokhatItems: pokhatItems ?? this.pokhatItems,
        selectedPaymentMode: selectedPaymentMode ?? this.selectedPaymentMode,
        selectedPurchaser: selectedPurchaser,
        p: p,
        //?? this.selectedPurchaser,
        selectedSupplier: selectedSupplier ?? this.selectedSupplier,
        purchaserName: purchaserName ?? this.purchaserName,
        selectedTransportTypes:
            selectedTransportTypes ?? this.selectedTransportTypes,
        suppliers: suppliers ?? this.suppliers,
        khatLocations: khatLocations ?? this.khatLocations,
        frmDate: DateTime((DateTime.now()).year, (DateTime.now()).month, 1),
        toDate: DateTime.now(),
        pokhatPendingDetailList:
            pokhatPendingDetailList ?? this.pokhatPendingDetailList,
        khatHdrModel: khatHdrModel ?? this.khatHdrModel);
  }

  factory POkhatState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return POkhatState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      selectedLocation: null,
      purchasers: List(),
      transportModeTypes: [],
      pokhatDetailId: 0,
      poKhatPendingListModel: null,
      poKhatDetailListModel: null,
      locations: [],
      pokhatItems: [],
      frmDate: startDate,
      pokhatPendingDetailList: [],
      toDate: currentDate,
      isPoKhatsaved: false,
      scrollPosition: 0.0,
      selectedTransportTypes: null,
      selectedPurchaser: null,
      selectedPaymentMode: null,
      selectedSupplier: null,
      suppliers: [],
      khatLocations: [],
      purchaserName: null,
      khatHdrModel: null,
      filterModel: FilterModel(
          fromDate: startDate,
          toDate: currentDate,
          loc: null,
          reqNo: "",
          suppliers: null),
      selectedDate: DateTime.now(),
    );
  }
}

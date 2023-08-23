import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/po_khat/po_khat_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/po_khat/po_khat_state.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_payment_types_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

class PokhatViewModel extends BaseViewModel {
  final List<KhatPurchasers> purchasers;
  final List<BranchStockLocation> locations;
  final List<BCCModel> transportModeTypes;
  final BranchStockLocation selectedLocation;
  final bool isPoKhatsaved;
  final String purchaserName;
  final DateTime selectedDate;
  final FilterModel filterModel;
  final POKhatDetailListModel poKhatDetailListModel;
  final POKhatPendingListModel poKhatPendingListModel;
  final double scrollPosition;
  final DateTime frmDate;
  final DateTime toDate;
  final int pokhatDetailId;
  final List<POKhatSaveModel> pokhatItems;
  final Function clearresult;
  final int optionId;
  final VoidCallback onClear;
  final Function(
      POKhatPendingListModel pendingListModel,
      int start,
      FilterModel filter,
      List<POKhatPendingListModelList> pendingList) onFetchPoPendingList;
  final Function(FilterModel filter) onApplyFilter;
  final Function() onSavePokhat;
  final Function() getPokhatDetailList;
  final PoKhatHdrModel khatHdrModel;
  final Function(PoKhatHdrModel) onSaveHdr;
  final Function(POKhatSaveModel) onRemovePokhatItem;
  final Function({POKhatSaveModel khatItems, int typeOfadding}) onAddNewItem;
  final Function(POKhatPendingListModelList) onDetailCall;
  final Function(
      POKhatPendingListModel pendingListModel,
      int start,
      FilterModel filter,
      List<POKhatPendingListModelList> pendingList) onRefresh;
  final List<SupplierLookupItem> suppliers;
  final Function(List<dynamic> changedItems) onChangeSuppliers;
  final KhatPurchasers selectedPurchaser;
  final BCCModel selectedTransportTypes;
  final SupplierQuotaItem selectedSupplier;
  final POKhatPaymentTypesModel selectedPaymentMode;
  final Function(FilterModel) onSelectFilter;
  final Function(FilterModel, int, List<POKhatPendingListModelList>)
      onUserFilterApply;
  final List<BranchStockLocation> khatLocations;
  final List<dynamic> khatSupplier;
  final Function({int newSupplierId}) supplierChange;
  final Function({int newPurchaserId}) purchaserChange;
  final Function({String newPaymentMode}) paymentChange;
  final Function({int newdate}) dateChange;
  final User user;
  final Function(BranchStockLocation location) onPoKhatLocationChange;
  final List<POKhatDetailList> detailList;
  final Function() onCallSuppliers;
  final String locationName;
  PokhatViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.pokhatItems,
    this.purchasers,
    this.locations,
    this.clearresult,
    this.transportModeTypes,
    this.selectedLocation,
    this.isPoKhatsaved,
    this.selectedDate,
    this.filterModel,
    this.purchaserChange,
    this.paymentChange,
    this.dateChange,
    this.supplierChange,
    this.poKhatDetailListModel,
    this.poKhatPendingListModel,
    this.scrollPosition,
    this.frmDate,
    this.toDate,
    this.pokhatDetailId,
    this.optionId,
    this.onClear,
    this.onApplyFilter,
    this.onSavePokhat,
    this.getPokhatDetailList,
    this.onFetchPoPendingList,
    this.onRemovePokhatItem,
    this.onAddNewItem,
    this.onDetailCall,
    this.selectedTransportTypes,
    this.selectedSupplier,
    this.selectedPurchaser,
    this.selectedPaymentMode,
    this.onRefresh,
    this.suppliers,
    this.onChangeSuppliers,
    this.onSelectFilter,
    this.onUserFilterApply,
    this.khatLocations,
    this.khatSupplier,
    this.khatHdrModel,
    this.onSaveHdr,
    this.user,
    this.purchaserName,
    this.onPoKhatLocationChange,
    this.detailList,
    this.onCallSuppliers,
    this.locationName,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory PokhatViewModel.fromStore(Store<AppState> store) {
    POkhatState state = store.state.pokhatState;
    var optionId = store.state.homeState.selectedOption.optionId;
    String data = store.state.homeState.user.locationName;

    return PokhatViewModel(
      loadingStatus: state.loadingStatus,
      errorMessage: state.loadingError,
      loadingMessage: state.loadingMessage,
      selectedDate: state.selectedDate,
      filterModel: state.filterModel,
      frmDate: state.frmDate,
      toDate: state.toDate,
      scrollPosition: state.scrollPosition,
      optionId: optionId,
      purchasers: state.purchasers,
      poKhatDetailListModel: state.poKhatDetailListModel,
      poKhatPendingListModel: state.poKhatPendingListModel,
      transportModeTypes: state.transportModeTypes,
      selectedLocation: state.selectedLocation,
      isPoKhatsaved: state.isPoKhatsaved,
      pokhatDetailId: state.pokhatDetailId,
      locations: state.locations,
      pokhatItems: state.pokhatItems,
      selectedSupplier: state.selectedSupplier,
      selectedPaymentMode: state.selectedPaymentMode,
      selectedPurchaser: state.p,
      selectedTransportTypes: state.selectedTransportTypes,
      khatLocations: state.khatLocations,
      khatSupplier: state.suppliers,
      khatHdrModel: state.khatHdrModel,
      user: store.state.homeState.user,
      purchaserName: state.purchaserName,
      detailList: state.pokhatPendingDetailList,
      locationName: data,
      onSaveHdr: (hderModel) {
        store.dispatch(SavePokhatHeaderModel(hderModel));
      },
      onRefresh: (pendingListModel, start, filter, pendingList) {
        store.dispatch(fetchPokhatPendingListAction(
            start: start,
            pokhatFilter: filter,
            optionId: optionId,
            pendingPoKhatList: pendingList));
      },
      onDetailCall: (selectedPokhatPendigList) {
        store.dispatch(fetchPOKhatDetailList(
            start: 0,
            optionId: optionId,
            selectedPendingList: selectedPokhatPendigList,
            sor_Id: selectedPokhatPendigList.start,
            eor_Id: selectedPokhatPendigList.limit,
            totalRecords: selectedPokhatPendigList.totalrecords,
            filterModel: FilterModel(
                fromDate:
                    DateTime((DateTime.now()).year, (DateTime.now()).month, 1),
                toDate: DateTime.now())));
      },
      onAddNewItem: ({POKhatSaveModel khatItems, int typeOfadding}) {
        store.dispatch(PokhatAddItemAction(khatItems, typeOfadding));
      },
      onRemovePokhatItem: (khatItem) {
        store.dispatch(PokhatRemoveItemsAction(khatItem));
      },
      onCallSuppliers: () {
        store.dispatch(fetchPoKhatSuppliers());
      },
      onFetchPoPendingList: (pendingListModel, start, filter, pendingList) {
        store.dispatch(fetchPokhatPendingListAction(
            start: start,
            pokhatFilter: filter,
            optionId: optionId,
            pendingPoKhatList: pendingList));
      },
      // onChangeItems: (data) {
      //   store.dispatch(ChangeItemsAction(data));
      // },
      onApplyFilter: (filterModel) {
        store.dispatch(PokhatFilterChangeAction(filterModel));
      },

      supplierChange: ({int newSupplierId}) {
        store.dispatch(SupplierChangeAction(newSupplierId));
      },
      purchaserChange: ({int newPurchaserId}) {
        store.dispatch(PurchaserChangeAction(newPurchaserId));
      },
      paymentChange: ({String newPaymentMode}) {
        store.dispatch(PaymentChangeAction(newPaymentMode));
      },

      dateChange: ({int newdate}) {
        store.dispatch(DateChangeAction(newdate));
      },

      onUserFilterApply: (filter, start, pendingPoList) {
        store.dispatch(fetchPokhatPendingListAction(
            start: start,
            // sor_Id: pendingPoList.first.start,
            // eor_Id: pendingPoList.first.limit,
            // totalRecords: pendingPoList.first.totalrecords,
            pokhatFilter: filter,
            optionId: optionId,
            pendingPoKhatList: pendingPoList));
      },
      clearresult: () {
        store.dispatch(clearaction);
      },
      onChangeSuppliers: (khatSupliers) {
        store.dispatch(ChangePokhatSuppliersAction(khatSupliers));
      },
      // onDateChange: (date) {
      //   store.dispatch(ChangeDateAction(date));
      // },
      // onClickSubms: (
      //   filter,
      //   start,
      //   viewList,
      // ) {
      //   store.dispatch(fetchItemGradeRateSettingsViewPageListData(
      //       optionId: optionId ?? 795,
      //       start: start,
      //       listData: viewList,
      //       filterModel: ItemGradeRateSettingsFilterModel(
      //           fromDate: filter?.fromDate ?? state.toDate,
      //           toDate: filter?.toDate ?? state.frmDate,
      //           locObj: filter?.locObj ?? state.selectedLocation,
      //           datas: filter.datas,
      //           pricingNo: filter.pricingNo)));
      // },
      // onDataSubmission: (filter) {
      //   store.dispatch(fetchItemGradeRateSettingsViewPageListData(
      //       optionId: optionId,
      //       start: 0,
      //       listData: [],
      //       filterModel: ItemGradeRateSettingsFilterModel(
      //           fromDate: filter?.fromDate ?? state.toDate,
      //           toDate: filter?.toDate ?? state.frmDate,
      //           locObj: filter?.locObj ?? state.selectedLocation,
      //           datas: filter.datas,
      //           pricingNo: filter.pricingNo)));
      // },
      // onPendingItemGradeRateTap: (valueId) {
      //   store.dispatch(fetchItemGradeRateViewDetailListData(
      //       optionId: optionId,
      //       start: 0,
      //       sor_Id: valueId.start,
      //       eor_Id: valueId.limit,
      //       totalRecords: valueId.totalrecords,
      //       filterModel: ItemGradeRateSettingsFilterModel(
      //           fromDate: state.toDate,
      //           toDate: state.frmDate,
      //           locObj: state.selectedLocation,
      //           pricingNo: ""),
      //       valueId: valueId));
      // },
      // onGetItemGradeRateViewDetailPage: (start, list, filter) {
      //   store.dispatch(fetchItemGradeRateViewDetailListData(
      //       optionId: optionId,
      //       filterModel: ItemGradeRateSettingsFilterModel(
      //           fromDate: filter.fromDate,
      //           toDate: filter.toDate,
      //           locObj: filter.locObj,
      //           pricingNo: filter.pricingNo)));
      // },
      // onGetItemGradeRateViewPage: (start, list, filter) {
      //   store.dispatch(fetchItemGradeRateSettingsViewPageListData(
      //       filterModel: ItemGradeRateSettingsFilterModel(
      //           fromDate: filter.fromDate,
      //           toDate: filter.toDate,
      //           locObj: filter.locObj,
      //           pricingNo: filter.pricingNo)));
      // },
      onSavePokhat: () {
        store.dispatch(savePokhatAction(
            optionId: optionId,
            hdrModel: state.khatHdrModel,
            poKhatDetailListModel: state.poKhatDetailListModel,
            remarks: "",
            pokhatItems: state.pokhatItems));
      },
      onSelectFilter: (filter) {
        store.dispatch(PokhatFilterChangeAction(filter));
      },
      onClear: () => {
        store.dispatch(PokhatClearAction()),
        //  store.dispatch(fetchInitialData()),
      },
      onPoKhatLocationChange: (location) {
        store.dispatch(PokhatLocationChangeAction(location: location));
      },
      // onRemoveItem: (item) =>
      //     store.dispatch(RemoveItemGradeRateRequisitionAction(item)),
      // onStockRemoveItem: (item) =>
      //     store.dispatch(RemoveSelectedStockRequisitionAction(item)),
      // onAdd: (model) => store.dispatch(AddNewItemGradeRateAction(model))
    );
  }
}

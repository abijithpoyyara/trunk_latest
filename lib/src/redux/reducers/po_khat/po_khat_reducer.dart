import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/item_grade_rate_settings/item_grade_rate_settings_action.dart';
import 'package:redstars/src/redux/actions/po_khat/po_khat_action.dart';
import 'package:redstars/src/redux/states/po_khat/po_khat_state.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_payment_types_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

final pokhatReducer = combineReducers<POkhatState>([
  TypedReducer<POkhatState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<POkhatState, PokhatClearAction>(_disposeAction),
  TypedReducer<POkhatState, GetPoKhatInitialConfigAction>(
      _pokhatConfigFetchAction),
  TypedReducer<POkhatState, PokhatLocationChangeAction>(_locationChangeAction),
  TypedReducer<POkhatState, PokhatAddItemAction>(_newItemAction),
  TypedReducer<POkhatState, PokhatRemoveItemsAction>(_removeItemAction),
  TypedReducer<POkhatState, PoKhatSaveAction>(_saveAction),
  TypedReducer<POkhatState, ChangeDateAction>(_changeDateAction),
  TypedReducer<POkhatState, PokhatPendingListAction>(_pokhatendingListAction),
  //TypedReducer<POkhatState, POkhatDetailsDataAction>(_pokhatDetailsListAction),
  TypedReducer<POkhatState, PokhatFilterChangeAction>(_changeFilterAction),
  TypedReducer<POkhatState, PokhatLocationObj>(_pokhatLocationAction),
  TypedReducer<POkhatState, ChangePokhatSuppliersAction>(
      _pokhatSuppliersAction),
  TypedReducer<POkhatState, SavePokhatHeaderModel>(_pokhatHdrSaveAction),
  TypedReducer<POkhatState, clearaction>(_clearaction),
  TypedReducer<POkhatState, SupplierChangeAction>(_supplierChangeAction),
  TypedReducer<POkhatState, PurchaserChangeAction>(_purchaserChangeAction),
  TypedReducer<POkhatState, PaymentChangeAction>(_paymentChangeAction),
  TypedReducer<POkhatState, DateChangeAction>(_dateChangeAction),
  TypedReducer<POkhatState, POkhatDetailsDataAction>(_detailChange),
]);

POkhatState _changeLoadingStatusAction(
    POkhatState state, LoadingAction action) {
  return state.copyWith(
    loadingStatus: action.status,
    loadingMessage: action.message,
    loadingError: action.message,
  );
}

POkhatState _supplierChangeAction(
    POkhatState state, SupplierChangeAction action) {
  state.poKhatDetailListModel.pokhatPendingDetailList.first.supplierid =
      action.newSupplierId;
  return state.copyWith(poKhatDetailListModel: state.poKhatDetailListModel);
}

POkhatState _purchaserChangeAction(
    POkhatState state, PurchaserChangeAction action) {
  state.poKhatDetailListModel.pokhatPendingDetailList.first.purchaserid =
      action.newPurchaserId;
  return state.copyWith(poKhatDetailListModel: state.poKhatDetailListModel);
}

POkhatState _paymentChangeAction(
    POkhatState state, PaymentChangeAction action) {
  state.poKhatDetailListModel.pokhatPendingDetailList.first.paymentmode =
      action.newPaymentMode;
  return state.copyWith(poKhatDetailListModel: state.poKhatDetailListModel);
}

POkhatState _dateChangeAction(POkhatState state, DateChangeAction action) {
  return state.copyWith();
}

POkhatState _pokhatHdrSaveAction(
    POkhatState state, SavePokhatHeaderModel action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      khatHdrModel: action.hdrModel);
}

POkhatState _pokhatSuppliersAction(
    POkhatState state, ChangePokhatSuppliersAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      suppliers: action.suppliers);
}

POkhatState _pokhatLocationAction(POkhatState state, PokhatLocationObj action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      khatLocations: action.locations);
}

// POkhatState _itemsChangeAction(
//     POkhatState state, ChangeItemsAction action) {
//   return state.copyWith(
//     loadingStatus: LoadingStatus.success,
//     loadingMessage: "",
//     loadingError: "",
//     changedItems: action.itemDatas,
//   );
// }

POkhatState _pokhatendingListAction(
    POkhatState state, PokhatPendingListAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      poKhatPendingListModel: action.poKhatPendingListModel);
}

POkhatState _changeFilterAction(
    POkhatState state, PokhatFilterChangeAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    filterModel: action.filterModel,
  );
}

POkhatState _pokhatConfigFetchAction(
    POkhatState state, GetPoKhatInitialConfigAction action) {
  print(action.purchaserObj.length);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    transportModeTypes: action.transportModeTypes,
    purchasers: action.purchaserObj,
  );
}

POkhatState _detailChange(POkhatState state, POkhatDetailsDataAction action) {
  POKhatSaveModel khatSavingModel;
  List<POKhatSaveModel> khatModelList = [];
  KhatPurchasers selectedPur;
  SupplierQuotaItem selectedSupplier =
      action.poKhatDetailListMode.pokhatPendingDetailList != null
          ? SupplierQuotaItem(
              name: action
                  .poKhatDetailListMode.pokhatPendingDetailList.first.supplier,
              Id: action.poKhatDetailListMode.pokhatPendingDetailList.first
                  .supplierid)
          : null;

  BranchStockLocation selectedLoctn;
  state.khatLocations.forEach((element) {
    if (element.name ==
        action.poKhatDetailListMode.pokhatPendingDetailList.first.location) {
      //  targetLocation.add(element);
      selectedLoctn = element;
    }
    return selectedLoctn;
  });
  state.purchasers.forEach((element) {
    if (element.personnelid ==
        action.poKhatDetailListMode.pokhatPendingDetailList.first.purchaserid) {
      selectedPur = element;
    }
    return selectedPur;
  });
  for (int i = 0;
      i <
          action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls
              .length;
      i++) {
    khatSavingModel = POKhatSaveModel(
        pokhatId:
            action.poKhatDetailListMode?.pokhatPendingDetailList?.first?.detailsDtls[i]?.Id ??
                0,
        uom: UomTypes(
          uomid: action.poKhatDetailListMode.pokhatPendingDetailList.first
              .detailsDtls[i].uomid,
          uomtypebccid: action.poKhatDetailListMode.pokhatPendingDetailList
              .first.detailsDtls[i].uomtypebccid,
        ),
        statusBccId: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls.first.statusbccid,
        statusDate: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].statuswefdate,
        deliveryDueDate: action.poKhatDetailListMode.pokhatPendingDetailList
            .first.detailsDtls[i].deliveryduedate,
        exchangeRate: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].exchrate,
        location: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].location,
        selectedPurchaser: KhatPurchasers(
            description: action.poKhatDetailListMode.pokhatPendingDetailList
                .first.purchasername),
        item: ItemLookupItem(
            description: action.poKhatDetailListMode.pokhatPendingDetailList
                .first.detailsDtls[i].itemname,
            code: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].itemcode,
            id: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].itemid),
        qty: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].qty,
        //   selectedPurchaser: selectedPurchaser,
        // selectedSupplier: selectedSupplier,
        selectedPaymentType: POKhatPaymentTypesModel(name: action.poKhatDetailListMode.pokhatPendingDetailList.first.paymentmode == "CR" ? "Credit" : "Cash", code: action.poKhatDetailListMode.pokhatPendingDetailList.first.paymentmode));

    khatModelList.add(khatSavingModel);
  }

  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    pokhatPendingDetailList:
        action.poKhatDetailListMode.pokhatPendingDetailList,
    pokhatItems: khatModelList,
    selectedPurchaser: selectedPur,
    poKhatDetailListModel: action.poKhatDetailListMode,
    selectedLocation: selectedLoctn,
    p: selectedPur,
    purchaserName:
        action.poKhatDetailListMode.pokhatPendingDetailList.first.purchasername,
    khatHdrModel: PoKhatHdrModel(
        selectedPurchaser: selectedPur,
        selectedPaymentType: POKhatPaymentTypesModel(
            name: action.poKhatDetailListMode.pokhatPendingDetailList.first
                        .paymentmode ==
                    "CR"
                ? "Credit"
                : "Cash",
            code: action.poKhatDetailListMode.pokhatPendingDetailList.first
                .paymentmode),
        selectedSupplier: selectedSupplier,
        remarks:
            action.poKhatDetailListMode.pokhatPendingDetailList.first.remarks),
  );
}

POkhatState _pokhatDetailsListAction(
    POkhatState state, POkhatDetailsDataAction action) {
  POKhatSaveModel model;
  List<POKhatSaveModel> khatList = [];

  KhatPurchasers selectedPurchaser;

  state.purchasers.forEach((purchaser) {
    if (purchaser.personnelid ==
        action.poKhatDetailListMode.pokhatPendingDetailList.first.purchaserid) {
      selectedPurchaser = purchaser;
    }
    return selectedPurchaser;
  });
  SupplierQuotaItem selectedSupplier =
      action.poKhatDetailListMode.pokhatPendingDetailList != null
          ? SupplierQuotaItem(
              name: action
                  .poKhatDetailListMode.pokhatPendingDetailList.first.supplier,
              Id: action.poKhatDetailListMode.pokhatPendingDetailList.first
                  .supplierid)
          : null;

  BranchStockLocation selectedLoctn;
  state.khatLocations.forEach((element) {
    if (element.name ==
        action.poKhatDetailListMode.pokhatPendingDetailList.first.location) {
      //  targetLocation.add(element);
      selectedLoctn = element;
    }
    return selectedLoctn;
  });

  for (int i = 0;
      i <
          action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls
              .length;
      i++) {
    model = POKhatSaveModel(
        pokhatId:
            action.poKhatDetailListMode?.pokhatPendingDetailList?.first?.detailsDtls[i]?.Id ??
                0,
        uom: UomTypes(
          uomid: action.poKhatDetailListMode.pokhatPendingDetailList.first
              .detailsDtls[i].uomid,
          uomtypebccid: action.poKhatDetailListMode.pokhatPendingDetailList
              .first.detailsDtls[i].uomtypebccid,
        ),
        statusBccId: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls.first.statusbccid,
        statusDate: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].statuswefdate,
        deliveryDueDate: action.poKhatDetailListMode.pokhatPendingDetailList
            .first.detailsDtls[i].deliveryduedate,
        exchangeRate: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].exchrate,
        location: action.poKhatDetailListMode.pokhatPendingDetailList.first
            .detailsDtls[i].location,
        selectedPurchaser: KhatPurchasers(
            description: action.poKhatDetailListMode.pokhatPendingDetailList
                .first.purchasername),
        item: ItemLookupItem(
            description: action.poKhatDetailListMode.pokhatPendingDetailList
                .first.detailsDtls[i].itemname,
            code: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].itemcode,
            id: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].itemid),
        qty: action.poKhatDetailListMode.pokhatPendingDetailList.first.detailsDtls[i].qty,
        //   selectedPurchaser: selectedPurchaser,
        selectedSupplier: selectedSupplier,
        selectedPaymentType: POKhatPaymentTypesModel(name: action.poKhatDetailListMode.pokhatPendingDetailList.first.paymentmode == "CR" ? "Credit" : "Cash", code: action.poKhatDetailListMode.pokhatPendingDetailList.first.paymentmode));

    khatList.add(model);
  }

  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      pokhatItems: khatList,
      selectedLocation: selectedLoctn,
      selectedPurchaser: KhatPurchasers(
          personnelid: action
              .poKhatDetailListMode.pokhatPendingDetailList.first.purchaserid,
          description: action.poKhatDetailListMode.pokhatPendingDetailList.first
              .purchasername),
      selectedSupplier: selectedSupplier,
      poKhatDetailListModel: action.poKhatDetailListMode,
      khatHdrModel: PoKhatHdrModel(
          //selectedPurchaser: selectedPurchaser,
          selectedPaymentType: POKhatPaymentTypesModel(
              name: action.poKhatDetailListMode.pokhatPendingDetailList.first
                          .paymentmode ==
                      "CR"
                  ? "Credit"
                  : "Cash",
              code: action.poKhatDetailListMode.pokhatPendingDetailList.first
                  .paymentmode),
          selectedSupplier: selectedSupplier,
          remarks: action
              .poKhatDetailListMode.pokhatPendingDetailList.first.remarks),
      purchaserName: action
          .poKhatDetailListMode.pokhatPendingDetailList.first.purchasername);
}

POkhatState _clearaction(POkhatState state, clearaction action) {
  return POkhatState.initial();
}

POkhatState _changeDateAction(POkhatState state, ChangeDateAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    selectedDate: action.pricingDate,
  );
}

POkhatState _newItemAction(POkhatState state, PokhatAddItemAction action) {
  bool actn = false;
  state.pokhatItems.forEach((element) {
    if (element.item.description == action.pokhatItems.item.description) {
      actn = true;
    } else {}
  });

  if (actn == true) {
    state.pokhatItems.forEach((element) {
      if (element.item.description == action.pokhatItems.item.description) {
        element.qty = action.pokhatItems.qty;
      }
    });
    return state.copyWith(pokhatItems: state.pokhatItems);
  }
  if (actn == false) {
    return state
        .copyWith(pokhatItems: [action.pokhatItems, ...state.pokhatItems]);
  }
}

POkhatState _saveAction(POkhatState state, PoKhatSaveAction action) {
  return state.copyWith(
    isPoKhatsaved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

POkhatState _disposeAction(POkhatState state, PokhatClearAction action) {
  DateTime currentDate = DateTime.now();
  DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
  return POkhatState.initial().copyWith(
      isPoKhatsaved: false,
      suppliers: state.suppliers,
      purchasers: state.purchasers,
      khatLocations: state.khatLocations,
      filterModel: FilterModel(
          fromDate: startDate,
          toDate: currentDate,
          loc: null,
          reqNo: "",
          suppliers: null));
}

POkhatState _removeItemAction(
    POkhatState state, PokhatRemoveItemsAction action) {
  List<POKhatSaveModel> items = state.pokhatItems;

  if (items.contains(action.pokhatItems)) {
    items.remove(action.pokhatItems);
    return state.copyWith(pokhatItems: items);
  }
  return state.copyWith();
}

POkhatState _locationChangeAction(
    POkhatState state, PokhatLocationChangeAction action) {
  return state.copyWith(
    selectedLocation: action.location,
  );
}

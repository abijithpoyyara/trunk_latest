import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/repository/po_khat/po_khat_repository.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

class GetPoKhatInitialConfigAction {
  final List<BCCModel> transportModeTypes;
  final List<KhatPurchasers> purchaserObj;

  GetPoKhatInitialConfigAction({this.transportModeTypes, this.purchaserObj});
}

class ChangePokhatPurchaser {
  final KhatPurchasers khatPurchaser;

  ChangePokhatPurchaser(this.khatPurchaser);
}

class PokhatLocationObj {
  final List<BranchStockLocation> locations;

  PokhatLocationObj(this.locations);
}

class SupplierChangeAction {
  final int newSupplierId;
  SupplierChangeAction(this.newSupplierId);
}

class PurchaserChangeAction {
  final int newPurchaserId;
  PurchaserChangeAction(this.newPurchaserId);
}

class PaymentChangeAction {
  final String newPaymentMode;
  PaymentChangeAction(this.newPaymentMode);
}

class DateChangeAction {
  final int newdate;
  DateChangeAction(this.newdate);
}

class PoKhatSaveAction {}

class PokhatPendingListAction {
  final POKhatPendingListModel poKhatPendingListModel;

  PokhatPendingListAction(this.poKhatPendingListModel);
}

class PokhatFilterChangeAction {
  final FilterModel filterModel;

  PokhatFilterChangeAction(this.filterModel);
}

class clearaction {}

class POkhatDetailsDataAction {
  POKhatDetailListModel poKhatDetailListMode;

  POkhatDetailsDataAction(this.poKhatDetailListMode);
}

class ChangePokhatSuppliersAction {
  List<dynamic> suppliers;
  ChangePokhatSuppliersAction(this.suppliers);
}

class PokhatClearAction {}

class PokhatLocationChangeAction {
  BranchStockLocation location;

  PokhatLocationChangeAction({
    this.location,
  });
}

class PokhatRemoveItemsAction {
  final POKhatSaveModel pokhatItems;

  PokhatRemoveItemsAction(this.pokhatItems);
}

class SavePokhatHeaderModel {
  final PoKhatHdrModel hdrModel;

  SavePokhatHeaderModel(this.hdrModel);
}

class PokhatAddItemAction {
  final POKhatSaveModel pokhatItems;
  final int typeOfadding;
  PokhatAddItemAction(this.pokhatItems, this.typeOfadding);
}

ThunkAction fetchKhatPoLocation() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      POKhatRepository().getLocationList(
        onRequestSuccess: (loc) {
          store.dispatch(PokhatLocationObj(loc));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPoKhatSuppliers() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      POKhatRepository().getPokhatSuplliers(
        onRequestSuccess: (status) {
          store.dispatch(new ChangePokhatSuppliersAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPOKhatDetailList({
  int start,
  int sor_Id,
  int eor_Id,
  int totalRecords,
  int optionId,
  FilterModel filterModel,
  POKhatPendingListModelList selectedPendingList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
      ));
      POKhatRepository().getPoKhatDetailList(
        start: start,
        optionId: optionId,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        selectedPendingList: selectedPendingList,
        filterModel: filterModel,
        onRequestSuccess: (result) {
          store.dispatch(new POkhatDetailsDataAction(result));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPokhatPendingListAction({
  int start,
  int optionId,
  int sor_Id,
  int eor_Id,
  bool initilaLoading,
  int totalRecords,
  FilterModel pokhatFilter,
  List<POKhatPendingListModelList> pendingPoKhatList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
      ));
      POKhatRepository().getPoKhatPendingList(
        start: start,
        optionId: optionId,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        pokhatFilter: pokhatFilter,
        onRequestSuccess: (result) {
          pendingPoKhatList.addAll(result.pokhatPendingList);
          store.dispatch(new PokhatPendingListAction(result));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPokhatInitialConfigAction() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      POKhatRepository().getPOKhatInitialConfig(
        onRequestSuccess: (
                {List<BCCModel> transportModeTypes,
                List<KhatPurchasers> purchaserObj}) =>
            store.dispatch(new GetPoKhatInitialConfigAction(
                purchaserObj: purchaserObj,
                transportModeTypes: transportModeTypes)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction savePokhatAction({
  POKhatDetailListModel poKhatDetailListModel,
  int optionId,
  String remarks,
  List<POKhatSaveModel> pokhatItems,
  PoKhatHdrModel hdrModel,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving ",
      ));

      POKhatRepository().savePOKhat(
        hdrModel: hdrModel,
        optionId: optionId,
        remarks: remarks,
        poKhatDetailListModel: poKhatDetailListModel,
        pokhatitems: pokhatItems,
        onRequestSuccess: () => store.dispatch(new PoKhatSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

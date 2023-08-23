import 'package:base/redux.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/material/pickers/date_picker_common.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/src/services/repository/po_acknowledge/acknowledge_repository.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';

class POListFetchSuccessAction {
  final List<PurchaseOrderModel> orders;
  final AcknowledgeType type;
  final double offset;

  POListFetchSuccessAction({this.orders, this.type, this.offset});
}

class PODetailsFetchedAction {
  PODetailModel orderDetails;
  PurchaseOrderModel selectedOrder;
  String remarks;

  PODetailsFetchedAction(this.orderDetails, this.selectedOrder, this.remarks);
}

class VehicleSaveAction {
  POVehicleModel vehicle;

  VehicleSaveAction(this.vehicle);
}

class VehicleDeletedAction {
  POVehicleModel vehicle;

  VehicleDeletedAction(this.vehicle);
}

class POARemarksChangeAction {
  final String remarks;

  POARemarksChangeAction(this.remarks);
}

class POADetailClearAction {}

class POASavedAction {}

ThunkAction refreshPOs({POFilterModel filters}) {
  return (Store store) async {
    new Future(() async {
      AcknowledgeType.values.forEach((type) {
        store.dispatch(fetchPOList(type, filters: filters));
      });
    });
  };
}

ThunkAction fetchPOList(AcknowledgeType type,
    {POFilterModel filters, double offset = 0.0, int start = 0}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
        //type: type,
      ));
      AcknowledgeRepository().getPurchaseOrders(
        // transNo: filters.transNo,
        fromDate: filters.dateRange.start,
        toDate: filters.dateRange.end,
        type: type,
        start: start,
        userId: filters.supplier?.id,
        onRequestSuccess: (orders) => store.dispatch(POListFetchSuccessAction(
            orders: orders, type: type, offset: offset)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: type)),
      );
    });
  };
}

ThunkAction fetchPODetails(PurchaseOrderModel order) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Loading List", type: 'POA'));
      AcknowledgeRepository().getPurchaseOrderDetail(
        order,
        onRequestSuccess: (orderDetails) {
          store.dispatch(PODetailsFetchedAction(
              orderDetails, order, orderDetails.remarks));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: 'POA')),
      );
    });
  };
}

ThunkAction onSaveAcknowledgement(
    PODetailModel orderDetails, DateTimeRange filterRange, int supplierId,
    {String remarks}) {
  return (Store store) async {
    final state = store.state.homeState;
    final optionId = state.selectedOption.optionId;
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Saving acknowledgement",
          type: 'POA'));
      AcknowledgeRepository().saveAcknowledgement(
        optionId: optionId,
        poDetails: orderDetails,
        vehicles: orderDetails.vehicles,
        remarks: remarks,
        supplierId: supplierId,
        onRequestSuccess: () {
          store.dispatch(POASavedAction());
          store.dispatch(
              refreshPOs(filters: POFilterModel(dateRange: filterRange)));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: 'POA')),
      );
    });
  };
}

ThunkAction onEditAcknowledgement(
    PODetailModel orderDetails, DateTimeRange filterRange,
    {String remarks}) {
  return (Store store) async {
    new Future(() async {
      final state = store.state.homeState;
      final optionId = state.selectedOption.optionId;
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Saving acknowledgement",
          type: 'POA'));
      AcknowledgeRepository().editAcknowledgement(
        vehicles: orderDetails.vehicles,
        poDetails: orderDetails,
        optionId: optionId,
        remarks: remarks,
        onRequestSuccess: () {
          store.dispatch(POASavedAction());
          store.dispatch(
              refreshPOs(filters: POFilterModel(dateRange: filterRange)));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: 'POA')),
      );
    });
  };
}

ThunkAction onDeleteAcknowledgement(
    PODetailModel orderDetails, DateTimeRange filterRange) {
  return (Store store) async {
    new Future(() async {
      final state = store.state.homeState;
      final optionId = state.selectedOption.optionId;
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Saving acknowledgement",
          type: 'POA'));
      AcknowledgeRepository().deleteAcknowledgement(
        optionId: optionId,
        poDetails: orderDetails,
        onRequestSuccess: () {
          store.dispatch(POASavedAction());
          store.dispatch(
              refreshPOs(filters: POFilterModel(dateRange: filterRange)));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: 'POA')),
      );
    });
  };
}

class SavingModelVarAction {
  DateTimeRange filterRange;
  POAckSupplierLookupItem supplierObj;

  SavingModelVarAction({this.filterRange, this.supplierObj});
}

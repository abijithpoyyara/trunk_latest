import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/po_acknowledge/po_acknowledge_action.dart';
import 'package:redstars/src/redux/states/po_acknowledge/po_acknowledge_state.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/utility.dart';

final acknowledgeReducer = combineReducers<AcknowledgeState>([
  TypedReducer<AcknowledgeState, OnClearAction>(_clearAction),
  TypedReducer<AcknowledgeState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<AcknowledgeState, POListFetchSuccessAction>(_poFetchedAction),
  TypedReducer<AcknowledgeState, POARemarksChangeAction>(_poRemarksAction),
  TypedReducer<AcknowledgeState, PODetailsFetchedAction>(
      _poDetailFetchedAction),
  TypedReducer<AcknowledgeState, VehicleSaveAction>(_saveVehicleAction),
  TypedReducer<AcknowledgeState, VehicleDeletedAction>(_deleteVehicleAction),
  TypedReducer<AcknowledgeState, POADetailClearAction>(_detailClearAction),
  TypedReducer<AcknowledgeState, POASavedAction>(_poaSavedAction),
  TypedReducer<AcknowledgeState, SavingModelVarAction>(_saveFilterRangeAction),
]);

AcknowledgeState _changeLoadingStatusAction(
    AcknowledgeState state, LoadingAction action) {
  if (action.type == "POA") {
    return state.copyWith(
        loadingStatus: action.status,
        loadingMessage: action.message,
        loadingError: action.message);
  } else if (action.type is AcknowledgeType) {
    switch (action.type) {
      case AcknowledgeType.COMPLETED:
        return state.copyWith(
            loadingStatus: action.status,
            loadingMessage: action.message,
            loadingError: action.message);
      case AcknowledgeType.PENDING:
        return state.copyWith(
            loadingStatus: action.status,
            loadingMessage: action.message,
            loadingError: action.message);
      case AcknowledgeType.PROCESSING:
        return state.copyWith(
            loadingStatus: action.status,
            loadingMessage: action.message,
            loadingError: action.message);
    }
  } else {
    return state;
  }
}

AcknowledgeState _poFetchedAction(
    AcknowledgeState state, POListFetchSuccessAction action) {
  switch (action.type) {
    case AcknowledgeType.COMPLETED:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        completedOrders: action.orders,
        completedScrollOffset: action.offset,
      );
    case AcknowledgeType.PROCESSING:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        processingOrders: action.orders,
        processingScrollOffset: action.offset,
      );
    case AcknowledgeType.PENDING:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        pendingOrders: action.orders,
        pendingScrollOffset: action.offset,
      );
  }
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

AcknowledgeState _poDetailFetchedAction(
    AcknowledgeState state, PODetailsFetchedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    selectedOrder: action.selectedOrder,
    orderDetails: action.orderDetails,
    remarks: action.remarks,
  );
}

AcknowledgeState _saveVehicleAction(
    AcknowledgeState state, VehicleSaveAction action) {
  final vehicles = state.orderDetails.vehicles;
  bool found = false;
  if (action.vehicle.id != null) {
    vehicles.forEach(
      (element) {
        if (element.id == action.vehicle.id) {
          found = true;
          element = action.vehicle;
        }
      },
    );
  } else {
    vehicles.forEach(
      (element) {
        if (element.vehicleNo.containsIgnoreCase(action.vehicle.vehicleNo)) {
          found = true;
          element.description = action.vehicle.description;
        }
      },
    );
  }
  if (!found) {
    vehicles.add(action.vehicle);
  }

  final orderDetails = state.orderDetails;
  orderDetails.vehicles = vehicles;

  return state.copyWith(orderDetails: orderDetails);
}

AcknowledgeState _deleteVehicleAction(
    AcknowledgeState state, VehicleDeletedAction action) {
  final vehicles = state.orderDetails.vehicles;
  vehicles.removeWhere(
    (element) =>
        (element.vehicleNo.containsIgnoreCase(action.vehicle.vehicleNo)),
  );
  final orderDetails = state.orderDetails;
  orderDetails.vehicles = vehicles;

  return state.copyWith(orderDetails: orderDetails);
}

AcknowledgeState _detailClearAction(
    AcknowledgeState state, POADetailClearAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    orderDetails: null,
    selectedOrder: null,
    poaSavedStatus: false,
    remarks: '',
  );
}

AcknowledgeState _clearAction(AcknowledgeState state, OnClearAction action) =>
    AcknowledgeState.initial();

AcknowledgeState _poaSavedAction(
    AcknowledgeState state, POASavedAction action) {
  return state.copyWith(
    poaSavedStatus: true,
    remarks: '',
    orderDetails: null,
    selectedOrder: null,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

AcknowledgeState _poRemarksAction(
        AcknowledgeState state, POARemarksChangeAction action) =>
    state.copyWith(remarks: action.remarks);

AcknowledgeState _saveFilterRangeAction(
        AcknowledgeState state, SavingModelVarAction action) =>
    state.copyWith(
        filterRange: action.filterRange, supplierObj: action.supplierObj);

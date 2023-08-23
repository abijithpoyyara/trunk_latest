import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/vehicle_enquiry/vehicle_enquiry_action.dart';
import 'package:redstars/src/redux/states/vehicle_enquiry/vehicle_enquiry_state.dart';

final vehicleEnquiryDetailReducer =
    combineReducers<VehicleEnquiryProductionDetailState>([
  TypedReducer<VehicleEnquiryProductionDetailState, LoadingAction>(
      _lodingStatusAction),
  TypedReducer<VehicleEnquiryProductionDetailState,
      VehicleEnquiryProductionDataAction>(_unconfirmedListFectchAction),
  TypedReducer<VehicleEnquiryProductionDetailState,
      VehicleEnquiryProductionFilterChangeAction>(_filterSaveAction),
  TypedReducer<VehicleEnquiryProductionDetailState,
      VehicleEnquiryProductionClearAction>(_onClearAction),
]);

VehicleEnquiryProductionDetailState _lodingStatusAction(
    VehicleEnquiryProductionDetailState state, LoadingAction action) {
  return state.copyWith(
      loadingMessage: action.message,
      loadingError: action.message,
      loadingStatus: action.status);
}

VehicleEnquiryProductionDetailState _onClearAction(
    VehicleEnquiryProductionDetailState state,
    VehicleEnquiryProductionClearAction action) {
  return VehicleEnquiryProductionDetailState.initial();
}

VehicleEnquiryProductionDetailState _unconfirmedListFectchAction(
    VehicleEnquiryProductionDetailState state,
    VehicleEnquiryProductionDataAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    productionDetails: action.vehicleEnqyProductionData,
  );
}

VehicleEnquiryProductionDetailState _filterSaveAction(
    VehicleEnquiryProductionDetailState state,
    VehicleEnquiryProductionFilterChangeAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      filter: action.filter);
}

import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/vehicle_enquiry/vehicle_enquiry_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/vehicle_enquiry/vehicle_enquiry_state.dart';
import 'package:redstars/src/services/model/response/vehicle_enquiry/vehicle_production_details_model.dart';
import 'package:redstars/src/widgets/screens/vehicle_enquiry/filter_model_vehicle_enquiry.dart';

class VehicleEnquiryProductionDetailViewModel extends BaseViewModel {
  final VehicleEProductionFilterModel filter;
  final List<VehicleProductionDetailsList> productionDetails;

  final Function(VehicleEProductionFilterModel model) onChangeFilter;
  final Function(VehicleEProductionFilterModel model) onSaveFilter;
  VehicleEnquiryProductionDetailViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.filter,
    this.productionDetails,
    this.onChangeFilter,
    this.onSaveFilter,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory VehicleEnquiryProductionDetailViewModel.fromStore(
      Store<AppState> store) {
    VehicleEnquiryProductionDetailState state =
        store.state.vehicleEnquiryProductionDetailState;
    int optionId = store.state.homeState.selectedOption?.optionId;
    String loginUser = store.state.homeState.user.userName;
    return VehicleEnquiryProductionDetailViewModel(
      loadingStatus: state.loadingStatus,
      errorMessage: state.loadingError,
      loadingMessage: state.loadingMessage,
      productionDetails: state.productionDetails,
      filter: state.filter,
      onSaveFilter: (model) {
        store.dispatch(VehicleEnquiryProductionFilterChangeAction(model));
      },
      onChangeFilter: (model) {
        store.dispatch(fetchVechicleProductionListAction(
            filterDetailList: model?.lookupItemVE));
      },
    );
  }
}

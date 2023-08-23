import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/vehicle_enquiry/vehicle_production_details_model.dart';
import 'package:redstars/src/widgets/screens/vehicle_enquiry/filter_model_vehicle_enquiry.dart';

class VehicleEnquiryProductionDetailState extends BaseState {
  final List<VehicleProductionDetailsList> productionDetails;
  final VehicleEProductionFilterModel filter;
  VehicleEnquiryProductionDetailState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.productionDetails,
    this.filter,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  VehicleEnquiryProductionDetailState copyWith({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    List<VehicleProductionDetailsList> productionDetails,
    VehicleEProductionFilterModel filter,
  }) {
    return VehicleEnquiryProductionDetailState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      productionDetails: productionDetails ?? this.productionDetails,
      filter: filter ?? this.filter,
    );
  }

  factory VehicleEnquiryProductionDetailState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return VehicleEnquiryProductionDetailState(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      productionDetails: List(),
      filter: VehicleEProductionFilterModel(
          filterData: FilterDataModel(title: "Customer")),
    );
  }
}

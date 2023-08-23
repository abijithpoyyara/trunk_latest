import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';
import 'package:redstars/src/services/model/response/vehicle_enquiry/vehicle_production_details_model.dart';
import 'package:redstars/src/services/repository/vehicle_enquiry/vehicle_enquiry_repository.dart';
import 'package:redstars/src/widgets/screens/vehicle_enquiry/filter_model_vehicle_enquiry.dart';
import 'package:redux_thunk/redux_thunk.dart';

class VehicleEnquiryProductionDataAction {
  final List<VehicleProductionDetailsList> vehicleEnqyProductionData;

  VehicleEnquiryProductionDataAction(this.vehicleEnqyProductionData);
}

class VehicleEnquiryProductionClearAction {}

class VehicleEnquiryProductionFilterChangeAction {
  final VehicleEProductionFilterModel filter;

  VehicleEnquiryProductionFilterChangeAction(this.filter);
}

ThunkAction fetchVechicleProductionListAction(
    {VehicleFilterDetailListLookupItem filterDetailList}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));

      VehicleEnquiryProductionDetailsRepository().getVehicleProductionDetails(
          vehicleFilterDetailList: filterDetailList,
          onRequestSuccess: (result) =>
              {store.dispatch(VehicleEnquiryProductionDataAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

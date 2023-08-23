import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';

class VehicleEProductionFilterModel {
  VehicleFilterDetailListLookupItem lookupItemVE;
  FilterDataModel filterData;
  String modelNo;
  String engineNo;
  String customerName;
  String phnNo;
  String vehicleNo;
  String chassisNo;

  VehicleEProductionFilterModel(
      {this.filterData,
      this.chassisNo,
      this.customerName,
      this.engineNo,
      this.lookupItemVE,
      this.modelNo,
      this.phnNo,
      this.vehicleNo});
}

class FilterDataModel {
  String title;
  FilterDataModel({this.title});
}

List<FilterDataModel> FilterData = [
  FilterDataModel(title: "Customer"),
  FilterDataModel(title: "Vehicle")
];

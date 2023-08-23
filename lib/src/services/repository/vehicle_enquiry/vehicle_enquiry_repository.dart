import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';
import 'package:redstars/src/services/model/response/vehicle_enquiry/vehicle_production_details_model.dart';

class VehicleEnquiryProductionDetailsRepository extends BaseRepository {
  static final VehicleEnquiryProductionDetailsRepository _instance =
      VehicleEnquiryProductionDetailsRepository._();

  VehicleEnquiryProductionDetailsRepository._();

  factory VehicleEnquiryProductionDetailsRepository() => _instance;

  getVehicleProductionDetails(
      {VehicleFilterDetailListLookupItem vehicleFilterDetailList,
      @required
          Function(List<VehicleProductionDetailsList> vehicleProductionDetail)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getdata";

    String xmlVehicle = XMLBuilder(tag: "List")
        .addElement(
            key: "EngineNo",
            value:
                "%${vehicleFilterDetailList?.engineno}%" ?? "%neenatest12345%")
        .addElement(
            key: "ChassisNo",
            value:
                "%${vehicleFilterDetailList?.chassisno}%" ?? "%neenatest1234%")
        .addElement(
            key: "ItemId", value: "${vehicleFilterDetailList?.itemid ?? 1860}")
        .addElement(key: "Flag", value: "EQU")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlVehicle,
            procName: "VehicleEnquiryListProc",
            actionFlag: "LIST",
            subActionFlag: "VIEW")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          VehicleProductionDetailListModel responseJson =
              VehicleProductionDetailListModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.vehicleProductionDetail);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}

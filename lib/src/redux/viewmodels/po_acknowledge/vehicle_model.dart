import 'package:redstars/utility.dart';

class POVehicleModel {
  int id;
  int tableId;
  String description;
  String vehicleNo;

  POVehicleModel({this.id, this.description, this.vehicleNo});

  POVehicleModel.fromJson(Map<String, dynamic> json) {
    description = BaseJsonParser.goodString(json, 'remarks');
    vehicleNo = BaseJsonParser.goodString(json, 'vehicleno');
    id = BaseJsonParser.goodInt(json, 'id');
    tableId = BaseJsonParser.goodInt(json, 'tableid');
  }
}

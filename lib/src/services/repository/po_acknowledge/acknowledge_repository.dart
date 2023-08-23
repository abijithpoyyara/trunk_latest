import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/utility.dart';

class AcknowledgeRepository extends BaseRepository {
  static final AcknowledgeRepository _instance = AcknowledgeRepository._();

  AcknowledgeRepository._();

  factory AcknowledgeRepository() {
    return _instance;
  }

  getPurchaseOrders({
    @required AcknowledgeType type,
    @required ValueSetter<List<PurchaseOrderModel>> onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
    String transNo,
    int start = 0,
    int userId,
    DateTime fromDate,
    DateTime toDate
  }) async {
    String service = "getdata";
    String flag = '';
    switch (type) {
      case AcknowledgeType.COMPLETED:
        flag = 'COMPLETED';
        break;
      case AcknowledgeType.PROCESSING:
        flag = 'PROCESSING';
        break;
      case AcknowledgeType.PENDING:
        flag = 'PENDING_PO';
        break;
    }

    String xml = XMLBuilder(tag: "List", elements: [
      if(userId!=null)
      XMLElement(key: "MobileUserId", value: "$userId"),
      XMLElement(key: "DateFrom", value: BaseDates(fromDate).dbformat),
      XMLElement(key: "DateTo", value: BaseDates(toDate).dbformat),
      XMLElement(key: "Start", value: "$start"),
      XMLElement(key: "Limit", value: "15"),
      XMLElement(key: "Flag", value: "$flag"),
      if (transNo?.isNotEmpty ?? false)
        XMLElement(key: "TransNo", value: "%$transNo%")
    ]).buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "MobilePurchaseOrderAcknowledgementListProc",
          actionFlag: "LIST",
          subActionFlag: "PO_SUMMARY",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    // onRequestSuccess(PurchaseOrderModel.sampleData());
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List<PurchaseOrderModel> purchaseOrders =
                BaseJsonParser.goodList(result, 'resultObject')
                    .map((e) => PurchaseOrderModel.fromJson(e))
                    .toList();
            onRequestSuccess(purchaseOrders);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> getPurchaseOrderDetail(
    PurchaseOrderModel order, {
    @required ValueSetter<PODetailModel> onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
  }) async {
    String service = "getdata";

    String xml = XMLBuilder(tag: "List", elements: [
      XMLElement(key: "Id", value: '${order.id}'),
      XMLElement(key: "TableId", value: "${order.tableId}")
    ]).buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "MobilePurchaseOrderAcknowledgementListProc",
          actionFlag: "LIST",
          subActionFlag: "PO_DETAIL",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List<PODetailModel> purchaseOrders =
                BaseJsonParser.goodList(result, 'resultObject')
                    .map((e) => PODetailModel.fromJson(e))
                    .toList();
            onRequestSuccess(purchaseOrders?.first);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> saveAcknowledgement({
    List<POVehicleModel> vehicles,
    PODetailModel poDetails,
    int optionId,
    String remarks,
    int supplierId,
    @required VoidCallback onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
  }) async {
    String service = "getdata";
    int userId = supplierId;
    int defaultUserId = await getUserId();
    String xml = "";

    xml += XMLBuilder(tag: "HDR", elements: [
      XMLElement(key: "OptionId", value: "$optionId"),
      XMLElement(key: "MobileUserId", value: "$userId"),
      XMLElement(key: "UserId", value: "$defaultUserId"),
      XMLElement(key: "RefTableId", value: "${poDetails.tableId}"),
      XMLElement(key: "RefTableDataId", value: "${poDetails.id}"),
      XMLElement(key: "Remarks", value: "$remarks"),
    ]).buildElement();

    for (int i = 0; i < vehicles.length; i++) {
      final vehicle = vehicles[i];
      xml += XMLBuilder(tag: "DTL", elements: [
        XMLElement(key: "RowNo", value: '${i + 1}'),
        XMLElement(key: "Remarks", value: "${vehicle.description}"),
        XMLElement(key: "VehicleNo", value: "${vehicle.vehicleNo}"),
      ]).buildElement();
    }
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "MobilePurchaseOrderAcknowledgementSaveProc",
          actionFlag: "SAVE",
          subActionFlag: "NEW",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject') &&
              (result['resultObject'] as List).isNotEmpty) {
            if ((result['resultObject'][0]['outputvalue'] as String)
                .containsIgnoreCase('SUCCESS')) {
              onRequestSuccess();
            }
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> editAcknowledgement({
    List<POVehicleModel> vehicles,
    PODetailModel poDetails,
    int optionId,
    String remarks,
    @required VoidCallback onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
  }) async {
    //     <HDR Id = "20" TableId = "1321" OptionId = "617" UserId = "666"></HDR>
    // <DTL RowNo = "1" Id = "34" TableId = "1319" VehicleNo = "VCH0011" Remarks = "Test A"></DTL>
    // <DTL RowNo = "2" Id = "35" TableId = "1319" VehicleNo = "VCH002" Remarks = "Test B"></DTL>
    // <DTL RowNo = "3" Id = "36" TableId = "1319" VehicleNo = "VCH003" Remarks = "Test C"></DTL>
    // <DTL RowNo = "4" Id = "0" TableId = "1319" VehicleNo = "VCH004" Remarks = "Test D"></DTL>

    String service = "getdata";
    int defaultUserId = await getUserId();
    String xml = "";
    xml += XMLBuilder(tag: "HDR", elements: [
      XMLElement(key: "Id", value: "${poDetails.ackHdrId}"),
      XMLElement(key: "TableId", value: "${poDetails.ackHdrTableId}"),
      XMLElement(key: "OptionId", value: "$optionId"),
      XMLElement(key: "UserId", value: "$defaultUserId"),
      XMLElement(key: "Remarks", value: "$remarks"),
    ]).buildElement();
    for (int i = 0; i < vehicles.length; i++) {
      final vehicle = vehicles[i];
      xml += XMLBuilder(tag: "DTL", elements: [
        XMLElement(key: "RowNo", value: '${i + 1}'),
        XMLElement(key: "Id", value: "${vehicle.id ?? 0}"),
        XMLElement(key: "TableId", value: "${vehicle.tableId ?? 0}"),
        XMLElement(key: "Remarks", value: "${vehicle.description}"),
        XMLElement(key: "VehicleNo", value: "${vehicle.vehicleNo}"),
      ]).buildElement();
    }
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "MobilePurchaseOrderAcknowledgementSaveProc",
          actionFlag: "SAVE",
          subActionFlag: "EDIT",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject') &&
              (result['resultObject'] as List).isNotEmpty) {
            if ((result['resultObject'][0]['outputvalue'] as String)
                .containsIgnoreCase('SUCCESS')) {
              onRequestSuccess();
            }
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> deleteAcknowledgement({
    PODetailModel poDetails,
    @required VoidCallback onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
    int optionId,
  }) async {
//SELECT * FROM MobilePurchaseOrderAcknowledgementSaveProc('SAVE','DELETE','<DATA>
// <HDR Id = "20" TableId = "1321"  UserId = "666"></HDR>

    String service = "getdata";
    int defaultUserId = await getUserId();

    String xml = XMLBuilder(tag: "HDR", elements: [
      XMLElement(key: "Id", value: '${poDetails.ackHdrId}'),
      XMLElement(key: "TableId", value: "${poDetails.ackHdrTableId}"),
      XMLElement(key: "UserId", value: "$defaultUserId"),
    ]).buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "MobilePurchaseOrderAcknowledgementSaveProc",
          actionFlag: "SAVE",
          subActionFlag: "DELETE",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject') &&
              (result['resultObject'] as List).isNotEmpty) {
            if ((result['resultObject'][0]['outputvalue'] as String)
                .containsIgnoreCase('SUCCESS')) {
              onRequestSuccess();
            }
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }
}

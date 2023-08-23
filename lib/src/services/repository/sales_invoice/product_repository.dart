// import 'dart:convert';
//
// import 'package:base/constants.dart';
// import 'package:base/services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
//
// import '../../../../utility.dart';
//
// class ProductsRepository extends BaseRepository {
//   static final ProductsRepository _instance = ProductsRepository._();
//
//   ProductsRepository._();
//
//   factory ProductsRepository() => _instance;
//
//   Future<void> getProductList({
//     @required
//         int optionId,
//     String name,
//     String code,
//     int start = 0,
//     int sor_Id,
//     int eor_Id,
//     int totalRecords,
//     int value = 0,
//     @required
//         Function(
//       List<ProductModel> products, {
//       int sorId,
//       int eorId,
//       int limit,
//       int totalRecords,
//     })
//             onRequestSuccess,
//     @required
//         Function(AppException) onRequestFailure,
//   }) async {
//     int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
//     int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
//
//     String date = BaseDates(DateTime.now()).dbformat;
//     int limit = 10;
//     List params = [
//       if (name?.isNotEmpty ?? false)
//         {
//           "column": "Name",
//           "value": "%$name%",
//           "datatype": "STR",
//           "restriction": "EQU",
//           "sortorder": null
//         },
//       if (code?.isNotEmpty ?? false)
//         {
//           "column": "Code",
//           "value": "%$code%",
//           "datatype": "STR",
//           "restriction": "EQU",
//           "sortorder": null
//         },
//       if (optionId != null)
//         {
//           "column": "OptionId",
//           "value": "$optionId",
//           "datatype": "STR",
//           "restriction": "EQU",
//           "sortorder": null
//         }
//     ];
//
//     var ddpObjects = {
//       "flag": "ALL",
//       "start": start ?? 0,
//       "limit": "$limit",
//       "value": value,
//       "params": params,
//       "colName": "id",
//       "dropDownParams": [
//         {
//           "list": "ITEM-LOOKUP",
//           "procName": "mobileitemmstproc",
//           "key": "resultObject",
//           "actionFlag": "LIST",
//           "subActionFlag": "ITEM"
//         }
//       ]
//     };
//     if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
//     if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
//     if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;
//
//     String url = "/inventory/controller/cmn/getdropdownlist";
//
//     String service = "getdata";
//     ProductsModel responseJson;
//     performRequest(
//         service: service,
//         jsonArr: [json.encode(ddpObjects)],
//         url: url,
//         onRequestFailure: onRequestFailure,
//         onRequestSuccess: (result) => {
//               responseJson = ProductsModel.fromJson(result),
//               if (responseJson.statusCode == 1 &&
//                   result.containsKey("resultObject"))
//                 {
//                   onRequestSuccess(
//                     responseJson.lookupItems,
//                     totalRecords: responseJson.totalRecords,
//                     sorId: responseJson.SOR_Id,
//                     eorId: responseJson.EOR_Id,
//                     limit: limit,
//                   )
//                 }
//               else
//                 onRequestFailure(
//                     InvalidInputException(responseJson.statusMessage))
//             });
//   }
//
//   Future<void> getProductDetails(
//     int itemId, {
//     @required Function(ProductDetailModel) onRequestSuccess,
//     @required Function(AppException) onRequestFailure,
//   }) async {
//     int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
//
//     int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
//
//     String itemXml = XMLBuilder(tag: "List")
//         .addElement(key: "ItemId", value: '$itemId')
//         .addElement(key: "UserId", value: '$userId')
//         .buildElement();
//
//     List jssArr = DropDownParams()
//         .addParams(
//             list: "EXEC-PROC",
//             key: "resultObject",
//             procName: "mobileitemmstproc",
//             actionFlag: "LIST",
//             subActionFlag: "ITEM_DTL",
//             xmlStr: itemXml)
//         .callReq();
//
//     String url = "/security/controller/cmn/getdropdownlist";
//     String service = "getdata";
//     performRequest(
//         service: service,
//         jsonArr: jssArr,
//         url: url,
//         onRequestFailure: onRequestFailure,
//         onRequestSuccess: (result) {
//           ProductDetailResponseModel responseJson;
//           responseJson = ProductDetailResponseModel.fromJson(result);
//           if (responseJson.statusCode == 1 &&
//               result.containsKey("resultObject"))
//             onRequestSuccess(responseJson.detail);
//           else
//             onRequestFailure(InvalidInputException(responseJson.statusMessage));
//         });
//   }
// }

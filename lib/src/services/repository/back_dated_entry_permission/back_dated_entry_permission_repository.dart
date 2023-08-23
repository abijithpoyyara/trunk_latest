import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';
import 'package:redstars/utility.dart';

class BackDatedEntryRepository extends BaseRepository {
  static final BackDatedEntryRepository _instance =
      BackDatedEntryRepository._();

  BackDatedEntryRepository._();

  factory BackDatedEntryRepository() => _instance;

  getOptions({
    @required Function(AddOptionModel optionsList) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    var ddpObjects = {
      "flag": "ALL",
      "SOR_Id": 0,
      "EOR_Id": 1000,
      "TotalRecords": 1000,
      "start": 0,
      "limit": 1000,
      "value": 0,
      "colName": "id",
      "params": [
        {
          "column": "MobileYN",
          "value": "N",
        }
      ],
      "dropDownParams": [
        {
          "list": "LOCATION_MULTI_SEL",
          "procName": "OptionMstListProc",
          "key": "resultObject",
          "actionFlag": "DROPDOWN",
          "subActionFlag": "",
        }
      ]
    };

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          AddOptionModel responseJson = AddOptionModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getBacDateViewDtlList(
      {@required int start,
      BackDateFilterModel backDateFilterModel,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      @required Function(List<BackDateViewDetails> viewList) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": 0,
      "colName": "Id",
      "SOR_Id": sor_Id,
      "EOR_Id": eor_Id,
      "TotalRecords": totalRecords,
      "params": [
        {
          "column": "Active",
          "value":
              "${(backDateFilterModel?.isActive ?? false) == false ? "N" : "Y"}"
        },
        if (backDateFilterModel.isActive == false)
          {
            "column": "Periodfrom",
            "value": "${BaseDates(backDateFilterModel.periodFrom).dbformat}"
          },
        if (backDateFilterModel.isActive == false)
          {
            "column": "Periodto",
            "value": "${BaseDates(backDateFilterModel.periodTo).dbformat}"
          },
        if (backDateFilterModel?.option != null)
          {
            "column": "OptionId",
            "value": "${backDateFilterModel.option.id}",
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (backDateFilterModel?.branch != null)
          {
            "column": "BranchId",
            "value": "${backDateFilterModel.branch.id}",
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (backDateFilterModel?.transNo != null &&
            backDateFilterModel.transNo.isNotEmpty)
          {
            "column": "TransNum",
            "value": "%${backDateFilterModel.transNo}%",
            "datatype": "STR",
            "restriction": "LIKE",
            "sortorder": null
          }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/security/controller/def/getbackdatedpermissiondetails";

    BackDateViewDetailsModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BackDateViewDetailsModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.viewList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getBackDateViewDetail(
      {BackDateViewDetails dtl,
      @required Function(BackDateEntryDetailModel model) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    var ddpObjects = {
      "flag": "EQU",
      "start": 0,
      "limit": "10",
      "value": 0,
      "colName": "Id",
      "SOR_Id": dtl.start,
      "EOR_Id": dtl.Id,
      "TotalRecords": dtl.totalrecords,
      "params": [
        {"column": "Active", "value": "Y"},
        {"column": "TransNo", "value": dtl.transno},
      ]
    };
    String url = "/security/controller/def/getbackdatedpermissiondetails";
    String service = "getdata";

    BackDateEntryDetailModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BackDateEntryDetailModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getBranch({
    @required Function(AddBranchModel branchList) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    var ddpObjects = {
      "flag": "ALL",
      "SOR_Id": 0,
      "EOR_Id": 1000,
      "TotalRecords": 1000,
      "start": 0,
      "limit": 1000,
      "value": 0,
      "colName": "id",
      "params": [
        {
          "column": "OptionId",
          "value": 92,
        }
      ],
      "dropDownParams": [
        {
          "list": "LOCATION_MULTI_SEL",
          "procName": "BackDatedEntryListproc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "BRANCH",
        }
      ]
    };

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          AddBranchModel responseJson = AddBranchModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getUserList({
    int branchId,
    int optionId,
    @required Function(AddUserListModel userList) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    var ddpObjects = {
      "flag": "ALL",
      "SOR_Id": 0,
      "EOR_Id": 1000,
      "TotalRecords": 1000,
      "start": 0,
      "limit": 1000,
      "value": 0,
      "colName": "name",
      "params": [
        {
          "column": "BranchId",
          "value": branchId,
        },
        {
          "column": "OptionId",
          "value": optionId,
        }
      ],
      "dropDownParams": [
        {
          "list": "LOCATION_MULTI_SEL",
          "procName": "BackDatedEntryListproc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "USER",
        }
      ]
    };

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          AddUserListModel responseJson = AddUserListModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  saveFunction({
    BackDatedEntryViewModel viewModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validTo,
    BackDateEntryDetailModel detail,
    @required Function() onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    Map<String, dynamic> dtlList = Map<String, dynamic>();
    Map<String, dynamic> userList = Map<String, dynamic>();
    List<SanctionedOptionsModel> list = viewModel.sanctionedList;

    var jsdataList = viewModel.backDatedEntrySanctionedData.map((item) {
      return {
        "Id": viewModel.isEdited == 0 || item.isNewItem == true
            ? 0
            : item?.updatedId ?? 0,
        "optionid": viewModel.optionId,
        "periodfrom": BaseDates(periodFrom).dbformat,
        "periodto": BaseDates(periodTo).dbformat,
        "refoptionid": item.optionName.id,
        "branchid": item.branchName.id,
        "userlist": item.userList
            .map((e) => {
                  "id": e.id ?? e.userid,
                })
            .toList(),
        "validupto": BaseDates(validTo).dbformat,
        "recordstatus": "A",
      };
    }).toList();

    jsonArr = {
      "transNum": viewModel.isEdited == 0 ? "" : detail.viewList.first.transno,
      "optionid": viewModel.optionId,
      "detailList": jsdataList,
      "extensionDataObj": [],
      "screenNoteDataObj": [],
      "screenFieldDataApprovalInfoObj": [],
      "docAttachReqYN": false,
      "docAttachXml": "",
      "checkListDataObj": [],
    };

    String service = "putdata";
    String url = "/security/controller/def/savebackdatedentry";
    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jssArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        uuid: 0,
        userid: 0,
        chkflag: "N",
        compressdyn: false,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusMessage.contains("Success") &&
                  responseJson.result)
                onRequestSuccess()
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  editSaveFunction({
    BackDatedEntryViewModel viewModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validTo,
    @required Function() onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    Map<String, dynamic> dtlList = Map<String, dynamic>();
    Map<String, dynamic> userList = Map<String, dynamic>();
    List<BackDateEntryDetailList> list = viewModel.dtlModel.viewList;
    List list2 = [];
    List userList2 = [];
    String periodFromString = periodFrom.toString().substring(0, 10);
    String periodToString = periodTo.toString().substring(0, 10);
    String validToString = validTo.toString().substring(0, 10);
    int branchID;
    int optionId;

    var jsdataList = list.map((item) {
      return {
        "Id": item?.Id ?? 0,
        "optionid": viewModel.optionId,
        "periodfrom": periodFromString,
        "periodto": periodToString,
        "refoptionid": viewModel.optionList.addOptionList
            .firstWhere((element) => element.optionname == item.optionname)
            .id,
        "branchid": viewModel.branchList.addBranchList
            .firstWhere((element) => element.name == item.branchname)
            .id,
        "userlist": item.userList
            .map((e) => {
                  "id": e?.id ?? 0,
                })
            .toList(),
        "validupto": validToString,
        "recordstatus": "A",
      };
    }).toList();

    jsonArr = {
      "transNum": viewModel.dtlModel.viewList.first.transno,
      "optionid": viewModel.optionId,
      "detailList": jsdataList,
      "extensionDataObj": [],
      "screenNoteDataObj": [],
      "screenFieldDataApprovalInfoObj": [],
      "docAttachReqYN": false,
      "docAttachXml": "",
      "checkListDataObj": [],
    };

    String service = "putdata";
    String url = "/security/controller/def/savebackdatedentry";
    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jssArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        uuid: 0,
        userid: 0,
        chkflag: "N",
        compressdyn: false,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusMessage.contains("Success") &&
                  responseJson.result)
                onRequestSuccess()
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}

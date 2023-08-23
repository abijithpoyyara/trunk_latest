import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/src/services/helpers/_post_request_helper.dart';
import 'package:base/src/services/helpers/http_request_helper.dart';
import 'package:base/src/services/model/response/client_info.dart';
import 'package:base/src/services/model/response/live_client_details.dart';
import 'package:base/src/utils/base_firebase.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

class BaseUserRepository extends BaseRepository {
  Future<ClientInfo> getClientIfo() async {
    final jsonArr = {
      "url": Connections().applicationName,
      "apptype": BaseConstants.APPTYPE,
//      "versionno": Settings.getVersion(),
//      "version": "mobile"
    };
    final url = "/security/controller/cmn/login";

    String service = "getclientsinfo";
    ClientInfo responseJson;

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = [json.encode(jsonArr)];
    logParams["urlString"] = url;
    try {
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: (exe) {
            responseJson = null;
          },
          onRequestSuccess: (result) {
            responseJson = ClientInfo.fromJson(result);
            if (responseJson.statusCode != 1) responseJson = null;
          });

      await PostServiceHelper(httpRequest: httpRequest).postRequest();
    } catch (e) {
      {
        responseJson = null;
        print(e.toString());
      }
    }
    return responseJson;
  }

  void getNotificationCountFromDb(
      {List<LoginModel> loginModel,
      @required
          Function(List<NotificationCountFromDbList> liveClientDetails)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getclientsinfo";
    String xmlUser;
    List<String> finalXml = [];
    String xmlFlag = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "COMPANY_WISE")
        .buildElement();

      for (int i = 0; i < loginModel.length; i++) {
      xmlUser = XMLBuilder(tag: "User")
          .addElement(key: "Clientid", value: "${loginModel[i].clientId}")
          .addElement(key: "UserId ", value: "${loginModel[i].userId}")
          .buildElement();
      finalXml.add(xmlUser);
    }
    var uniqueList=  finalXml.toSet().toList();
      print(uniqueList);
    var jsonArr = {"xml": "<DATA>" + xmlFlag + uniqueList.toString() + "</DATA>"};

    String url = "/security/controller/cmn/getnotificationCountFromDb";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = [json.encode(jsonArr)];
    logParams["urlString"] = url;
    try {
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: onRequestFailure,
          onRequestSuccess: (result) {
            NotificationCountFromDbModel responseJson =
                NotificationCountFromDbModel.fromJson(result);
            if (responseJson.statusCode == 1)
              onRequestSuccess(responseJson.notificationCountFromDbList);
            else
              onRequestFailure(
                  InvalidInputException(responseJson.statusMessage));
          });

      PostServiceHelper(httpRequest: httpRequest).postRequest();
    } catch (e) {
      {
        onRequestFailure(InvalidInputException(e.toString()));
        print(e.toString());
      }
    }
  }



  void getNotificationCountOfBranch(
      {List<LoginModel> loginModel,
      @required
          Function(List<NotificationCountDetails> liveClientDetails)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getclientsinfo";
    String xmlUser;
    List<String> finalXml = [];
    String xmlFlag = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "BRANCH_WISE")
        .buildElement();

    for (int i = 0; i < loginModel.length; i++) {
      xmlUser = XMLBuilder(tag: "User")
          .addElement(key: "Clientid", value: "${loginModel[i].clientId}")
          .addElement(key: "UserId ", value: "${loginModel[i].userId}")
          .buildElement();
      finalXml.add(xmlUser);
    }
    var jsonArr = {"xml": "<DATA>" + xmlFlag + finalXml.toString() + "</DATA>"};

    String url = "/security/controller/cmn/getnotificationCountFromDb";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = [json.encode(jsonArr)];
    logParams["urlString"] = url;


//     List jssArr = DropDownParams()
//         .addParams(
//         list: "EXEC-PROC",
//         key: "resultObject",
//         xmlStr: xmlFlag + finalXml.toString() ,
//         procName: "MobileNotificationProc",
//         actionFlag: "NOTIFICATION_COUNT",
//         subActionFlag: "")
//         .callReq();
//     performRequest(
    //     service: service,
//         jsonArr: logParams["jsonArr"],
//         url: url,
    //     onRequestFailure: onRequestFailure,
    //     onRequestSuccess: (result) {
    //       NotificationCountDetailsModel responseJson =
    //       NotificationCountDetailsModel.fromJson(result);
    //       if (responseJson.statusCode==1)
    //         onRequestSuccess(responseJson.notificationCount);
    //       else
//             onRequestFailure(InvalidInputException(responseJson.statusMessage));
    //     });
    try {
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: onRequestFailure,
          onRequestSuccess: (result) {
            NotificationCountDetailsModel responseJson =
            NotificationCountDetailsModel.fromJson(result);
            if (responseJson.statusCode == 1)
              onRequestSuccess(responseJson.notificationCount);
            else
              onRequestFailure(
                  InvalidInputException(responseJson.statusMessage));
          });

      PostServiceHelper(httpRequest: httpRequest).postRequest();
    } catch (e) {
      {
        onRequestFailure(InvalidInputException(e.toString()));
        print(e.toString());
      }
    }
  }

  void getNotificationCount(
      {@required
          int userId,
      @required
          String clientId,
      @required
          Function(List<NotificationCountDetails> notificaFtionDtls)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String clientId1 = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId1 = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String service = "getdata";
    String xmlList = "";
    String xmlremovedLasttag1 = "";
    String xml1 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "MANAGE_OPTION_WISE")
        .buildElement(appendFlag: false);
    String xml2 = XMLBuilder(tag: "User")
        .addElement(key: "Clientid ", value: "$clientId1")
        .addElement(key: "UserId ", value: "${userId ?? userId1}")
        .addElement(key: "BranchId ", value: "${branchId ?? 1}")
        .buildElement(appendFlag: false);
    xmlList = xml2.replaceAll("> </User>", "/>");
    xmlremovedLasttag1 = xml1.replaceAll("> </List>", "/>");
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlremovedLasttag1 + xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "NOTIFICATION_COUNT",
            subActionFlag: "")
        .callReq();
    String url = "/security/controller/cmn/getdropdownlist";
    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationCountDetailsModel responseJson =
              NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.notificationCount);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }


  void getBusinessLevels(
      {@required String username,
      @required String password,
      @required String clientId,
      @required Function(ClientDetails) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String service = "getclientsinfo";

    var jsonArr = {
      "ClientId": clientId,
      "UserName": username,
      "Password": password,
      "Version": "mobile",
    "RequestFrom": "Mobile"
    };

    String url = "/security/controller/cmn/getloginparams";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = [json.encode(jsonArr)];
    logParams["urlString"] = url;
    try {
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: onRequestFailure,
          onRequestSuccess: (result) {
            ClientDetails responseJson = ClientDetails.fromJson(result);
            if (responseJson.statusCode == 1){
              subscribeForNotifications(responseJson.branches.notificationTopics);
              onRequestSuccess(responseJson);
            }

            else
              onRequestFailure(
                  InvalidInputException(responseJson.statusMessage));
          });

      PostServiceHelper(httpRequest: httpRequest).postRequest();
    } catch (e) {
      {
        onRequestFailure(InvalidInputException(e.toString()));
        print(e.toString());
      }
    }
  }

  void getLiveClientDetails(
      {@required
          Function(List<LiveClientDetails> liveClientDetails) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getclientsinfo";

    var jsonArr = {};

    String url = "/security/controller/cmn/getliveclients";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = [json.encode(jsonArr)];
    logParams["urlString"] = url;
    try {
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: onRequestFailure,
          onRequestSuccess: (result) {
            LiveClientDetailsModel responseJson =
                LiveClientDetailsModel.fromJson(result);
            if (responseJson.statusCode == 1)
              onRequestSuccess(responseJson.clientDetailsList);
            else
              onRequestFailure(
                  InvalidInputException(responseJson.statusMessage));
          });

      PostServiceHelper(httpRequest: httpRequest).postRequest();
    } catch (e) {
      {
        onRequestFailure(InvalidInputException(e.toString()));
        print(e.toString());
      }
    }
  }

  void login(LoginModel login,
      {@required Function(User user) onLoginSuccess,
      @required Function(AppException exception) onLoginFailure}) async {
    LoginPost body = LoginPost(
        username: login.userName,
        password: login.password,
        clientId: login.clientId,
        apptype: BaseConstants.APPTYPE,
        loginBusinessLevels: LoginParams(
          branch: login.branch,
          company: login.company,
          location: login.location,
        ));

    String service = "authenticate";
    Map<String, dynamic> logParams = Map();
    logParams["logparams"] = body.callReq();
    print(logParams);

    try {
      LoginResponse responseJson;
      User user;
      String NetworkException;
      HttpRequestHelper httpRequest = HttpRequestHelper(
          service: service,
          requestParams: logParams,
          onRequestFailure: (exception) async => {
            NetworkException = exception.toString(),
            if(!(NetworkException.contains("No Internet")))
                await BasePrefs.setString(BaseConstants.TOKEN, "login failed"),
                onLoginFailure(exception)
              },
          onRequestSuccess: (result) async {
            responseJson = LoginResponse.fromJson(result);
            if (responseJson.statusCode != 0 &&
                result.containsKey("resultObject")) {
              user = await saveUserDetails(
                  responseJson, login.userName, login.password, login.clientId);
              onLoginSuccess(user);
            } else {
              await BasePrefs.setString(BaseConstants.TOKEN, "login failed");
              onLoginFailure(InvalidInputException(responseJson.statusMessage));
            }
          });

      PostServiceHelper(httpRequest: httpRequest).authenticateRequest();
    } catch (e) {
      {
        await BasePrefs.setString(BaseConstants.TOKEN, "login failed");
        onLoginFailure(FetchDataException());
        print(e.toString());
      }
    }
  }

  Future<User> saveUserDetails(LoginResponse response, String username,
      String password, String clientId) async {
    List<LoginModules> loginModules = response.modules;

    List<ModuleListModel> moduleList = List();
    List<BusinessLevelModel> businessLevelModel;
    loginModules?.forEach((module) async {
      if (module.listtype == "ModuleList")
        moduleList = await saveModuleLevelData(module.moduleListModel);
      if (module.listtype == "BusinessLevelList") {
        businessLevelModel = module.businessLevelModel;
        saveBusinessLevelData(module.businessLevelModel);
      }
      if (module.listtype == "CompanyConstants")
        saveCompanyData(module.companyConstants);
      if (module.listtype == "DashboardTileRights")
        await saveDashboardData(module.dashBoardTileRights);
    });

    await BasePrefs.setString(BaseConstants.SSNIDN_KEY, response.ssnidn.ssnId);
    await BasePrefs.setString(BaseConstants.USERNAME_KEY, username);
    await BasePrefs.setString(BaseConstants.PASSWORD_KEY, password);
    await BasePrefs.setString(BaseConstants.CLIENTID_KEY, clientId);
    await BasePrefs.setString("notifCompany", clientId);
    await BasePrefs.setString(BaseConstants.TOKEN, "login success");

    String userName = await BasePrefs.getString(BaseConstants.USER_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String companyName =
        await BasePrefs.getString(BaseConstants.COMPANY_NAME_KEY);
    String branchName =
        await BasePrefs.getString(BaseConstants.BRANCH_NAME_KEY);
    String locationName =
        await BasePrefs.getString(BaseConstants.LOCATION_NAME_KEY);
    print(businessLevelModel.length);

    return User(
        userId: userId,
        userName: userName,
        companyName: companyName,
        companyLocation: branchName,
        locationName: locationName,
        // businessLevelModel: businessLevelModel,
        moduleList: moduleList);
  }

  Future<List<ModuleListModel>> saveModuleLevelData(
      List<ModuleListModel> modulesData) async {
    var transactionUnblockReqOptionCode;
    modulesData.forEach((data) async => {
          await BasePrefs.setInt(data.src, data.optionId),
          if (data.optiondescription == "Transaction Unblock Request Approval")
            {
              transactionUnblockReqOptionCode = data.src,
              await BasePrefs.setString(
                  BaseConstants.TRANS_UNBLOCK_REQ_OPTIONCODE,
                  transactionUnblockReqOptionCode)
            }
        });
    return modulesData;
  }

  saveDashboardData(List<DashboardTileRights> dashboardData) async {
    var obj = [];
    dashboardData.forEach((data) {
      if (data.allow) obj.add(json.encode(data.toMap()));
    });
    await BasePrefs.setJson(BaseConstants.DASHBOARD_RIGHTS_KEY, obj);
    return null;
  }

  void saveBusinessLevelData(List<BusinessLevelModel> businessData) {
    businessData.forEach((data) async {
      var levelMap = {
        "LevelId": data.levelid,
        "LevelCode": "${data.levelcode}",
        "LevelValue": "${data.levelvalue}"
      };
      if (data.levelcode == "L1") {
        await BasePrefs.setString(
            BaseConstants.COMPANY_NAME_KEY, data.businesslocationname);
        await BasePrefs.setInt(BaseConstants.COMPANY_ID_KEY, data.levelvalue);
        await BasePrefs.setMap(BaseConstants.COMPANY_KEY, levelMap);
      }
      if (data.levelcode == "L2") {
        await BasePrefs.setString(
            BaseConstants.BRANCH_NAME_KEY, data.businesslocationname);
        await BasePrefs.setInt(BaseConstants.BRANCH_ID_KEY, data.levelvalue);
        await BasePrefs.setMap(BaseConstants.BRANCH_KEY, levelMap);
        await BasePrefs.setInt(
            BaseConstants.BRANCH_LEVEL_CODE_ID, data.levelid);
        await BasePrefs.setInt(BaseConstants.BRANCH_TABLEID, data.reftableid);
        await BasePrefs.setString(
            BaseConstants.BRANCH_LEVEL_CODE, data.levelcode);
      }
      if (data.levelcode == "L3") {
        await BasePrefs.setString(
            BaseConstants.LOCATION_NAME_KEY, data.businesslocationname);
        await BasePrefs.setMap(BaseConstants.LOCATION_KEY, levelMap);
        await BasePrefs.setInt(BaseConstants.LOCATION_ID_KEY, data.levelvalue);
      }
    });
  }

  Future<void> saveCompanyData(List<CompanyConstants> companyData) async {
    if (companyData != null && companyData.isNotEmpty) {
      CompanyConstants company = companyData.first;
      await BasePrefs.setInt(BaseConstants.USERID_KEY, company.userid);
      await BasePrefs.setInt(BaseConstants.FIN_YEAR_KEY, company.finyearid);
      await BasePrefs.setString(BaseConstants.USER_KEY, company.username);
      await BasePrefs.setBool(
          BaseConstants.SUPER_USER_KEY, company.isSuperUser);
      await BasePrefs.setInt(BaseConstants.COMPANY_BASE_CURRENCY_ID,
          company.companybasecurrencyid);
      await BasePrefs.setInt(
          BaseConstants.BRANCH_CURRENCY_ID, company.branchcurrencyid);
      await BasePrefs?.setString(
          BaseConstants.FILE_UPLOAD_PATH_KEY, company.attchmentupdpath);
      await BasePrefs?.setString(BaseConstants.FILE_DS_ATTACHMENT_TEMP_PATH_KEY,
          company.dsattchmenttempupdpath);
      await BasePrefs?.setString(
          BaseConstants.FILE_DOWNLOAD_PATH_KEY, company.attchmentdwdpath);
      await BasePrefs?.setString(BaseConstants.FILE_DS_ATTACHMENT_PATH_KEY,
          company.dsattchmentupdpath);
      await BasePrefs?.setString(
          BaseConstants.FILE_DS_ATTACHMENT_DOWNLOAD_PATH_KEY,
          company.dsattchmentdwdpath);
      await BasePrefs.setInt(
          BaseConstants.USER_DEPARTMENT_ID, company?.userdepartmentid);
    }
  }

  Future<void> subscribeForNotifications(
      List<String> notificationTopics) async {
    FirebaseNotificationHelper _firebaseNotificationHelper =
        FirebaseNotificationHelper();

    List<String> subscribedTopics =
        await _firebaseNotificationHelper.getSubscribedTopics();

//    List<String> topicsToUnsubscribe = subscribedTopics
//        .where((topic) => !notificationTopics.contains(topic))
//        .toList();

    await _firebaseNotificationHelper.subscribeTopics(notificationTopics);
    print("Subscribed to topics");
//    _firebaseNotificationHelper.unsubscribeTopics(topicsToUnsubscribe);
//         print("Unsubscribed to topics $topicsToUnsubscribe");

  }
}

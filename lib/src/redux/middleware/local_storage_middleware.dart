import 'dart:convert';

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_summary_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  final SharedPreferences preferences;

  LocalStorageMiddleware(this.preferences);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);
    if (action is CheckTokenAction) {
      var token = preferences.getString(TOKEN);
      var autoLogin = preferences.getString("AutoLogin");
      print("autosplash---------$autoLogin");
      if (token != null && token.contains("success") && autoLogin !="") {
        String userName = preferences.getString(USERNAME_KEY);
        String password = preferences.getString(PASSWORD_KEY);
        String clientId = preferences.getString(CLIENTID_KEY);
        String companyString = preferences.getString(BaseConstants.COMPANY_KEY);
        String branchString = preferences.getString(BaseConstants.BRANCH_KEY);
        String locationString =
            preferences.getString(BaseConstants.LOCATION_KEY);
       Map<String, dynamic> company =
           companyString?.isEmpty ?? true ? null : json.decode(companyString);
       Map<String, dynamic> branch =
           branchString?.isEmpty ?? true ? null : json.decode(branchString);
       Map<String, dynamic> location = locationString?.isEmpty ?? true
           ? null
           : json.decode(locationString);

        action.hasTokenCallback(LoginModel(
            userName: userName,
            password: password,
            clientId: clientId,
           company: ClientLevelDetails.fromMap(company),
           branch: ClientLevelDetails.fromMap(branch),
           location: ClientLevelDetails.fromMap(location)
        ));
      } else {
        action.noTokenCallback();
      }
    }
    if (action is InitFilePathAction) {
      String path = preferences.getString(FILE_DOWNLOAD_PATH_KEY);
      action.hasTokenCallback(path);
    }

    if (action is DAInitAction) {
      bool isSuperUser = preferences.getBool(BaseConstants.SUPER_USER_KEY);
      isSuperUser ? action.isSuperUser() : action.isStandardUser();
    }
  }
}

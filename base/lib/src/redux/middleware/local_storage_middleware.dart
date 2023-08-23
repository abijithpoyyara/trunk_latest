import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/src/widgets/screens/splash/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base Middleware that handles storage related Actions

class LocalStorageMiddleware extends MiddlewareClass<BaseAppState> {
  final SharedPreferences preferences;
  LocalStorageMiddleware(this.preferences);

  @override
  void call(Store<BaseAppState> store, dynamic action, NextDispatcher next) {
    next(action);
    if (action is CheckTokenAction) {
      var token = preferences.getString(BaseConstants.TOKEN);
      var autoLogin = preferences.getString("AutoLogin");
      if (token != null && token.contains("success") && autoLogin !="false") {
        String userName = preferences.getString(BaseConstants.USERNAME_KEY);
        String password = preferences.getString(BaseConstants.PASSWORD_KEY);
        String clientId = preferences.getString(BaseConstants.CLIENTID_KEY);
        String companyString = preferences.getString(BaseConstants.COMPANY_KEY);
        String branchString = preferences.getString(BaseConstants.BRANCH_KEY);
        String locationString =
            preferences.getString(BaseConstants.LOCATION_KEY);
        Map<String, dynamic> company =
            companyString.isEmpty ? null : json.decode(companyString);
        Map<String, dynamic> branch =
            branchString.isEmpty ? null : json.decode(branchString);
        Map<String, dynamic> location =
            locationString.isEmpty ? null : json.decode(locationString);

        action.hasTokenCallback(LoginModel(
            userName: userName,
            password: password,
            clientId: clientId,
            company: ClientLevelDetails.fromMap(company),
            branch: ClientLevelDetails.fromMap(branch),
            location: ClientLevelDetails.fromMap(location)));
      } else {
        action.noTokenCallback();
      }
    }

    /// retrieve file path from [Pref] and call [InitFilePathAction.hasTokenCallback]

    if (action is InitFilePathAction) {
      String path = preferences
          .getString(BaseConstants.FILE_DOWNLOAD_PATH_KEY);
      action.hasTokenCallback(path);
    }
  }
}

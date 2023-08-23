import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';

ThunkAction signInUser(LoginModel login) {
  return authenticateUser(
      login,
      (user) => {
            Keys.navKey.currentState.pushAndRemoveUntil<void>(
                BasePageRoute.fadeIn<void>(HomePage(
                  clientId: login.clientId,
                  userId: login.userId,
                )),
                (Route<void> route) => false)
          });
}

// List<LoginModel> savedCompanyList = [];
// ThunkAction checkUser(LoginModel login) {
//   return initialAuthenticate(login, (user) async {
//     List<LoginModel> sharedPrefCompanyList;
//     final savedLoginCredentials =
//         await BasePrefs.getString(BaseConstants.COMPANY_LIST);
//     if (savedLoginCredentials.isNotEmpty && savedLoginCredentials != '[]') {
//       List<LoginModel> sharedPrefCompanyList =
//           LoginModel.decode(savedLoginCredentials);
//       print("Credential ---${sharedPrefCompanyList.length}");
//     } else {
//       savedCompanyList = sharedPrefCompanyList;
//     }
//     // final String encodedData = LoginModel.encode(savedCompanyList);
//     // BasePrefs.setString('CompanyList', encodedData);
//     Keys.navKey.currentState.pushAndRemoveUntil<void>(
//         BasePageRoute.fadeIn<void>(SavedCompanyListPage(
//           data: sharedPrefCompanyList,
//         )),
//         (Route<void> route) => false);
//   });
// }

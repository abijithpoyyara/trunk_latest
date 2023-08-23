import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../constants.dart';
import '../../../redux.dart';
import '../../../utility.dart';

class LogoutAction {
  LogoutAction();
}

class LogInAction {
  User user;

  LogInAction({@required this.user});
}

class OptionSelectedAction {
  ModuleListModel option;

  OptionSelectedAction({@required this.option});
}

class NotificationCountAction {
  final List<NotificationCountDetails> notificationDetls;

  NotificationCountAction(this.notificationDetls);
}

class BuildMainMenuAction {
  List<MenuModel> mainMenuItems;
  List<MenuModel> menuItems;
  List<ModuleListModel> modules;

  BuildMainMenuAction({@required this.menuItems, @required this.modules}) {
    mainMenuItems = _buildMenuItems();
  }

  List<MenuModel> _buildMenuItems() {
    List<MenuModel> mainMenu = List();

    for (MenuModel menu in menuItems) {
      for (ModuleListModel module in modules)
        if (menu.publicItem || module.src == menu.rightFlag) {
          menu.module = module;
          menu.title = module.title;
          mainMenu.add(menu);
          break;
        }
    }
    return mainMenu;
  }
}

ThunkAction fetchNotificationCount({int userid, String clientid}) {
  return (Store store) async {
    new Future(() async {
      String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
      int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
// store.dispatch(//new LoadingAction(status: LoadingStatus.loading, message: "Loading"));// store.dispatch(SignInAction(loginModel));
      BaseUserRepository().getNotificationCount(
          clientId: clientid ?? clientId,
          userId: userid ?? userId,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new NotificationCountAction(response)));
    });
  };
}

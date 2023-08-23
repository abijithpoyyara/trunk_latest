import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:redstars/src/redux/states/app_state.dart';

class HomeViewModel extends BaseHomeViewModel {
  HomeViewModel(
      {User user,
      Function() onLogout,
      Function(ModuleListModel module) onOptionSelected,
      Function(List<MenuModel> allMenuItem, List<ModuleListModel> moduleList)
          buildMenuItem,
      List<NotificationCountDetails> notificationCountDtls,
      List<MenuModel> menuItems,
      bool isHasDisplayNotificationRight})
      : super(
          user: user,
          onLogout: onLogout,
          onOptionSelected: onOptionSelected,
          notificationCountDtls: notificationCountDtls,
          menuItems: menuItems,
            isHasDisplayNotificationRight: isHasDisplayNotificationRight);

  factory HomeViewModel.fromStore(Store<AppState> store) {
    bool rightFlag = false;
    store.state.homeState.user.moduleList.forEach((element) {
      if (element.context == "MOB_MON_PRO_PLAN") {
        rightFlag = true;
      }
      print(rightFlag);
      return rightFlag;
    });
    return HomeViewModel(
        user: store.state.signInState.user,
        notificationCountDtls: store.state.homeState.notificationCountDtls,
        menuItems: store.state.homeState.menuItems,
        isHasDisplayNotificationRight: rightFlag,
        buildMenuItem: (allMenuItem, modules) => store.dispatch(
            BuildMainMenuAction(menuItems: allMenuItem, modules: modules)),
        onOptionSelected: (module) =>
            store.dispatch(OptionSelectedAction(option: module)),
        onLogout: () => {
              store.dispatch(OnClearAction()),
              store.dispatch(OnLogoutAction()),
            });
  }
}

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';

import 'base_viewmodel.dart';

class BaseHomeViewModel extends BaseViewModel {
  final User user;
  final Function() onLogout;
  final Function(ModuleListModel module) onOptionSelected;
  final bool hasScanRights;
  final List<MenuModel> menuItems;
  final ModuleListModel scanOption;
  final List<NotificationCountDetails> notificationCountDtls;
  final bool isHasDisplayNotificationRight;

  BaseHomeViewModel(
      {this.user,
      this.onLogout,
      this.menuItems,
      this.onOptionSelected,
      this.notificationCountDtls,
      this.hasScanRights = false,
      this.isHasDisplayNotificationRight = false,
      this.scanOption});

  factory BaseHomeViewModel.fromStore(Store<BaseAppState> store) {
    bool rightFlag = false;
    store.state.homeState.user.moduleList.forEach((element) {
      if (element.context == "MOB_MON_PRO_PLAN") {
        rightFlag = true;
      }
      print(rightFlag);
      return rightFlag;
    });
    return BaseHomeViewModel(
        user: store.state.signInState.user,
        menuItems: store.state.homeState.menuItems,
        hasScanRights: store.state.homeState.scanOption != null,
        scanOption: store.state.homeState.scanOption,
        isHasDisplayNotificationRight: rightFlag,
        notificationCountDtls: store.state.homeState.notificationCountDtls,
        onOptionSelected: (module) =>
            store.dispatch(OptionSelectedAction(option: module)),
        onLogout: () => {
              store.dispatch(OnClearAction()),
              store.dispatch(OnLogoutAction()),
            });
  }
}

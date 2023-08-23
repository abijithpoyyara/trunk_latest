import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState extends BaseState {
  final ModuleListModel selectedOption;
  final ModuleListModel scanOption;
  final User user;
  final List<MenuModel> menuItems;
  final List<NotificationCountDetails> notificationCountDtls;

  HomeState(
      {this.user,
      this.menuItems,
      this.selectedOption,
      this.scanOption,
      this.notificationCountDtls});

  HomeState copyWith(
      {User user,
      List<MenuModel> menuItems,
      ModuleListModel scanOption,
      ModuleListModel selectedOption,
      List<NotificationCountDetails> notificationCountDtls}) {
    return HomeState(
        user: user ?? this.user,
        menuItems: menuItems ?? this.menuItems,
        scanOption: scanOption ?? this.scanOption,
        notificationCountDtls:
            notificationCountDtls ?? this.notificationCountDtls,
        selectedOption: selectedOption ?? this.selectedOption);
  }

  factory HomeState.initial() {
    return new HomeState(
        menuItems: List(),
        selectedOption: null,
        scanOption: null,
        notificationCountDtls: List(),
        user: User(
            userName: "",
            companyName: "",
            companyLocation: "",
            moduleList: List()));
  }
}

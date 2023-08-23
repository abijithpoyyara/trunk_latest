import 'package:base/redux.dart';

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, LogoutAction>(_logoutUser),
  TypedReducer<HomeState, BuildMainMenuAction>(_buildMenu),
  TypedReducer<HomeState, LogInAction>(_loginAction),
  TypedReducer<HomeState, OptionSelectedAction>(_optionSelectedAction),
  TypedReducer<HomeState, NotificationCountAction>(_NCAction)
]);

HomeState _logoutUser(HomeState state, LogoutAction action) {
  return HomeState.initial();
}

HomeState _buildMenu(HomeState state, BuildMainMenuAction action) {
  return state.copyWith(menuItems: action.mainMenuItems,);
}

HomeState _loginAction(HomeState state, LogInAction action) {
  return state.copyWith(user: action.user,);
}

HomeState _NCAction(HomeState state, NotificationCountAction action) {
  return state.copyWith(notificationCountDtls: action.notificationDetls,);
}

HomeState _optionSelectedAction(HomeState state, OptionSelectedAction action) {
  return state.copyWith(selectedOption: action.option);
}

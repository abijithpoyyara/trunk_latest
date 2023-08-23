import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';

import '../../../redux.dart';

final signinReducer = combineReducers<SignInState>([
  TypedReducer<SignInState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<SignInState, BusinessLevelFetchAction>(
      _changeBusinessLevelAction),
  TypedReducer<SignInState, ClientInfoSuccessAction>(_changeClientInfoAction),
  TypedReducer<SignInState, SaveTokenAction>(_saveToken),
  TypedReducer<SignInState, ChangeScreenStateAction>(_changeScreenStateAction),
  TypedReducer<SignInState, SignInAction>(_signInAction),
  TypedReducer<SignInState, SignInFailedAction>(_signInFailed),
  TypedReducer<SignInState, SignInSuccessAction>(_signInSuccess),
  TypedReducer<SignInState, LiveClientDetailsFetchSuccessAction>(
      _onLiveClientFetchAction),
  TypedReducer<SignInState, NotificationCountFromDbFetchAction>(
      _notificationCountAction),
  TypedReducer<SignInState, GetNotificationCountOfBranch>(
      _getNotificationCountOfBranch),
  TypedReducer<SignInState, OnLogoutAction>(_clearState),
  TypedReducer<SignInState, ResetIsExpandedAction>(_resetIsExpandedAction),
  TypedReducer<SignInState, UpdateUniqueListAction>(_updateUniqueListAction),
]);

SignInState _notificationCountAction(
    SignInState state, NotificationCountFromDbFetchAction action) {
  print(action.notificationCount.length);
  return state.copyWith(notificationCountList: action.notificationCount);
}

SignInState _getNotificationCountOfBranch(
    SignInState state, GetNotificationCountOfBranch action) {
  print(action.notificationCount.length);
  return state.copyWith(notificationCountOfBranchList: action.notificationCount);
}

SignInState _onLiveClientFetchAction(
    SignInState state, LiveClientDetailsFetchSuccessAction action) {
  print(action.liveClientDetails.length);
  return state.copyWith(clientCompanyDetails: action.liveClientDetails);
}

SignInState _changeScreenStateAction(
        SignInState state, ChangeScreenStateAction action) =>
    state.copyWith(type: action.type);

SignInState _changeLoadingStatusAction(
        SignInState state, LoadingAction action) =>
    state;

SignInState _changeBusinessLevelAction(
    SignInState state, BusinessLevelFetchAction action) {
  List<ClientLevelDetails> branchList = [];
  branchList.add(
      action.client.branches?.levels?.firstWhere((level) => level.isDefault));
  print(branchList.length);
  return state.copyWith(
    branchList: branchList,
    selectedBranch:
        action.client.branches?.levels?.firstWhere((level) => level.isDefault),
    businessLevel: action.client,
    IsExpanded: true,
    selectedCompany:
        action.client.companies?.levels?.firstWhere((level) => level.isDefault),
    selectedLocation:
        action.client.locations?.levels?.firstWhere((level) => level.isDefault),
    loadingStatus: LoadingStatus.success,
    loginError: "",
  );
}

SignInState _changeClientInfoAction(
        SignInState state, ClientInfoSuccessAction action) =>
    state.copyWith(
        clientId: action.client?.clientId,
        loadingStatus: LoadingStatus.success,
        loginError: "");

SignInState _saveToken(SignInState state, SaveTokenAction action) =>
    state.copyWith(token: action.token);

SignInState _signInAction(SignInState state, SignInAction action) =>
    state.copyWith(
      userName: action.request.userName,
      clientId: action.request.clientId,
      password: action.request.password,
      selectedLiveCompany: action.request.liveClientDetails,
      loadingStatus: LoadingStatus.loading,
      loginError: "",
    );

SignInState _signInFailed(SignInState state, SignInFailedAction action) {
  return state.copyWith(
      type: ScreenState.SINGIN,
      loadingStatus: LoadingStatus.error,
      loginError: action.errorMessage.toString());
}

SignInState _signInSuccess(SignInState state, SignInSuccessAction action) {
  return state.copyWith(
      type: ScreenState.WELCOME,
      loadingStatus: LoadingStatus.success,
      user: action.user);
}

SignInState _updateUniqueListAction(SignInState state, UpdateUniqueListAction action) {
  return state.copyWith(
      uniqueCompanyList : action.unique,
  );
}

SignInState _clearState(SignInState state, OnLogoutAction action) {
  return SignInState.initial();
}

SignInState _resetIsExpandedAction(
    SignInState state, ResetIsExpandedAction action) {
  return state.copyWith(
      password: SignInState.initial().password,
      userId: SignInState.initial().userId,
      userName: SignInState.initial().userName,
      clientId: SignInState.initial().clientId,
      selectedBranch: SignInState.initial().selectedBranch,
      selectedCompany: SignInState.initial().selectedCompany,
      selectedLocation: SignInState.initial().selectedLocation,
      selectedLiveCompany: SignInState.initial().selectedLiveCompany,
      liveClientModel: SignInState.initial().liveClientModel,
      user: SignInState.initial().user,
      businessLevel: SignInState.initial().businessLevel,
      IsExpanded: SignInState().businessLevel != null
//      clientCompanyDetails: SignInState.initial().clientCompanyDetails,

      );
}

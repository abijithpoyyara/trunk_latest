import 'package:base/redux.dart';
import 'package:base/src/services/model/response/client_info.dart';
import 'package:base/widgets.dart';

import '../../../services.dart';

class BaseLoginViewModel extends BaseViewModel {
  final ScreenState type;
  final String password;
  final String clientId;
  final String userName;

  final ClientLevel branches;
  final ClientLevel companies;
  final ClientLevel locations;
  final ClientLevelDetails selectedBranch;
  final ClientLevelDetails selectedCompany;
  final ClientLevelDetails selectedLocation;
  final LiveClientDetails selectedLiveCompany;
  final List<LiveClientDetails> clientCompanyDetails;

  final Function(LoginModel) login;

  final Function(LoginModel) saveCredentials;

  final Function(LoginModel) moreDetails;
  final Function(List<LoginModel>) onNotifyNotification;
  final Function() resetIsExpanded;
  final Function() callInitialScreen;
  final Function(ScreenState) resetScreenState;
  final Function() onLogout;
  final Function(LoginModel loginModel) onFetchBranchCount;
  final List<BusinessLevelModel> businessLevelModel;
  final List<ClientLevelDetails> branchList;
  final List<ClientLevelDetails> locationList;
  final List<ClientLevelDetails> companiesList;
  final List<NotificationCountFromDbList> notificationCountList;
  final User user;
  final List<NotificationCountDetails> notificationCountOfBranchList;
  BaseLoginViewModel(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      this.type,
      this.callInitialScreen,
      this.password,
      this.userName,
      this.clientId,
      this.login,
      this.branches,
      this.companies,
      this.locations,
      this.selectedBranch,
      this.selectedCompany,
      this.selectedLocation,
      this.moreDetails,
      this.clientCompanyDetails,
      this.selectedLiveCompany,
      this.resetIsExpanded,
      this.resetScreenState,
      this.onLogout,
      this.saveCredentials,
      this.businessLevelModel,
      this.branchList,
      this.locationList,
      this.notificationCountList,
      this.user,
      this.onNotifyNotification,
      this.companiesList,
      this.notificationCountOfBranchList,
      this.onFetchBranchCount})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory BaseLoginViewModel.fromStore(Store<BaseAppState> store) {
    SignInState state = store.state.signInState;
    return BaseLoginViewModel(
        loadingStatus: state.loadingStatus,
        type: state.type,
        userName: state.userName,
        password: state.password,
        clientId: state.clientId,
        loadingError: state.loadingError,
        branches: state.businessLevel?.branches,
        companies: state.businessLevel?.companies,
        locations: state.businessLevel?.locations,
        selectedBranch: state.selectedBranch,
        selectedCompany: state.selectedCompany,
        selectedLocation: state.selectedLocation,
        companiesList: state.companiesList,
        locationList: state.locationList,
        user: state.user,
        branchList: state.branchList,
        notificationCountOfBranchList: state.notificationCountOfBranchList,
        notificationCountList: state.notificationCountList,
        clientCompanyDetails: state.clientCompanyDetails,
        selectedLiveCompany: state.selectedLiveCompany,
        businessLevelModel: store.state.homeState.user.businessLevelModel,
        login: (LoginModel loginModel) =>
            store.dispatch(authenticateUser(loginModel)),
        saveCredentials: (LoginModel loginModel) =>
            store.dispatch(initialAuthenticate(loginModel)),
        moreDetails: (LoginModel loginModel) =>
            store.dispatch(getMoreDetails(loginModel)),
        resetIsExpanded: () => store.dispatch(ResetIsExpandedAction()),
        callInitialScreen: () => store.dispatch(OnLogoutAction()),
        resetScreenState: (ScreenState screen) =>
            store.dispatch(ChangeScreenStateAction(screen)),
        onNotifyNotification: (List<LoginModel> models) {
          store.dispatch(fetchNotificationCountFromDb(loginModel: models));
        },
        onFetchBranchCount: (loginmodel) {},
        onLogout: () {
          store.dispatch(OnClearAction());
          store.dispatch(OnLogoutAction());
        });
  }
}

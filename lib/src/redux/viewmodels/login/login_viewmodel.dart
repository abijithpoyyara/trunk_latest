import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:redstars/src/redux/actions/sign_in/login_action.dart';

class LoginViewModel extends BaseLoginViewModel {
  bool isExpanded;
  final Function() callInitialScreen;
  final Function() onLogout;
  final Function(LoginModel) updateUniqueList;


  LoginViewModel(
      {this.callInitialScreen,
      this.isExpanded,
      this.onLogout,
      this.updateUniqueList,
      ScreenState type,
      String password,
      String clientId,
      String userName,
      LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      ClientLevel branches,
      ClientLevel companies,
      ClientLevel locations,
      LiveClientDetails selectedLiveCompany,
      List<LiveClientDetails> liveClientDetails,
      ClientLevelDetails selectedBranch,
      ClientLevelDetails selectedCompany,
      ClientLevelDetails selectedLocation,
      Function(LoginModel) moreDetails,
      Function(LoginModel) login,
      Function(List<LoginModel>) onNotifyNotification,
      Function(LoginModel) saveCredential,
      Function() resetIsExpanded,
      Function(ScreenState) resetScreenState,
      List<ClientLevelDetails> branchList,
      List<ClientLevelDetails> locationList,
      List<ClientLevelDetails> companiesList,
      User user,
      List<NotificationCountFromDbList> notificationCountList,
      List<BusinessLevelModel> businesslevelModel,
         Function( LoginModel loginModel) onFetchBranchCount,
        List<NotificationCountDetails> notificationCountOfBranchList,})
      : super(
            type: type,
            password: password,
            clientId: clientId,
            userName: userName,
            loadingStatus: loadingStatus,
            loadingMessage: loadingMessage,
            loadingError: loadingError,
            branches: branches,
            companies: companies,
            locations: locations,
            selectedBranch: selectedBranch,
            selectedCompany: selectedCompany,
            selectedLocation: selectedLocation,
            clientCompanyDetails: liveClientDetails,
            selectedLiveCompany: selectedLiveCompany,
            moreDetails: moreDetails,
            notificationCountOfBranchList: notificationCountOfBranchList,
            notificationCountList: notificationCountList,
            login: login,
            user: user,
            resetIsExpanded: resetIsExpanded,
            callInitialScreen: callInitialScreen,
            resetScreenState: resetScreenState,
            saveCredentials: saveCredential,
            onFetchBranchCount: onFetchBranchCount,
            businessLevelModel: businesslevelModel,
            companiesList: companiesList,
            branchList: branchList,
            onNotifyNotification: onNotifyNotification,
            locationList: locationList,
            onLogout: onLogout
  );

  factory LoginViewModel.fromStore(Store<BaseAppState> store) {
    SignInState state = store.state.signInState;
    return LoginViewModel(
        isExpanded: state.IsExpanded,
        loadingStatus: state.loadingStatus,
        type: state.type,
        userName: state.userName,
        password: state.password,
        clientId: state.clientId,
        user: state.user,
        loadingError: state.loadingError,
        branches: state.businessLevel?.branches,
        companies: state.businessLevel?.companies,
        locations: state.businessLevel?.locations,
        selectedBranch: state.selectedBranch,
        selectedCompany: state.selectedCompany,
        selectedLocation: state.selectedLocation,
        selectedLiveCompany: state.selectedLiveCompany,
        liveClientDetails: state.clientCompanyDetails,
        companiesList: state.companiesList,
        locationList: state.locationList,
        branchList: state.branchList,
        notificationCountOfBranchList: state.notificationCountOfBranchList,
        notificationCountList: state.notificationCountList,
        businesslevelModel: store.state.homeState.user.businessLevelModel,
        // saveCredential: (loginModel) => store.dispatch(checkUser(loginModel)),
        login: (loginModel) => store.dispatch(signInUser(loginModel)),
        moreDetails: (loginModel) => store.dispatch(getMoreDetails(loginModel)),
        resetIsExpanded: () => store.dispatch(ResetIsExpandedAction()),
        callInitialScreen: () => store.dispatch(OnLogoutAction()),
        onNotifyNotification: (List<LoginModel> models) {
          store.dispatch(fetchNotificationCountFromDb(loginModel: models));
        },
        updateUniqueList: (uniqueList) => store.dispatch(UpdateUniqueListAction(uniqueList)),
        onFetchBranchCount: (loginmodel){},
        resetScreenState: (ScreenState screen) =>
            store.dispatch(ChangeScreenStateAction(screen)),
        onLogout: () {
          store.dispatch(OnClearAction());
          store.dispatch(OnLogoutAction());
        });
  }
}

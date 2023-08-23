import 'package:base/redux.dart';
import 'package:base/src/services/model/response/client_info.dart';
import 'package:base/src/services/model/response/live_client_details.dart';
import 'package:base/widgets.dart';
import 'package:meta/meta.dart';

@immutable
class SignInState extends BaseState {
  final ScreenState type;
  final String password;
  final String userName;
  final String clientId;
  final String userId;
  final User user;
  final ClientDetails businessLevel;
  final LoginModel uniqueCompanyList;
  final ClientLevelDetails selectedBranch;
  final ClientLevelDetails selectedCompany;
  final ClientLevelDetails selectedLocation;
  final LiveClientDetails selectedLiveCompany;
  final LiveClientDetailsModel liveClientModel;
  final List<LiveClientDetails> clientCompanyDetails;
  final bool IsExpanded;
  final List<ClientLevelDetails> branchList;
  final List<ClientLevelDetails> locationList;
  final List<ClientLevelDetails> companiesList;
  final List<NotificationCountFromDbList> notificationCountList;
  final List<NotificationCountDetails> notificationCountOfBranchList;
  SignInState(
      {this.type,
      LoadingStatus loadingStatus,
      this.selectedLiveCompany,
      this.clientCompanyDetails,
      this.liveClientModel,
      this.password,
      this.userName,
      this.userId,
      this.clientId,
      this.user,
      this.businessLevel,
      this.selectedBranch,
      this.selectedCompany,
      this.selectedLocation,
      this.IsExpanded,
      this.companiesList,
      this.locationList,
      this.branchList,
      this.notificationCountList,
      this.notificationCountOfBranchList,
      this.uniqueCompanyList,
      String loginError,
      String loadingMessage})
      : super(
            loadingStatus: loadingStatus,
            loadingMessage: loadingMessage,
            loadingError: loginError);

  SignInState copyWith({
    ScreenState type,
    LoadingStatus loadingStatus,
    String password,
    String userName,
    String userId,
    String token,
    String clientId,
    User user,
    String loginError,
    ClientDetails businessLevel,
    ClientLevelDetails selectedBranch,
    ClientLevelDetails selectedCompany,
    ClientLevelDetails selectedLocation,
    List<LiveClientDetails> clientCompanyDetails,
    LiveClientDetails selectedLiveCompany,
    LiveClientDetailsModel liveClientModel,
    List<ClientLevelDetails> branchList,
    List<ClientLevelDetails> locationList,
    List<ClientLevelDetails> companiesList,
    List<NotificationCountFromDbList> notificationCountList,
    List<NotificationCountDetails> notificationCountOfBranchList,
    bool IsExpanded,
    LoginModel uniqueCompanyList,
  }) {
    return new SignInState(
        type: type ?? this.type,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        password: password ?? this.password,
        userName: userName ?? this.userName,
        clientId: clientId ?? this.clientId,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        loginError: loginError ?? this.loadingError,
        businessLevel: businessLevel ?? this.businessLevel,
        selectedBranch: selectedBranch ?? this.selectedBranch,
        selectedCompany: selectedCompany ?? this.selectedCompany,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        clientCompanyDetails: clientCompanyDetails ?? this.clientCompanyDetails,
        selectedLiveCompany: selectedLiveCompany ?? this.selectedLiveCompany,
        liveClientModel: liveClientModel ?? this.liveClientModel,
        IsExpanded: IsExpanded ?? this.IsExpanded,
        companiesList: companiesList ?? this.companiesList,
        branchList: branchList ?? this.branchList,
        notificationCountList:
            notificationCountList ?? this.notificationCountList,
      uniqueCompanyList:uniqueCompanyList??this.uniqueCompanyList,
        locationList: locationList ?? this.locationList,
      notificationCountOfBranchList: notificationCountOfBranchList ?? this.notificationCountOfBranchList,
    );
  }

  factory SignInState.initial() {
    return new SignInState(
        type: ScreenState.WELCOME,
        loadingStatus: LoadingStatus.success,
        IsExpanded: false,
        password: "",
        userId: "",
        userName: "",
        clientId: "",
        loginError: "",
        businessLevel: null,
        selectedBranch: null,
        selectedCompany: null,
        selectedLocation: null,
        selectedLiveCompany: null,
        clientCompanyDetails: List(),
        locationList: List(),
        companiesList: List(),
        branchList: List(),
        liveClientModel: null,
        notificationCountList: List(),
        notificationCountOfBranchList: List(),
        user: User(
            userName: "",
            companyName: "",
            companyLocation: "",
            moduleList: List()));
  }
}

import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/model/back_date_sub_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/back_date_entry_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/initial_model.dart';

class BackDatedEntryState extends BaseState {
  final AddOptionModel optionList;
  final AddBranchModel branchList;
  final AddUserListModel userList;
  final String selectedBranchName;
  final String selectedOptionName;
  final List<dynamic> selectedUserList;
  final List<SanctionedOptionsModel> sanctionedList;
  final List<BackDateViewDetails> backDatedViewModel;
  final BackDateEntryDetailModel dtlModel;
  final double scrollPosition;
  final bool saved;
  final bool isEditSaved;
  final BackDateFilterModel backDateFilterModel;
  final BackDateInitialModel backDateInitialModel;
  final DateTime periodFrom;
  final DateTime periodTo;
  final DateTime validUpto;
  final List<BackDateEntrySubModel> backDatedEntrySanctionedData;
  final BackDateEntrySubModel model;
  final int isEdited;

  BackDatedEntryState(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      this.backDatedEntrySanctionedData,
      this.optionList,
      this.branchList,
      this.userList,
      this.selectedOptionName,
      this.selectedUserList,
      this.selectedBranchName,
      this.sanctionedList,
      this.backDatedViewModel,
      this.scrollPosition,
      this.dtlModel,
      this.saved,
      this.isEditSaved,
      this.backDateFilterModel,
      this.backDateInitialModel,
      this.periodTo,
      this.periodFrom,
      this.model,
      this.isEdited,
      this.validUpto})
      : super(
          loadingMessage: loadingMessage,
          loadingError: loadingError,
          loadingStatus: loadingStatus,
        );

  BackDatedEntryState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    AddOptionModel optionList,
    AddBranchModel branchList,
    String selectedOptionName,
    List<dynamic> selectedUserList,
    AddUserListModel userList,
    String selectedBranchName,
    double scrollPosition,
    List<SanctionedOptionsModel> sanctionedList,
    List<BackDateViewDetails> backDatedViewModel,
    BackDateEntryDetailModel dtlModel,
    List<BackDateEntrySubModel> backDatedEntrySanctionedData,
    bool saved,
    bool isEditSaved,
    BackDateEntryModel model,
    BackDateFilterModel backDateFilterModel,
    BackDateInitialModel backDateInitialModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validUpto,
    int isEdited,
  }) {
    return BackDatedEntryState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError,
        loadingMessage: loadingMessage,
        optionList: optionList ?? this.optionList,
        branchList: branchList ?? this.branchList,
        userList: userList ?? this.userList,
        backDatedEntrySanctionedData:
            backDatedEntrySanctionedData ?? this.backDatedEntrySanctionedData,
        selectedBranchName: selectedBranchName ?? this.selectedBranchName,
        sanctionedList: sanctionedList ?? this.sanctionedList,
        selectedUserList: selectedUserList ?? this.selectedUserList,
        selectedOptionName: selectedOptionName ?? this.selectedOptionName,
        backDatedViewModel: backDatedViewModel ?? this.backDatedViewModel,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        dtlModel: dtlModel ?? this.dtlModel,
        saved: saved ?? this.saved,
        isEditSaved: isEditSaved ?? this.isEditSaved,
        validUpto: validUpto ?? this.validUpto,
        periodFrom: periodFrom ?? this.periodFrom,
        periodTo: periodTo ?? this.periodTo,
        model: model ?? this.model,
        backDateInitialModel: backDateInitialModel ?? this.backDateInitialModel,
        backDateFilterModel: backDateFilterModel ?? this.backDateFilterModel,
        isEdited: isEdited ?? this.isEdited);
  }

  factory BackDatedEntryState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return BackDatedEntryState(
        loadingStatus: LoadingStatus.success,
        loadingError: '',
        loadingMessage: '',
        optionList: null,
        branchList: null,
        userList: null,
        periodTo: currentDate.subtract(Duration(days: 1)),
        periodFrom: currentDate.subtract(Duration(days: 1)),
        validUpto: currentDate,
        backDateInitialModel: BackDateInitialModel(
            periodFrom: currentDate.subtract(Duration(days: 1)),
            periodTo: currentDate.subtract(Duration(days: 1)),
            validUpto: currentDate),
        backDateFilterModel: BackDateFilterModel(
            periodFrom: startDate, periodTo: currentDate, isActive: true),
        sanctionedList: [],
        selectedBranchName: "",
        selectedOptionName: "",
        selectedUserList: [],
        backDatedViewModel: [],
        scrollPosition: 0.0,
        dtlModel: null,
        saved: false,
        isEdited: 0,
        isEditSaved: false,
        backDatedEntrySanctionedData: List());
  }
}

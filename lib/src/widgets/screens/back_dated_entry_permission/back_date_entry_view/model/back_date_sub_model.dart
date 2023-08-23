import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/back_date_entry_model.dart';


class BackDateEntrySubModel extends BackDateEntryModel {
  BackDateEntrySubModel(
      {AddOptionList optionName,
        AddBranchList branchName,
        List<AddUserList> userList,
        List<AddUserList> userList1,
        bool isNewItem,
        int updatedId})
      : super(
      optionName: optionName,
      branchName: branchName,
      userList: userList,
      userList1: userList1,
      isNewItem: isNewItem,
      updatedId: updatedId);

  factory BackDateEntrySubModel.fromRequisitionModel(BackDateEntryModel model) {
    return BackDateEntrySubModel(
        optionName: model.optionName,
        branchName: model.branchName,
        userList: model.userList,
        userList1: model.userList1,
        isNewItem: model.isNewItem,
        updatedId: model.updatedId);
  }

  BackDateEntrySubModel merge(BackDateEntrySubModel model) {
    return BackDateEntrySubModel(
        optionName: model.optionName ?? optionName,
        branchName: model.branchName ?? branchName,
        userList: model.userList ?? userList,
        userList1: model.userList1 ?? userList1,
        isNewItem: model.isNewItem ?? isNewItem,
        updatedId: model.updatedId ?? updatedId);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is BackDateEntrySubModel &&
            runtimeType == other.runtimeType &&
            optionName == other.optionName &&
            branchName == other.branchName;
  }

  @override
  int get hashCode =>
      optionName.hashCode ^ branchName.hashCode ^ userList.hashCode;
}


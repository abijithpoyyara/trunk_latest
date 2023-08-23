import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';

class BackDateEntryModel {
  AddOptionList optionName;
  AddBranchList branchName;
  List<AddUserList> userList;
  List<AddUserList> userList1;
  bool isNewItem;
  int updatedId;
  BackDateEntryModel(
      {this.userList,
      this.branchName,
      this.optionName,
      this.userList1,
      this.isNewItem,
      this.updatedId});
}

class EntryModel {
  AddOptionList optionName;
  AddBranchList branchName;
  List<AddUserList> userList;
  List<AddUserList> userList1;
  bool isNewItem;
  int updatedId;
  EntryModel(
      {this.userList,
      this.branchName,
      this.optionName,
      this.userList1,
      this.isNewItem,
      this.updatedId});
}

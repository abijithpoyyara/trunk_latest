import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';

class BackDateFilterModel {
  DateTime periodFrom;
  DateTime periodTo;
  bool isActive;
  String transNo;
  AddBranchList branch;
  AddOptionList option;

  BackDateFilterModel(
      {this.periodFrom,
      this.periodTo,
      this.branch,
      this.isActive,
      this.option,
      this.transNo});

  BackDateFilterModel copyWith({
    DateTime periodFrom,
    DateTime periodTo,
    bool isActive,
    String transNo,
    AddBranchList branch,
    AddOptionList option,
  }) {
    return BackDateFilterModel(
      periodFrom: periodFrom ?? this.periodFrom,
      periodTo: periodTo ?? this.periodTo,
      option: option ?? this.option,
      isActive: isActive ?? this.isActive,
      transNo: transNo ?? this.transNo,
      branch: branch ?? this.branch,
    );
  }
}

import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';

class ApprovalSaveModel {
  ActionTaken approvalStatus;
  DateTime extendedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  String remarks;
  int id;
  DateTime approvedDate;
  ApprovalSaveModel(
      {this.id,
      this.approvalStatus,
      this.extendedDate,
      this.remarks,
      this.approvedDate});
}

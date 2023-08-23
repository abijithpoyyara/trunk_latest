import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_status.dart';
import 'package:redstars/src/services/repository/document_approval/document_approval_repository.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';
import 'package:redstars/utility.dart';

class TransactionTypeSelectedAction {
  final TransactionTypes transaction;
  final List<ApprovalsTypes> approvalTypes;

  TransactionTypeSelectedAction({this.transaction, this.approvalTypes});
}

enum DocumentApprovalAction{
  HOME_SCREEN,
  SUMMARY_SCREEN,
  DETAIL_SCREEN,
  VIEWER_SCREEN,
  RELATION_SCREEN
}









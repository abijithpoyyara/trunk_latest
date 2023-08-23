import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';

import 'document_approval_detail_reducer.dart';
import 'document_approval_history_reducer.dart';
import 'document_approval_summary_reducer.dart';
import 'document_approval_viewer_reducer.dart';

DocumentApprovalState documentApprovalReducer(
        DocumentApprovalState state, dynamic action) =>
    state.copyWith(
      summaryState: documentApprSummaryReducer(state.summaryState, action),
      detailState: documentApprDetailReducer(state.detailState, action),
      historyState: documentApprHistoryReducer(state.historyState, action),
      viewerState: documentApprViewerReducer(state.viewerState, action),
    );

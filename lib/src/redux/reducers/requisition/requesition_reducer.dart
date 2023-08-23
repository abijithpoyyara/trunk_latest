import 'package:redstars/src/redux/reducers/requisition/payment_requisition/payment_requistion_reducer.dart';
import 'package:redstars/src/redux/reducers/requisition/purchase_requisition/purchase_requistion_reducer.dart';
import 'package:redstars/src/redux/reducers/requisition/stock_requisition/stock_requistion_reducer.dart';
import 'package:redstars/src/redux/states/requisition/requisition_state.dart';

RequisitionState requisitionReducer(RequisitionState state, dynamic action) =>
    state.copyWith(
      purchaseRequisitionState:
          purchaseRequisitionReducer(state.purchaseRequisitionState, action),
      stockRequisitionState:
          stockRequisitionReducer(state.stockRequisitionState, action),
      paymentRequisitionState:
          paymentRequisitionReducer(state.paymentRequisitionState, action),
    );

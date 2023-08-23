import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/requisition/payment_requisition/payment_requistion_state.dart';
import 'package:redstars/src/redux/states/requisition/purchase_requisition/purchase_requistion_state.dart';
import 'package:redstars/src/redux/states/requisition/stock_requisition/stock_requistion_state.dart';

@immutable
class RequisitionState {
  final PurchaseRequisitionState purchaseRequisitionState;
  final StockRequisitionState stockRequisitionState;
  final PaymentRequisitionState paymentRequisitionState;

  RequisitionState({
    @required this.purchaseRequisitionState,
    @required this.stockRequisitionState,
    @required this.paymentRequisitionState,
  });

  RequisitionState copyWith({
    PurchaseRequisitionState purchaseRequisitionState,
    StockRequisitionState stockRequisitionState,
    PaymentRequisitionState paymentRequisitionState,
  }) {
    return RequisitionState(
        purchaseRequisitionState:
            purchaseRequisitionState ?? this.purchaseRequisitionState,
        stockRequisitionState:
            stockRequisitionState ?? this.stockRequisitionState,
        paymentRequisitionState: paymentRequisitionState);
  }

  factory RequisitionState.initial() {
    return RequisitionState(
      purchaseRequisitionState: PurchaseRequisitionState.initial(),
      stockRequisitionState: StockRequisitionState.initial(),
      paymentRequisitionState: PaymentRequisitionState.initial(),
    );
  }
}

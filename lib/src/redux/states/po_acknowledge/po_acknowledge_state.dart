import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';

class AcknowledgeState extends BaseState {
  final List<PurchaseOrderModel> pendingOrders;
  final List<PurchaseOrderModel> processingOrders;
  final List<PurchaseOrderModel> completedOrders;
  final DateTimeRange filterRange;
  final PODetailModel orderDetails;
  final PurchaseOrderModel selectedOrder;
  final String remarks;

  final double pendingScrollOffset;
  final double processingScrollOffset;
  final double completedScrollOffset;
  final bool poaSavedStatus;
  final POAckSupplierLookupItem currentSupplierObj;

  AcknowledgeState({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.filterRange,
    this.pendingOrders,
    this.processingOrders,
    this.completedOrders,
    this.orderDetails,
    this.selectedOrder,
    this.pendingScrollOffset,
    this.processingScrollOffset,
    this.completedScrollOffset,
    this.poaSavedStatus,
    this.remarks,
    this.currentSupplierObj,
  }) : super(
            loadingStatus: loadingStatus,
            loadingMessage: loadingMessage,
            loadingError: loadingError);

  AcknowledgeState copyWith({
    DateTimeRange filterRange,
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    double pendingScrollOffset,
    double processingScrollOffset,
    double completedScrollOffset,
    List<PurchaseOrderModel> pendingOrders,
    List<PurchaseOrderModel> processingOrders,
    List<PurchaseOrderModel> completedOrders,
    PODetailModel orderDetails,
    PurchaseOrderModel selectedOrder,
    bool poaSavedStatus,
    String remarks,
    POAckSupplierLookupItem supplierObj,
  }) {
    return AcknowledgeState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      filterRange: filterRange ?? this.filterRange,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      processingOrders: processingOrders ?? this.processingOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      orderDetails: orderDetails ?? this.orderDetails,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      pendingScrollOffset: pendingScrollOffset ?? this.pendingScrollOffset,
      processingScrollOffset:
          processingScrollOffset ?? this.processingScrollOffset,
      completedScrollOffset:
          completedScrollOffset ?? this.completedScrollOffset,
      poaSavedStatus: poaSavedStatus ?? this.poaSavedStatus,
      remarks: remarks ?? this.remarks,
      currentSupplierObj: supplierObj ?? this.currentSupplierObj,
    );
  }

  factory AcknowledgeState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return AcknowledgeState(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      poaSavedStatus: false,
      pendingScrollOffset: 0.0,
      processingScrollOffset: 0.0,
      completedScrollOffset: 0.0,
      filterRange: DateTimeRange(
        start: startDate,
        end: currentDate,
      ),
      pendingOrders: [],
      processingOrders: [],
      completedOrders: [],
      orderDetails: null,
      selectedOrder: null,
      remarks: '',
    );
  }
}

import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/po_acknowledge/po_acknowledge_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';

import 'filter_model.dart';

enum AcknowledgeType { COMPLETED, PROCESSING, PENDING }

extension acknowledgeTypeExtension on AcknowledgeType {
  bool get isCompleted => this == AcknowledgeType.COMPLETED;

  bool get isProcessing => this == AcknowledgeType.PROCESSING;

  bool get isPending => this == AcknowledgeType.PENDING;
}

class AcknowledgeViewModel extends BaseViewModel {
  final DateTime startDate;
  final DateTime endDate;

  final String remarks;

  final double pendingScrollOffset;
  final double processingScrollOffset;
  final double completedScrollOffset;

  final List<PurchaseOrderModel> pendingOrders;
  final List<PurchaseOrderModel> processingOrders;
  final List<PurchaseOrderModel> completedOrders;

  final PODetailModel orderDetails;
  final List<POItemModel> orderItems;
  final List<POVehicleModel> vehicles;
  final PurchaseOrderModel selectedOrder;
  final bool saveStatus;

  final ValueSetter<String> onRemarksChange;
  final Future<void> Function(AcknowledgeType) onRefresh;
  final Function(POFilterModel) onFilter;
  final Function(AcknowledgeType, double, int) getMoreItem;
  final Function(POVehicleModel) onDeleteVehicle;
  final Function(POVehicleModel) saveVehicle;

  final Function(int) saveAcknowledgement;
  final Function() editAcknowledgement;
  final Function() deleteAcknowledgement;
  POAckSupplierLookupItem supplierObj;
  final Function() ordersToDefault;
  final DateTimeRange dateRange;
  final Function(POFilterModel result) saveModelVar;

  AcknowledgeViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.startDate,
    this.endDate,
    this.remarks,
    this.dateRange,
    this.pendingScrollOffset,
    this.processingScrollOffset,
    this.completedScrollOffset,
    this.pendingOrders,
    this.processingOrders,
    this.completedOrders,
    this.orderDetails,
    this.orderItems,
    this.vehicles,
    this.selectedOrder,
    this.saveStatus,
    this.onRefresh,
    this.onFilter,
    this.getMoreItem,
    this.onDeleteVehicle,
    this.saveVehicle,
    this.saveAcknowledgement,
    this.editAcknowledgement,
    this.deleteAcknowledgement,
    this.onRemarksChange,
    this.supplierObj,
    this.ordersToDefault,
    this.saveModelVar,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory AcknowledgeViewModel.fromStore(Store<AppState> store) {
    final state = store.state.acknowledgeState;
    return AcknowledgeViewModel(
        loadingStatus: state.loadingStatus,
        startDate: state.filterRange.start,
        endDate: state.filterRange.end,
        dateRange: state.filterRange,
        remarks: state.remarks,
        pendingScrollOffset: state.pendingScrollOffset,
        processingScrollOffset: state.processingScrollOffset,
        completedScrollOffset: state.completedScrollOffset,
        pendingOrders: state.pendingOrders,
        processingOrders: state.processingOrders,
        completedOrders: state.completedOrders,
        orderDetails: state.orderDetails,
        orderItems: state.orderDetails?.items ?? [],
        vehicles: state.orderDetails?.vehicles ?? [],
        selectedOrder: state.selectedOrder,
        saveStatus: state.poaSavedStatus,
        onRemarksChange: (remarks) =>
            store.dispatch(POARemarksChangeAction(remarks)),
        onRefresh: (type) async {
          await Future.delayed(Duration(seconds: 3));
          store.dispatch(fetchPOList(
            type,
            filters: POFilterModel(
                dateRange: state.filterRange,
                supplier: state.currentSupplierObj),
          ));
        },
        onFilter: (filterModel) =>
            store.dispatch(refreshPOs(filters: filterModel)),
        getMoreItem: (type, offset, start) => store.dispatch(fetchPOList(type,
            offset: offset,
            start: start,
            filters: POFilterModel(
                dateRange: state.filterRange,
                supplier: state.currentSupplierObj))),
        onDeleteVehicle: (vehicle) =>
            store.dispatch(VehicleDeletedAction(vehicle)),
        saveVehicle: (vehicle) => store.dispatch(VehicleSaveAction(vehicle)),
        saveAcknowledgement: (supplierId) =>
            store.dispatch(onSaveAcknowledgement(
              state.orderDetails,
              state.filterRange,
              supplierId,
              remarks: state.remarks,
            )),
        editAcknowledgement: () {
          store.dispatch(onEditAcknowledgement(
            state.orderDetails,
            state.filterRange,
            remarks: state.remarks,
          ));
        },
        deleteAcknowledgement: () {
          store.dispatch(
              onDeleteAcknowledgement(state.orderDetails, state.filterRange));
        },
        supplierObj: state.currentSupplierObj,
        ordersToDefault: () {
          store.dispatch(POListFetchSuccessAction(
              orders: [], type: AcknowledgeType.PENDING));
          store.dispatch(POListFetchSuccessAction(
              orders: [], type: AcknowledgeType.PROCESSING));
          store.dispatch(POListFetchSuccessAction(
              orders: [], type: AcknowledgeType.COMPLETED));

          DateTime currentDate = DateTime.now();
          store.dispatch(SavingModelVarAction(
              filterRange: DateTimeRange(
                start: DateTime(currentDate.year, currentDate.month, 1),
                end: currentDate,
              ),
              supplierObj: POAckSupplierLookupItem()));
        },
        saveModelVar: (result) => store.dispatch(SavingModelVarAction(
            filterRange: DateTimeRange(
              start: result?.fromDate,
              end: result?.toDate,
            ),
            supplierObj: result.supplier)));
  }

  void onLoadMore(AcknowledgeType type, double position) {
    switch (type) {
      case AcknowledgeType.COMPLETED:
        getMoreItem(type, position, completedOrders.length);
        break;
      case AcknowledgeType.PROCESSING:
        getMoreItem(type, position, processingOrders.length);

        break;
      case AcknowledgeType.PENDING:
        getMoreItem(type, position, pendingOrders.length);

        break;
    }
  }

  String validateSaveAcknowledgement(AcknowledgeType type, int supplierId) {
    String validationMsg = '';
    switch (type) {
      case AcknowledgeType.COMPLETED:
        return validationMsg;
      case AcknowledgeType.PROCESSING:
        if (vehicles.isNotEmpty)
          editAcknowledgement();
        else
          validationMsg = 'Please add vehicles for the PO';
        return validationMsg;
        break;
      case AcknowledgeType.PENDING:
        if (vehicles.isNotEmpty)
          saveAcknowledgement(supplierId);
        else
          validationMsg = 'Please add vehicles for the PO';
        return validationMsg;
        break;
    }
    return validationMsg;
  }
}

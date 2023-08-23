import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_reqst_detail.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_view_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/process_from_fill_model.dart';
import 'package:redstars/src/services/repository/requisition/payment_requisition/payment_requisition_repository.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

class AddPaymentRequisitionAction {
  PaymentRequisitionDtlModel item;

  AddPaymentRequisitionAction(this.item);
}

class RemovePaymentRequisitionAction {
  PaymentRequisitionDtlModel item;

  RemovePaymentRequisitionAction(this.item);
}

class PaymentReqstnViewAction {
  PaymentListModel paymentReqModel;
  PaymentReqstnViewAction(
    this.paymentReqModel,
  );
}

class PaymentRequisitionDetailAction {
  List<PaymentDetailViewList> detailList;
  PaymentRequisitionDetailAction(this.detailList);
}

class ProcessFromFillAction {
  ServiceLookupItem result;

  ProcessFromFillAction(this.result);
}

class ChangeHeaderFieldAction {
  PaymentRequisitionHdrModel hdrModel;

  ChangeHeaderFieldAction(this.hdrModel);
}

class PaymentItemBudgetDetails {
  List<BudgetDtlModel> itembudgetDtl;
  PaymentItemBudgetDetails(this.itembudgetDtl);
}

class PaymentConfigFetchAction {
  List<BSCModel> settleWithin;
  List<BSCModel> analysisCode;
  List<BSCModel> analysisType;
  List<BCCModel> reqFromModel;
  List<BCCModel> reqTransTypeModel;
  List<BCCModel> reqProcessTypeModel;
  List<BCCModel> paymentModel;
  List<TaxConfigModel> taxConfigs;

  PaymentConfigFetchAction(
      {this.settleWithin,
      this.reqFromModel,
      this.reqTransTypeModel,
      this.reqProcessTypeModel,
      this.paymentModel,
      this.taxConfigs,
      this.analysisCode,
      this.analysisType});
}

class SavingPaymentFilterAction {
  PVFilterModel filterModel;

  SavingPaymentFilterAction({this.filterModel});
}

class RequisitionSaveAction {}

class TransactionDtlListFetchAction {
  List<ProcessFromDtlList> result;

  TransactionDtlListFetchAction(this.result);
}

ThunkAction fetchInitialData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));

      PaymentRequisitionRepository().getInitialConfigs(
        onRequestSuccess: (
                {List<BSCModel> settleWithin,
                List<BSCModel> analysisCode,
                List<BSCModel> analysisType,
                List<BCCModel> reqFromModel,
                List<BCCModel> reqTransTypeModel,
                List<BCCModel> reqProcessTypeModel,
                List<BCCModel> paymentTypeModel,
                List<TaxConfigModel> taxConfigs}) =>
            store.dispatch(PaymentConfigFetchAction(
                settleWithin: settleWithin,
                reqFromModel: reqFromModel,
                reqTransTypeModel: reqTransTypeModel,
                reqProcessTypeModel: reqProcessTypeModel,
                paymentModel: paymentTypeModel,
                analysisCode: analysisCode,
                analysisType: analysisType,
                taxConfigs: taxConfigs)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPaymentViewListData({
  int start,
  int optionId,
  PVFilterModel filterModel,
  int sor_id,
  int eor_id,
  int totalrecords,
  List<PaymentListview> listData,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PaymentRequisitionRepository().getPaymentReqstnView(
        start: start,
        filterModel: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        optionId: optionId,
        totalRecords: totalrecords,
        onRequestSuccess: (status) {
          sor_id = status.SOR_Id;
          eor_id = status.EOR_Id;
          totalrecords = status.totalRecords;
          listData.addAll(status.paymentReqViewList);
          store.dispatch(new PaymentReqstnViewAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPaymentRequestDetailFetchAction(
    {int start,
    int optionId,
    PVFilterModel filterModel,
    int sor_id,
    int eor_id,
    int totalrecords,
    PaymentListview listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PaymentRequisitionRepository().getPaymentRequisitionDetailList(
        start: start,
        filterModel: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        optionId: optionId,
        totalRecords: totalrecords,
        paymentRqstId: listData,
        onRequestSuccess: (status) {
          store.dispatch(new PaymentRequisitionDetailAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchTransactionFillDetails(TransTypeLookupItem transaction) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Requisition ",
      ));

      PaymentRequisitionRepository().getTransactionFillDetails(
          transaction: transaction,
          onRequestSuccess: (result) {
            store.dispatch(ProcessFromFillAction(result));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchPaymentItemBudgetDtl({int optionId, int accId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Budget Details ",
      ));

      PaymentRequisitionRepository().getPaymentItemBudget(
          optionId: optionId,
          acctId: accId,
          onRequestSuccess: (result) =>
              {store.dispatch(PaymentItemBudgetDetails(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchTransactionListDetails(TransTypeLookupItem transaction) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Requisition Details ",
      ));

      PaymentRequisitionRepository().getTransactionListDetails(
          transaction: transaction,
          onRequestSuccess: (result) =>
              {store.dispatch(TransactionDtlListFetchAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction saveRequisitionAction({
  int optionId,
  List<PaymentRequisitionDtlModel> requisitionItems,
  PaymentRequisitionHdrModel hdrModel,
  BSCModel defaultAnalysisCode,
  BSCModel defaultAnalysisType,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Requisition ",
      ));

      store.dispatch(uploadDocumentsAction((xml) {
        PaymentRequisitionRepository().saveRequisition(
            attachmentXml: xml,
            requisitionItems: requisitionItems,
            optionId: optionId,
            hdrModel: hdrModel,
            defaultAnalysisCode: defaultAnalysisCode,
            defaultAnalysisType: defaultAnalysisType,
            onRequestSuccess: () => store.dispatch(new RequisitionSaveAction()),
            onRequestFailure: (error) => store.dispatch(new LoadingAction(
                  status: LoadingStatus.error,
                  message: error.toString(),
                )));
      }));
    });
  };
}

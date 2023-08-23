import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/account_balance_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/process_from_fill_model.dart';
import 'package:redstars/src/services/repository/payment_voucher/payment_voucher_repository.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

class AddPaymentVoucherAction {
  PaymentVoucherDtlModel item;

  AddPaymentVoucherAction(this.item);
}

class CashAcctBalance {
  List<AccountBalance> cashAcctBalanceList;
  CashAcctBalance(this.cashAcctBalanceList);
}

class BudgetDetails {
  List<BudgetDtlModel> budgetDtl;
  BudgetDetails(this.budgetDtl);
}

class CurrencyExchangeFetchAction {
  List<CurrencyExchange> currencyEx;

  CurrencyExchangeFetchAction(this.currencyEx);
}

class ServiceListAction {
  List<ServiceList> serviceList;

  ServiceListAction(this.serviceList);
}

class OnEntrySave {
  PaymentVoucherHdrModel voucherHdrModel;

  OnEntrySave(this.voucherHdrModel);
}

class ClearActionOnChange {
  ClearActionOnChange();
}

class OnAccountBalance {
  List<AccountBalance> accountBalanceList;
  OnAccountBalance(this.accountBalanceList);
}

class OnCashierBalance {
  List<CashierBalance> cashierBalanceList;
  OnCashierBalance(this.cashierBalanceList);
}

class SavingModelVarAction {
  PVFilterModel filterModel;

  SavingModelVarAction({this.filterModel});
}

class ChangePaymentModeAction {
  String changedPaymentMode;
  ChangePaymentModeAction(this.changedPaymentMode);
}

class RemovePaymentVoucherAction {
  PaymentVoucherDtlModel item;

  RemovePaymentVoucherAction(this.item);
}

class POProcessFromFillAction {
  List<PurchaseOrderProcessFill> poFillResult;

  POProcessFromFillAction(this.poFillResult);
}

class ChangeHeaderFieldAction {
  PaymentRequisitionHdrModel hdrModel;

  ChangeHeaderFieldAction(this.hdrModel);
}

class VoucherPurchaseOrderListAction {
  List<VoucherPurchaseOder> voucherPurchaseList;

  VoucherPurchaseOrderListAction(this.voucherPurchaseList);
}

class PaymentVoucherConfigFetchAction {
  List<BCCModel> paymentFlowTypes;
  List<BCCModel> voucherTypes;
  List<BCCModel> voucherTypesRender;
  List<BCCModel> paidToTypeBccId;
  List<BCCModel> instrumentTypes;
  List<BSCModel> editableYnObj;
  List<BCCModel> paymentEntryProcessFromObj;
  List<BCCModel> paymentTypes;
  List<BCCModel> paidToTypes;
  List<BSCModel> analysisCodeObj;
  List<BSCModel> analysisCodeTypeObj;
  List<BCCModel> settlementTypes;

  PaymentVoucherConfigFetchAction(
      {this.paymentTypes,
      this.voucherTypesRender,
      this.voucherTypes,
      this.paymentFlowTypes,
      this.editableYnObj,
      this.instrumentTypes,
      this.paymentEntryProcessFromObj,
      this.paidToTypes,
      this.analysisCodeObj,
      this.paidToTypeBccId,
      this.analysisCodeTypeObj,
      this.settlementTypes});
}

class VoucherSaveAction {}

class TransactionDtlListFetchAction {
  List<ProcessFromDtlList> result;

  TransactionDtlListFetchAction(this.result);
}

ThunkAction fetchVoucherInitialData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));

      PaymentVoucherRepository().getInitialConfigs(
        onRequestSuccess: ({
          List<BCCModel> paymentFlowTypes,
          List<BCCModel> voucherTypes,
          List<BCCModel> voucherTypesRender,
          List<BCCModel> instrumentTypes,
          List<BSCModel> editableYnObj,
          List<BCCModel> paymentEntryProcessFromObj,
          List<BCCModel> paymentTypes,
          List<BCCModel> paidToTypes,
          List<BSCModel> analysisCodeObj,
          List<BSCModel> analysisCodeTypeObj,
          List<BCCModel> paidToTypeBccId,
          List<BCCModel> settlementTypes,
        }) =>
            store.dispatch(PaymentVoucherConfigFetchAction(
                paymentEntryProcessFromObj: paymentEntryProcessFromObj,
                paymentFlowTypes: paymentFlowTypes,
                paymentTypes: paymentTypes,
                instrumentTypes: instrumentTypes,
                voucherTypes: voucherTypes,
                paidToTypes: paidToTypes,
                analysisCodeObj: analysisCodeObj,
                analysisCodeTypeObj: analysisCodeTypeObj,
                voucherTypesRender: voucherTypesRender,
                paidToTypeBccId: paidToTypeBccId,
                settlementTypes: settlementTypes)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchBudgetDtl({int optionId, int accountId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Budget Details ",
      ));

      PaymentVoucherRepository().getBudget(
          optionId: optionId,
          accountId: accountId,
          onRequestSuccess: (result) => {store.dispatch(BudgetDetails(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchServiceList() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Service Details ",
      ));

      PaymentVoucherRepository().getService(
          onRequestSuccess: (result) =>
              {store.dispatch(ServiceListAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchCurrencyExchangeList() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Data",
        // type: "SALEINVOICE"
      ));

      PaymentVoucherRepository().getCurrencyExchange(
          onRequestSuccess: (response) =>
              store.dispatch(CurrencyExchangeFetchAction(response)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEINVOICE"
              )));
    });
  };
}

ThunkAction fetchCashierBalanceList(
    {int accountId, int analysisCodeId, int analysisCodeTypeId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Account Details ",
      ));

      PaymentVoucherRepository().getCashierBalance(
          accountId: accountId,
          analysisCodeId: analysisCodeId,
          analysisCodeTypeId: analysisCodeTypeId,
          onRequestSuccess: (result) =>
              {store.dispatch(OnCashierBalance(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchAccountBalanceList({int accountId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Account Details ",
      ));

      PaymentVoucherRepository().getAccountBalance(
          accountId: accountId,
          onRequestSuccess: (result) =>
              {store.dispatch(OnAccountBalance(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchCashAccountBalanceList({int accountId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Account Details ",
      ));

      PaymentVoucherRepository().getCashAccountBalance(
          accountId: accountId,
          onRequestSuccess: (result) =>
              {store.dispatch(CashAcctBalance(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchVoucherPurchaseList(
    {PVFilterModel filterRange, String transNo}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting  Details ",
      ));

      PaymentVoucherRepository().getVoucherPurchaseList(
          filterRange: filterRange,
          transNo: transNo,
          start: 0,
          onRequestSuccess: (result) =>
              {store.dispatch(VoucherPurchaseOrderListAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchVoucherPOFillDetails({int id}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data ",
      ));

      PaymentVoucherRepository().getProcessPOFillList(
          id: id,
          onRequestSuccess: (result) {
            store.dispatch(POProcessFromFillAction(result));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

// ThunkAction fetchTransactionListDetails(TransTypeLookupItem transaction) {
//   return (Store store) async {
//     new Future(() async {
//       store.dispatch(new LoadingAction(
//         status: LoadingStatus.loading,
//         message: "Getting Requisition Details ",
//       ));
//
//       PaymentRequisitionRepository().getTransactionListDetails(
//           transaction: transaction,
//           onRequestSuccess: (result) =>
//               {store.dispatch(TransactionDtlListFetchAction(result))},
//           onRequestFailure: (error) => store.dispatch(new LoadingAction(
//                 status: LoadingStatus.error,
//                 message: error.toString(),
//               )));
//     });
//   };
// }

ThunkAction saveVoucherAction({
  List<CurrencyExchange> currencyEx,
  List<PurchaseOrderProcessFill> poList,
  List<BCCModel> voucherTypes,
  List<BSCModel> analysisCodeType,
  List<BSCModel> analysisCode,
  List<BCCModel> paymentFlowTypes,
  List<BCCModel> paymentTypes,
  int optionId,
  List<PaymentVoucherDtlModel> acctDetails,
  PaymentVoucherHdrModel paymentVchModel,
  List<BCCModel> paidTotypeBccid,
  List<BCCModel> requesters,
  String paymentModeType,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Voucher ",
      ));

      store.dispatch(uploadDocumentsAction((xml) {
        PaymentVoucherRepository().saveVoucher(
            optionId: optionId,
            acctDetails: acctDetails,
            analysisCode: analysisCode,
            analysisCodeType: analysisCodeType,
            paymentFlowTypes: paymentFlowTypes,
            paymentVchModel: paymentVchModel,
            voucherTypes: voucherTypes,
            currencyEx: currencyEx,
            poList: poList,
            paymentTypes: paymentTypes,
            paidToTypeBccId: paidTotypeBccid,
            paymentMode: paymentModeType,
            requesters: requesters,
            onRequestSuccess: () => store.dispatch(new VoucherSaveAction()),
            onRequestFailure: (error) => store.dispatch(new LoadingAction(
                  status: LoadingStatus.error,
                  message: error.toString(),
                )));
      }));
    });
  };
}

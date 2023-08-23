import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/actions/requisition/payment_requisition/payment_requisition_action.dart';
import 'package:redstars/src/redux/states/requisition/payment_requisition/payment_requistion_state.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/tax_dtl_model.dart';

final paymentRequisitionReducer = combineReducers<PaymentRequisitionState>([
  TypedReducer<PaymentRequisitionState, LoadingAction>(
      _changeLoadingStatusAction),
  TypedReducer<PaymentRequisitionState, OnClearAction>(_clearAction),
  TypedReducer<PaymentRequisitionState, AddPaymentRequisitionAction>(
      _newItemAction),
  TypedReducer<PaymentRequisitionState, RemovePaymentRequisitionAction>(
      _removeItemAction),
  TypedReducer<PaymentRequisitionState, PaymentConfigFetchAction>(
      _transStatusAction),
  TypedReducer<PaymentRequisitionState, RequisitionSaveAction>(_saveAction),
  TypedReducer<PaymentRequisitionState, ProcessFromFillAction>(_fillAction),
  TypedReducer<PaymentRequisitionState, TransactionDtlListFetchAction>(
      _fillDtlAction),
  TypedReducer<PaymentRequisitionState, PaymentItemBudgetDetails>(
      _itemBudgetDtlAction),
  TypedReducer<PaymentRequisitionState, ChangeHeaderFieldAction>(
      _changeHdrAction),
  TypedReducer<PaymentRequisitionState, PaymentReqstnViewAction>(
      _paymentReqtnviewaction),
  TypedReducer<PaymentRequisitionState, SavingPaymentFilterAction>(
      _filterSaveAction),
  TypedReducer<PaymentRequisitionState, PaymentRequisitionDetailAction>(
      _paymentDetailFetchAction),
]);
BCCModel transactionType;
BCCModel requestFrom;
TransTypeLookupItem transNo;
ServiceLookupItem reqstFromName;
BCCModel paymentType;

PaymentRequisitionState _paymentDetailFetchAction(
    PaymentRequisitionState state, PaymentRequisitionDetailAction action) {
  state.requestTransactionTypes.forEach((element) {
    if (element.id == action.detailList.first.transtypebccid) {
      transactionType = element;
      return transactionType;
    }
    return transactionType;
  });
  state.requesters.forEach((element) {
    if (element.id == action.detailList.first.analysiscodetypeid) {
      requestFrom = element;
      return requestFrom;
    }
    return requestFrom;
  });
  state.paymentTypes.forEach((element) {
    if (element.id == action.detailList.first.paymenttypebccid &&
        element.description == action.detailList.first.paymenttype) {
      paymentType = element;
      return paymentType;
    }
    return paymentType;
  });
  transNo = TransTypeLookupItem(action.detailList.first.reftransno, 0,
      action.detailList.first.transreftabledataid);
  reqstFromName = ServiceLookupItem(action.detailList.first.analysisname);
  List<PaymentRequisitionDtlModel> payRstModel = [];
  for (int i = 0; i < action.detailList.first.requestDtlJson.length; i++) {
    PaymentRequisitionDtlModel dtlItem = PaymentRequisitionDtlModel(
      ledger: AccountLookupItem(
        accountid: action.detailList.first.requestDtlJson[i].accountid,
        description: action.detailList.first.requestDtlJson[i].accountname,
        aliasname: action.detailList.first.requestDtlJson[i].accountname,
        groupname: action.detailList.first.requestDtlJson[i].accountname,
      ),
      amount: action.detailList.first.requestDtlJson[i].amount,
      budget: BudgetDtlModel(
          accountid: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.accountid,
          branchid: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.branchid,
          budgetdate: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.budgetdate,
          actual:
              action.detailList.first.requestDtlJson[i].budgetDtl.first?.actual,
          remaining: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.remaining,
          inprocess: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.inprocess,
          budgeted: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.budgeted,
          departmentid: action
              .detailList.first.requestDtlJson[i].budgetDtl.first?.departmentid,
          itemid:
              action.detailList.first.requestDtlJson[i].budgetDtl.first?.id),
    );
    payRstModel.add(dtlItem);
  }
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    paymentDtlJson: action.detailList,
    stockId: 1,
    paymentHdr: PaymentRequisitionHdrModel(
        transactionType: transactionType,
        remarks: action.detailList.first.remarks,
        paidTo: action.detailList.first.paidto,
        requestFrom: requestFrom,
        requestFromName: reqstFromName,
        requestAmount: action.detailList.first.requestedamount,
        paymentType: paymentType,
        transNo: transNo,
        settleWithin: DateTime.parse(action.detailList.first.settlebefore)),
    paymentItems: payRstModel,
    paymentRequsitionItems: payRstModel,
    requisitionDtlRemarks: action.detailList.first.remarks,
  );
}

PaymentRequisitionState _filterSaveAction(
    PaymentRequisitionState state, SavingPaymentFilterAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      model: action.filterModel);
}

PaymentRequisitionState _changeLoadingStatusAction(
    PaymentRequisitionState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

PaymentRequisitionState _paymentReqtnviewaction(
    PaymentRequisitionState state, PaymentReqstnViewAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      paymentReqModel: action.paymentReqModel);
}

PaymentRequisitionState _itemBudgetDtlAction(
    PaymentRequisitionState state, PaymentItemBudgetDetails action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      paymentBudgetDtl: action.itembudgetDtl);
}

BudgetDtlModel itemBudget;

PaymentRequisitionState _newItemAction(
    PaymentRequisitionState state, AddPaymentRequisitionAction action) {
  itemBudget =
      state.paymentBudgetDtl != null ? state.paymentBudgetDtl.first : null;
  action.item.budget = itemBudget;
  List<PaymentRequisitionDtlModel> items = state.paymentItems;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatingItem = items[index];
    double revisedAmount = action.item.amount;
    var recalculatedTaxes = updatingItem.taxes?.map((e) {
          return TaxDetailModel(
            totalAmount: revisedAmount,
            taxedAmount: revisedAmount * e.taxDtl.taxperc / 100,
            tax: e.tax,
            taxDtl: e.taxDtl,
          );
        })?.toList() ??
        [];
    var updatedItem = updatingItem.copyWith(
      amount: revisedAmount,
      taxes: recalculatedTaxes,
    );
    items[index] = updatedItem;
    return state.copyWith(paymentItems: items);
  } else
    return state.copyWith(
      paymentItems: [action.item, ...items],
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
    );
}

PaymentRequisitionState _transStatusAction(
    PaymentRequisitionState state, PaymentConfigFetchAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    requesters: action.reqFromModel,
    requestTransactionTypes: action.reqTransTypeModel,
    requestProcessType: action.reqProcessTypeModel,
    taxConfigs: action.taxConfigs,
    paymentTypes: action.paymentModel,
    settlements: action.settleWithin,
    analysisCode: action.analysisCode,
    analysisType: action.analysisType,
  );
}

PaymentRequisitionState _saveAction(
    PaymentRequisitionState state, RequisitionSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PaymentRequisitionState _clearAction(
    PaymentRequisitionState state, OnClearAction action) {
  return PaymentRequisitionState.initial().copyWith(
    paymentTypes: state.paymentTypes,
    settlements: state.settlements,
    requestProcessType: state.requestProcessType,
    requesters: state.requesters,
    requestTransactionTypes: state.requestTransactionTypes,
    analysisCode: state.analysisCode,
    analysisType: state.analysisType,
    taxConfigs: state.taxConfigs,
  );
}

PaymentRequisitionState _removeItemAction(
    PaymentRequisitionState state, RemovePaymentRequisitionAction action) {
  List<PaymentRequisitionDtlModel> items = state.paymentItems;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(
      paymentItems: items,
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
    );
  }
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PaymentRequisitionState _fillAction(
    PaymentRequisitionState state, ProcessFromFillAction action) {
  BCCModel requester = state.requesters.firstWhere(
      (element) => element.id == action.result.requestFromTypeBccId,
      orElse: () => null);

  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      paymentHdr: state.paymentHdr.copyWith(
          requestFromName: action.result,
          requestFrom: requester,
          paidTo: action.result.name));
}

PaymentRequisitionState _changeHdrAction(
    PaymentRequisitionState state, ChangeHeaderFieldAction action) {
  return state.copyWith(
    paymentHdr: action.hdrModel,
    paymentItems: [],
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PaymentRequisitionState _fillDtlAction(
    PaymentRequisitionState state, TransactionDtlListFetchAction action) {
  var detail = action.result;

  List<PaymentRequisitionDtlModel> details = detail.map((element) {
    return PaymentRequisitionDtlModel(
      ledger: AccountLookupItem.fromOther(
        accountid: element.accountId,
        aliasname: element.accountName,
        groupname: element.value,
        attributeId: element.attributeId,
        attributeValueRefId: element.attributeValueRefId,
      ),
      amount: element.amount,
      itemGroup: element.value,
      actual: element.actual,
      budgeted: element.budgeted,
      remaining: element.remaining,
      taxApplicable: false,
    );
  }).toList();

  return state.copyWith(
    paymentItems: details,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/requisition/payment_requisition/payment_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/requisition/payment_requisition/payment_requistion_state.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_reqst_detail.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_view_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

import '../../../../../utility.dart';

class PaymentRequisitionViewModel extends BaseViewModel {
  final List<BCCModel> paymentTypes;
  final List<BSCModel> settlements;
  final List<BSCModel> defaultAnalysisCode;
  final List<BSCModel> defaultAnalysisType;
  final List<BCCModel> requestProcessType;
  final List<BCCModel> requesters;
  final List<BCCModel> requestTransactionTypes;

  final Function(PaymentRequisitionDtlModel) onAdd;
  final Function(int, PaymentRequisitionHdrModel,
      List<PaymentRequisitionDtlModel>, BSCModel, BSCModel) onSave;
  final List<PaymentRequisitionDtlModel> requisitionItems;

  final List<TransactionStatusItem> status;
  final VoidCallback onClear;
  final int optionId;
  final ValueSetter<PaymentRequisitionDtlModel> onRemoveItem;
  final ValueSetter<TransTypeLookupItem> getTransactionDetails;
  final PaymentRequisitionHdrModel paymentHdr;
  final Function(PaymentRequisitionHdrModel) setField;
  final List<TaxConfigModel> taxConfigs;
  final bool isSaved;

  final double totalBooking;
  final double totalRequestedAmount;
  final double vatAmount;
  final double withHoldingTaxAmount;

  final bool isTransactionSelected;
  final List<BudgetDtlModel> paymentItemBudgetDtl;
  final PaymentListModel paymentReqModel;

  final Function(AccountLookupItem) onItemPaymentBudget;

  final Function() changeLoadingAction;
  final PVFilterModel model;
  final Function(PVFilterModel result, int start, double position,
      List<PaymentListview> list) onFilterSubmit;

  final Function(PVFilterModel model) onFilter;
  final Function(PVFilterModel model) onSubmitCall;
  final double scrollPosition;
  final int stockId;
  final List<PaymentDetailViewList> paymentDtlJson;
  final Function(PaymentListview paymentList, PVFilterModel model)
      onGetDtlJsonData;
  final String payDtlRemarks;

  PaymentRequisitionViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.onSubmitCall,
    this.payDtlRemarks,
    this.paymentDtlJson,
    this.paymentReqModel,
    this.scrollPosition,
    this.paymentItemBudgetDtl,
    this.onItemPaymentBudget,
    this.changeLoadingAction,
    this.isTransactionSelected,
    this.onAdd,
    this.isSaved,
    this.onSave,
    this.requisitionItems,
    this.status,
    this.optionId,
    this.onRemoveItem,
    this.onClear,
    this.paymentTypes,
    this.settlements,
    this.requestProcessType,
    this.requesters,
    this.requestTransactionTypes,
    this.getTransactionDetails,
    this.paymentHdr,
    this.setField,
    this.taxConfigs,
    this.totalBooking,
    this.totalRequestedAmount,
    this.vatAmount,
    this.withHoldingTaxAmount,
    this.defaultAnalysisCode,
    this.defaultAnalysisType,
    this.model,
    this.onFilter,
    this.onFilterSubmit,
    this.stockId,
    this.onGetDtlJsonData,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory PaymentRequisitionViewModel.fromStore(Store<AppState> store) {
    PaymentRequisitionState state =
        store.state.requisitionState.paymentRequisitionState;
    var optionId = store.state.homeState.selectedOption.optionId;

    double totalBooking = 0;
    double vatAmount = 0;
    double totalRequestedAmount = 0;
    double withHoldingTaxAmount = 0;
    state.paymentItems.forEach((element) {
      totalBooking += element.amount;
      element.taxes?.forEach((dtlTax) {
        if (dtlTax.tax.effectonparty > 0)
          vatAmount += dtlTax.taxedAmount;
        else
          withHoldingTaxAmount += dtlTax.taxedAmount;
      });
    });
    totalRequestedAmount = totalBooking + vatAmount - withHoldingTaxAmount;
    return PaymentRequisitionViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        paymentTypes: state.paymentTypes,
        settlements: state.settlements,
        paymentItemBudgetDtl: state.paymentBudgetDtl,
        requestProcessType: state.requestProcessType,
        requesters: state.requesters,
        requestTransactionTypes: state.requestTransactionTypes,
        // requisitionItems: state.paymentRequsitionItems,
        requisitionItems: state.paymentItems.isNotEmpty && state.stockId == 0
            ? state.paymentItems
            : state.paymentRequsitionItems,
        optionId: optionId,
        isSaved: state.saved,
        payDtlRemarks: state.requisitionDtlRemarks,
        paymentDtlJson: state.paymentDtlJson,
        paymentHdr: state.paymentHdr,
        paymentReqModel: state.paymentReqModel,
        scrollPosition: state.scrollPosition,
        stockId: state.stockId,
        isTransactionSelected: state.paymentHdr?.transNo != null &&
            state.paymentHdr.transNo.nettotal > 0,
        totalBooking: totalBooking,
        totalRequestedAmount: totalRequestedAmount,
        vatAmount: vatAmount,
        withHoldingTaxAmount: withHoldingTaxAmount,
        defaultAnalysisCode: state.analysisCode,
        defaultAnalysisType: state.analysisType,
        onSubmitCall: (filter) {
          store.dispatch(fetchPaymentViewListData(
              listData: [],
              start: 0,
              optionId: optionId,
              sor_id: state.paymentReqModel?.SOR_Id ?? null,
              eor_id: state.paymentReqModel?.EOR_Id ?? null,
              totalrecords: state.paymentReqModel?.totalRecords ?? null,
              filterModel: PVFilterModel(
                  fromDate: filter?.fromDate,
                  toDate: filter?.toDate,
                  reqNo: filter?.reqNo,
                  amountFrom: filter?.amountFrom,
                  amountTo: filter?.amountTo,
                  transactionType: filter?.transactionType,
                  transNo: filter?.transNo)));
        },
        onFilterSubmit: (result, start, position, list) {
          print("start----$start");
          store.dispatch(fetchPaymentViewListData(
              listData: list,
              start: start,
              optionId: optionId,
              sor_id: state.paymentReqModel?.SOR_Id ?? null,
              eor_id: state.paymentReqModel?.EOR_Id ?? null,
              totalrecords: state.paymentReqModel?.totalRecords ?? null,
              filterModel: PVFilterModel(
                  fromDate: result?.fromDate,
                  toDate: result?.toDate,
                  reqNo: result?.reqNo,
                  amountFrom: result?.amountFrom,
                  amountTo: result?.amountTo,
                  transactionType: result?.transactionType,
                  transNo: result?.transNo)));
        },
        onGetDtlJsonData: (resultList, model) {
          store.dispatch(fetchPaymentRequestDetailFetchAction(
              optionId: optionId,
              sor_id: resultList.SOR_Id,
              eor_id: resultList.EOR_Id,
              totalrecords: resultList.totalrecords,
              start: 0,
              //resultList.start,
              listData: resultList,
              filterModel: model));
        },
        onFilter: (model) {
          store.dispatch(SavingPaymentFilterAction(filterModel: model));
        },
        onItemPaymentBudget: (account) {
          return store.dispatch(fetchPaymentItemBudgetDtl(
              optionId: optionId, accId: account.accountid));
        },
        changeLoadingAction: () {
          store.dispatch(LoadingAction(
              status: LoadingStatus.success, message: "", type: ""));
        },
        model: state.model,
        onSave: (optionId, hdrModel, items, analysisCode, analysisType) {
          store.dispatch(saveRequisitionAction(
              optionId: optionId,
              hdrModel: hdrModel,
              requisitionItems: items,
              defaultAnalysisType: analysisType,
              defaultAnalysisCode: analysisCode));
        },
        taxConfigs: state.taxConfigs,
        onClear: () => store.dispatch(OnClearAction()),
        getTransactionDetails: (transaction) =>
            store.dispatch(fetchTransactionFillDetails(transaction)),
        setField: (hdrModel) =>
            store.dispatch(ChangeHeaderFieldAction(hdrModel)),
        onRemoveItem: (item) =>
            store.dispatch(RemovePaymentRequisitionAction(item)),
        onAdd: (model) => store.dispatch(AddPaymentRequisitionAction(model)));
  }
  void onLoadMore(
      PVFilterModel model,
      int start,
      double position,
      // PurchaseViewListModel list
      List<PaymentListview> list) {
    print("start---$start");
    onFilterSubmit(model, start, position, list);
  }

  int departId;
  Future<int> depat() async {
    departId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    print(departId);
    return departId;
  }

  String validateSave() {
    var id = depat();
    String message = "";
    bool valid = true;
    //  var  departId= BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);

    if (valid) {
      if (id == null) {
        message = "User has no department.";
        valid = false;
      }
    }

    return message;
  }

  void saveRequisition({
    String remarks,
  }) {
    paymentHdr.requestAmount = totalRequestedAmount;
    paymentHdr.remarks = remarks;

    onSave(optionId, paymentHdr, requisitionItems, defaultAnalysisCode.first,
        defaultAnalysisType.first);
  }
}

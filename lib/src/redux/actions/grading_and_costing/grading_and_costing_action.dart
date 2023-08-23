import 'package:base/redux.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grade_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_detail_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/repository/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

class AddGradeAction {
  GradeModel item;

  AddGradeAction(this.item);
}

class EditGradeAction {
  GradeModel item;

  EditGradeAction(this.item);
}

class RemoveGradeAction {
  GradeModel item;

  RemoveGradeAction(this.item);
}

class ItemDetailClearAction {}

class GINFilterModelFetchAction {
  GINFilterModel ginFilterModel;

  GINFilterModelFetchAction(this.ginFilterModel);
}

class GradingViewListFetchAction {
  GradingViewListModel gradingViewListModel;

  GradingViewListFetchAction(this.gradingViewListModel);
}

class GradeListFetchAction {
  List<GradeLookupItem> grades;
  GradeListFetchAction(this.grades);
}

class GradingViewListDetailFetchAction {
  GradingCostingViewDetailModel gradingCostingViewDetailModel;

  GradingViewListDetailFetchAction(this.gradingCostingViewDetailModel);
}

class GradeRateFetchAction {
  List<GradeRateList> gradeRate;

  GradeRateFetchAction(this.gradeRate);
}

class CurrencyExchangeFetchAction {
  List<CurrencyExchange> currencyEx;

  CurrencyExchangeFetchAction(this.currencyEx);
}

class DataFetchAction {
  List<ProcessFromGinList> refreshGinList;
  DataFetchAction(this.refreshGinList);
}

// class DataFilterAction {
//   List<GardingViewList> gradingViewList;
//   DataFilterAction(this.gradingViewList);
// }

class GINFilterViewListSaveAction {
  GINFilterModel ginFilterModel;

  GINFilterViewListSaveAction({this.ginFilterModel});
}

class GradingFillDataFetchAction {
  List<ProcessFillGradingList> gradingList;

  GradingFillDataFetchAction(this.gradingList);
}

class GradingSaveAction {}

class ProcessFromGINListFetchAction {
  List<ProcessFromGinList> processFromGinList;

  ProcessFromGINListFetchAction(this.processFromGinList);
}

ThunkAction editSaveGradingAction({
  int optionId,
  GradingCostingViewDetailModel gclist,
  List<ProcessFillGradingList> gradingList,
  List<CurrencyExchange> currencyExchange,
  List<GradeModel> gradeModel,
  List<ItemDetailModel> itemDtl,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Data ",
      ));

      GradingCostingRepository().editSaveGradingCosting(
        gclist: gclist,
        currencyEx: currencyExchange,
        gradingList: gradingList,
        optionId: optionId,
        gradeModel: gradeModel,
        itemDtl: itemDtl,
        onRequestSuccess: () => store.dispatch(new GradingSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGrades() {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GradingCostingRepository().getGrades(
        onRequestSuccess: (grade) =>
            store.dispatch(new GradeListFetchAction(grade)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchItemGradeRate({int itemId, int gradeId}) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GradingCostingRepository().getGradeRate(
        gradeId: gradeId,
        itemId: itemId,
        onRequestSuccess: (grade) =>
            store.dispatch(new GradeRateFetchAction(grade)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchInitialData({GINFilterModel filterModel}) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GradingCostingRepository().getRefreshList1(
        filterData: filterModel,
        onRequestSuccess: (processFormList) =>
            store.dispatch(new ProcessFromGINListFetchAction(processFormList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchRefreshData({GINFilterModel filterModel}) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading list",
      ));
      GradingCostingRepository().getRefreshList(
        filterData: filterModel,
        onRequestSuccess: (processFormList) =>
            store.dispatch(new DataFetchAction(processFormList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

// ThunkAction fetchFilterData({GINFilterModel filterModel}) {
//   return (Store store) async {
//     new Future(() async {
//       print("hello");
//       store.dispatch(new LoadingAction(
//         status: LoadingStatus.loading,
//         message: "Loading list",
//       ));
//
//       GradingCostingRepository().getFilterList(
//         filterData: filterModel,
//         onRequestSuccess: (gradingViewListResult) =>
//             store.dispatch(new DataFilterAction(gradingViewListResult)),
//         onRequestFailure: (error) => store.dispatch(new LoadingAction(
//           status: LoadingStatus.error,
//           message: error.toString(),
//         )),
//       );
//     });
//   };
// }

ThunkAction fetchGradingViewList(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int option_Id,
    GINFilterModel ginFilterModel,
    List<GardingViewList> listdata}) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading list",
      ));
      GradingCostingRepository().getGradingViewList(
        filterModel: ginFilterModel,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        start: start,
        option_Id: option_Id,
        onRequestSuccess: (result) {
          sor_Id = result.SOR_Id;
          eor_Id = result.EOR_Id;
          totalRecords = result.totalRecords;
          listdata?.addAll(result.gradingViewList);
          store.dispatch(new GradingViewListFetchAction(result));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGradingViewListDetail(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int option_Id,
    GardingViewList id,
    GINFilterModel ginFilterModel}) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading list",
      ));
      GradingCostingRepository().getGradingViewListDetail(
        filterModel: ginFilterModel,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        start: 0,
        gdModelView: id,
        option_Id: option_Id,
        onRequestSuccess: (result) =>
            store.dispatch(new GradingViewListDetailFetchAction(result)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGradingListData(int ginId) {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading GIN List",
      ));
      GradingCostingRepository().getProcessGINFillList(
        id: ginId,
        onRequestSuccess: (processFillList) =>
            store.dispatch(new GradingFillDataFetchAction(processFillList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
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

      GradingCostingRepository().getCurrencyExchange(
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

ThunkAction saveGradingAction({
  int optionId,
  List<ProcessFillGradingList> gradingList,
  List<CurrencyExchange> currencyExchange,
  List<GradeModel> gradeModel,
  List<ItemDetailModel> itemDtl,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Data ",
      ));

      GradingCostingRepository().saveGradingCosting(
        currencyEx: currencyExchange,
        gradingList: gradingList,
        optionId: optionId,
        gradeModel: gradeModel,
        itemDtl: itemDtl,
        onRequestSuccess: () => store.dispatch(new GradingSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

class SavingModelVarAction {
  GINFilterModel filters;

  SavingModelVarAction({this.filters});
}

class SavingFilterAction {
  GINFilterModel filterModel;

  SavingFilterAction({this.filterModel});
}

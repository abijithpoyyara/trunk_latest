import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/services/repository/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/grading_list_detail_view.dart';
import 'package:redstars/utility.dart';

import 'helper/gc_view_list_filter.dart';

class GCostingListView extends StatefulWidget {
  final GradingCostingViewModel viewmodel;

  const GCostingListView({
    Key key,
    this.viewmodel,
  }) : super(key: key);

  @override
  _GCostingListViewState createState() => _GCostingListViewState();
}

class _GCostingListViewState extends State<GCostingListView> {
  int sor_id, eor_id, totalRecords = 1, limit, start;

  ScrollController _controller;
  bool _isLoading;

  List<GardingViewList> gradingViewListResult = [];

  @override
  void initState() {
    super.initState();
    // purchaseListData = List();
    start = 0;
    _isLoading = false;
    limit = 10;
    _loadItems(initLoad: true);
    _controller = ScrollController(
      initialScrollOffset: widget.viewmodel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_isLoading) _loadItems();
      }
    });
  }

  List<GardingViewList> data1 = [];
  _loadItems({bool initLoad = false}) async {
    setState(() {
      _isLoading = true;
      if (initLoad) start = 0;
    });
    await GradingCostingRepository().getGradingViewList(
        filterModel: widget.viewmodel.ginFilterModel,
        option_Id: widget.viewmodel.option_Id,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                gradingViewListResult = [];
                _isLoading = false;
                eor_id = null;
                sor_id = null;
                totalRecords = null;
                start = null;
              })
            },
        onRequestSuccess: (result) => setState(() {
              _isLoading = false;
              if (initLoad) {
                print("purchase----${gradingViewListResult.length}");
                data1 = result.gradingViewList;
                gradingViewListResult = result.gradingViewList;
              } else {
                gradingViewListResult.addAll(result.gradingViewList);
                print("purchase----${result.gradingViewList.length}");
                eor_id = result.SOR_Id;
                sor_id = result.EOR_Id;
                totalRecords = result.totalRecords;
                // start += limit;
                // setState(() {
                //   gradingViewListResult = data1;
                // });
              }
            }));
  }
  // _loadItems({
  //   bool initLoad = false,
  // }) async {
  //   setState(() {
  //     _isLoading = true;
  //     if (initLoad) start = 0;
  //     start += 10;
  //   });
  //   var _scrollPosition = _controller.position.pixels;
  //   widget.viewmodel.onLoadMore(
  //       widget.viewmodel.model, start, _scrollPosition, purchaseListData);
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, GradingCostingViewModel>(
        init: (store, context) {
          final state = store.state.gradingCostingState;
          // store.dispatch(fetchInitialData(filterModel: state.ginFilterModel));
          store.dispatch(fetchRefreshData(filterModel: state.ginFilterModel));
          //   // store.dispatch(fetchFilterData(filterModel: state.currentFilters));
          //   // store.dispatch(fetchUomData());
          store.dispatch(fetchGradingViewList(
            listdata: gradingViewListResult,
            start: 0,
            option_Id: store.state.homeState.selectedOption.optionId,
            ginFilterModel: GINFilterModel(
              fromDate: state.fromDate,
              toDate: state.toDate,
              transNo: "",
              supplier: null,
            ),
          ));
          //   //   // listData: purchaseListData
          //   // ));
          // },
          // onDidChange: (viewModel, context) {
          //   if (viewModel.detailPurchaseModelData != null) Navigator.pop(context);
        },
        converter: (store) => GradingCostingViewModel.fromStore(store),
        builder: (context, viewModel) {
          print("length---- ${gradingViewListResult.length}");
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Date filter",
              child: Icon(
                Icons.filter_list,
                color: themeData.primaryColorDark,
              ),
              onPressed: ()
                  // async
                  {
                showDialog(
                  context,
                  viewModel.ginFilterModel,
                  viewModel,
                  viewModel.scrollPosition,
                );
              },
            ),
            appBar: BaseAppBar(
              title: Text("Grading and Costing"),
            ),
            body: gradingViewListResult != null &&
                    gradingViewListResult.isNotEmpty
                // viewModel.processGinList.length !=0
                ? ListView.builder(
                    itemCount: gradingViewListResult.length,
                    controller: _controller,
                    itemBuilder: (context, int index) {
                      // return  Text('${viewModel.processGinList[index].supplierid}');
                      return GestureDetector(
                        onTap: () {
                          viewModel.onGradingCostDetailView(
                            viewModel.gradingViewListModel,
                            gradingViewListResult[index],
                            GINFilterModel(
                                fromDate: viewModel.ginFilterModel.fromDate,
                                toDate: viewModel.ginFilterModel.toDate),
                          );
                          BaseNavigate(
                              context,
                              GradingCostingDetailView(
                                processedData: gradingViewListResult[index],
                                viewModel: viewModel,
                              ));
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(9),
                              margin: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              height: height * .15,
                              width: width,
                              decoration: BoxDecoration(
                                  color: themeData.primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            gradingViewListResult[index]
                                                    .ginno ??
                                                "",
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                          gradingViewListResult[index]
                                                  .gindate ??
                                              "",
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                    gradingViewListResult[index].suppliername ??
                                        "",
                                  )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                    gradingViewListResult[index].transno ?? "",
                                  ))
                                ],
                              ),
                            ),
                            Positioned(
                                right: width * .02,
                                child: CircleAvatar(
                                  backgroundColor:
                                      gradingViewListResult[index].status ==
                                              "Approved"
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                  child: gradingViewListResult[index].status ==
                                          "Approved"
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                      : Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                )),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("No List to Show"),
                  ),
            // onDispose: (store) => store.dispatch(ItemDetailClearAction()),
          );
        });
  }

  showDialog(
    BuildContext context,
    GINFilterModel model,
    GradingCostingViewModel viewModel,
    double position,
    //  List<PurchaseViewList> plist
  ) async {
    start = 0;
    // sor_id = sor_id;
    // eor_id = eor_id;
    // totalRecords = totalRecords;
    GINFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: GCFilterDialog(
          viewModel: viewModel,
          model: viewModel.ginFilterModel,
        ));
    // purchaseListData = [];
    gradingViewListResult = [];
    viewModel.onFilterSubmit(resultSet, start, position, gradingViewListResult);
    // viewModel.saveModelVar(resultSet);
    // setState(() {
    //
    // });
    // Navigator.pop(context, model);
  }
}

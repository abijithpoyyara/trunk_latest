import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/requisition/stock_requisition/stock_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_view_model.dart';
import 'package:redstars/src/services/repository/requisition/stock_requisition/stock_requisition_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/partials/stock_requisition_filter_dialog.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/stock_requisition_view.dart';

class SRListView extends StatefulWidget {
  final StockRequisitionViewModel viewmodel;
  const SRListView({
    Key key,
    this.viewmodel,
  }) : super(key: key);

  @override
  _SRListViewState createState() => _SRListViewState();
}

class _SRListViewState extends State<SRListView> {
  int sor_id, eor_id, totalRecords = 1, start = 0, limit;
//  ScrollController _controller;
  ScrollController _controller = new ScrollController();
  bool _isLoading;
  // int limit = 10;
  List<StockViewList> resultData = [];
  List<StockViewList> data = [];
  String stockStatus = "";

  @override
  void initState() {
    super.initState();
    resultData = [];
    data = [];
    start = 0;
    limit = 10;
    _isLoading = false;
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

  _loadItems({bool initLoad = false}) async {
    setState(() {
      _isLoading = false;
      if (initLoad) start = 0;
    });
    await StockRequisitionRepository().getStockView(
        filterModel: widget.viewmodel?.model,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                resultData = [];
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
                print("purchase----${resultData.length}");
                data = result.stockViewList;
                resultData = result.stockViewList;
              } else {
                resultData.addAll(result.stockViewList);
                print("purchase----${result.stockViewList.length}");
                eor_id = result.SOR_Id;
                sor_id = result.EOR_Id;
                totalRecords = result.TotalRecords;
                // start += limit;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BaseView<AppState, StockRequisitionViewModel>(
        init: (store, context) {
          final state = store.state.requisitionState.stockRequisitionState;
          store.dispatch(fetchStockViewListData(
            listData: resultData,
            start: 0,
            filterModel:
                SRFilterModel(fromDate: state.fromDate, toDate: state.toDate
                    // reqNo: ""
                    ),
            // listData: stockViewList
          ));
        },
        converter: (store) => StockRequisitionViewModel.fromStore(store),
        builder: (context, viewModel) {
          //  listData.addAll(viewModel.purchaseViewList);
          // print("total records---- ${purchaseListData.length}");
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Date filter",
              child: Icon(
                Icons.filter_list,
                color: themeData.primaryColorDark,
              ),
              onPressed: () {
                showDialog(
                  context,
                  viewModel.model,
                  viewModel,
                  viewModel.scrollPosition,
                );
              },
            ),
            appBar: BaseAppBar(
              title: Text("Requisitions"),
            ),
            body: resultData != null && resultData.isNotEmpty
                ? ListView.builder(
                    itemCount: resultData.length,
                    controller: _controller,
                    itemBuilder: (context, int pos) {
                      return GestureDetector(
                        onTap: () {
                          viewModel.onStockView(
                              resultData[pos],
                              SRFilterModel(
                                  fromDate: viewModel.model.fromDate));
                          stockStatus = resultData[pos].status;
                          Navigator.pop(context, stockStatus);
                          StockRequisitionView();
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
                                        Text(resultData[pos].requestno,
                                            // ??
                                            // viewModel.stockViewListModel
                                            //     .stockViewList[pos].requestno,
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                          resultData[pos].requestdate,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                    resultData[pos].targetlocation,
                                  )),
                                  SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                            ),
                            // if (!_isLoading)
                            Positioned(
                                right: width * .02,
                                child: CircleAvatar(
                                  backgroundColor:
                                      resultData[pos].status == "APPROVED"
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                  child: resultData[pos].status == "APPROVED"
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
          );
        });
  }

  showDialog(
    BuildContext context,
    SRFilterModel model,
    StockRequisitionViewModel viewModel,
    double position,
  ) async {
    start = 0;

    SRFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: SRFilterDialog(
          viewModel: viewModel,
          model: model,
        ));
    resultData = [];
    viewModel.onSRFilterSubmit(resultSet, start, position, resultData);
  }
}

class StockEmptyResultView extends StatelessWidget {
  const StockEmptyResultView({
    Key key,
    this.message = "No results",
    this.icon = Icons.equalizer,
    this.onRefresh,
  }) : super(key: key);

  final String message;
  final IconData icon;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    final ThemeData themeData = ThemeProvider.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //  SizedBox(height: height*.25,),
            Expanded(
              child: Icon(
                icon,
                color: BaseColors.of(context).accentColor,
                size: height * 1 / 18,
              ),
            ),
            //  const SizedBox(height: 8.0),
            Expanded(
                child: Text(
              message,
              style: theme.body2MediumHint.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            )),

            //  SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themeData.primaryColorDark,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh")),
          ]),
    );
  }
}

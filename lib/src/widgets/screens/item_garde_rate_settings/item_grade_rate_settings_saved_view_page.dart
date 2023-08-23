import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_page_model.dart';
import 'package:redstars/src/services/repository/item_grade_rate_settings/item_grade_rate_settings_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';

import 'Item_grade_rate_filter_dialog.dart';
import 'item_grade_rate_settings_view.dart';

class ItemGradeRateSetViewPage extends StatefulWidget {
  final ItemGradeRateViewModel viewModel;

  const ItemGradeRateSetViewPage({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _ItemGradeRateSetViewPageState createState() =>
      _ItemGradeRateSetViewPageState();
}

class _ItemGradeRateSetViewPageState extends State<ItemGradeRateSetViewPage> {
  int sor_id, eor_id, totalRecords = 1, start = 0, limit;
  ScrollController _controller = new ScrollController();
  bool _isLoading;
  List<ItemGradeRateSettingsViewPageList> resultData = [];
  List<ItemGradeRateSettingsViewPageList> data = [];
  String approvalStatus = "";

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
      initialScrollOffset: widget.viewModel?.scrollPosition ?? 0,
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

    await ItemGradeRateSettingsRepository().getItemRateViewListDate(
        optionId: widget.viewModel.optionId,
        itemGradeRateSettingsFilterModel: ItemGradeRateSettingsFilterModel(
            fromDate: widget.viewModel.toDate,
            toDate: widget.viewModel.frmDate,
            locObj: widget.viewModel.selectedLocation,
            datas: widget.viewModel.changedItems,
            pricingNo: ""),
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
                data = result.itemGradeRateSettingsViewPage;
                resultData = result.itemGradeRateSettingsViewPage;
              } else {
                resultData.addAll(result.itemGradeRateSettingsViewPage);
                print(
                    "purchase----${result.itemGradeRateSettingsViewPage.length}");
                eor_id = result.SOR_Id;
                sor_id = result.EOR_Id;
                totalRecords = result.TotalRecords;
                // start += limit;
              }
            }));

    // widget.viewModel.onClickSubms(
    //     ItemGradeRateSettingsFilterModel(
    //         toDate: widget.viewModel.frmDate,
    //         fromDate: widget.viewModel.toDate,
    //         locObj: widget.viewModel.selectedLocation),
    //     initLoad ? 0 : start + 10,
    //     initLoad
    //         ? widget?.viewModel?.viewPageModel?.itemGradeRateSettingsViewPage
    //         : resultData);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BaseView<AppState, ItemGradeRateViewModel>(
        converter: (store) => ItemGradeRateViewModel.fromStore(store),
        // init: (store, context) {
        //   final state = store.state.itemGradeRateState;
        //   store.dispatch(fetchItemGradeRateSettingsViewPageListData(
        //       optionId: state?.optionId ?? 795,
        //       start: 0,
        //       listData: [],
        //       filterModel: ItemGradeRateSettingsFilterModel(
        //           toDate: state.frmDate,
        //           fromDate: state.toDate,
        //           locObj: state.selectedLocation)));
        // },
        builder: (context, viewModel) {
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
                  viewModel.filterModel,
                  viewModel,
                  viewModel.scrollPosition,
                );
              },
            ),
            appBar: BaseAppBar(
              title: Text("Item Grade Rate Settings - View"),
            ),
            body: resultData != null && resultData.isNotEmpty
                ? ListView.builder(
                    itemCount: resultData.length,
                    controller: _controller,
                    itemBuilder: (context, int pos) {
                      return GestureDetector(
                        onTap: () {
                          // BaseNavigate(context, ItemGradeRateView());
                          viewModel.onPendingItemGradeRateTap(resultData[pos]);
                          // viewModel.onStockView(
                          //     resultData[pos],
                          //     SRFilterModel(
                          //         fromDate: viewModel.model.fromDate));
                          approvalStatus = resultData[pos].apprvlstatus;
                          Navigator.pop(context, approvalStatus);
                          ItemGradeRateView();
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
                                        Text(resultData[pos]?.pricingno ?? "",
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                          resultData[pos]?.pricingwefdate ?? "",
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          resultData[pos]?.businesssublevel ??
                                              "",
                                        ),
                                        Text(
                                          resultData[pos]?.createduser ?? "",
                                        ),
                                      ],
                                    ),
                                  ),
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
                                      resultData[pos].apprvlstatus == "Pending"
                                          ? Colors.red
                                          : Colors.green,
                                  radius: 10,
                                  child:
                                      resultData[pos].apprvlstatus == "Pending"
                                          ? Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                              size: 12,
                                            )
                                          : Icon(
                                              Icons.check,
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
    ItemGradeRateSettingsFilterModel model,
    ItemGradeRateViewModel viewModel,
    double position,
  ) async {
    start = 0;

    ItemGradeRateSettingsFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: ItemGradeRateFilterDialog(
          viewModel: viewModel,
          model: model,
        ));
    resultData = [];
    viewModel.onClickSubms(resultSet, start, resultData);
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

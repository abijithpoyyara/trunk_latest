import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/helper/filter_view.dart';

import '../../../../utility.dart';
import 'grading_costing_detail_view.dart';
import 'grading_list_view.dart';

class ProcessListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return BaseView<AppState, GradingCostingViewModel>(
      init: (store, con) {
        final state = store.state.gradingCostingState;
        store.dispatch(fetchInitialData(filterModel: state.currentFilters));
        store.dispatch(fetchRefreshData(filterModel: state.currentFilters));
        store.dispatch(fetchGrades());
        // store.dispatch(fetchCurrencyExchangeList());
      },
      converter: (store) => GradingCostingViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: BaseAppBar(
            title: Text("Goods Inspection Note - Khat"),
            actions: [
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  BaseNavigate(
                      context,
                      GCostingListView(
                        viewmodel: viewModel,
                      ));
                  // viewModel.onGetGradingViewList(GINFilterModel(
                  //     fromDate: DateTime(
                  //         DateTime.now().year, DateTime.now().month, 1),
                  //     toDate: DateTime.now())
                  //  );
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              GINFilterModel result = await appShowChildDialog<GINFilterModel>(
                  context: context,
                  child: FilterDialog(
                      viewModel: viewModel,
                      model: GINFilterModel(
                        fromDate: viewModel.newFromDate,
                        toDate: viewModel.newToDate,
                        supplier: viewModel.selectedSupplier,
                      )));
              viewModel.saveModelVar(result);
            },
            child: Icon(
              Icons.filter_list,
              color: themeData.primaryColorDark,
            ),
          ),
          body: viewModel.refreshGinList != null &&
                  viewModel.refreshGinList.isNotEmpty
              ? ListContent1(
                  viewModel: viewModel,
                )
              : EmptyResultView1(
                  message: "No list to show ",
                  onRefresh: () {
                    viewModel.onRefresh();
                  },
                ),
        );
      },
      onDispose: (store) => store.dispatch(ItemDetailClearAction()),
    );
  }
}

class EmptyResultView1 extends StatelessWidget {
  const EmptyResultView1({
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
    final ThemeData themedata = ThemeProvider.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: BaseColors.of(context).accentColor,
              size: height * 1 / 18,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.body2MediumHint.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themedata.primaryColorDark,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh")),
            SizedBox(
              height: height * .35,
            )
          ]),
    );
  }
}

class ListContent1 extends StatelessWidget {
  final GradingCostingViewModel viewModel;
  final Function() onPress;

  const ListContent1({Key key, this.viewModel, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    final ThemeData themedata = ThemeProvider.of(context);
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // viewModel
                //     .getGradingCostingData(viewModel.refreshGinList[index]);
                return BaseNavigate(
                    context,
                    GradingCostingDetail(
                      processedData: viewModel.refreshGinList[index],
                      viewModel: viewModel,
                    ));
              },
              child: Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: themedata.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.refreshGinList[index]?.ginno ?? "",
                              style: theme.subhead1Bold,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              viewModel.refreshGinList[index]?.gindate ?? "",
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                                viewModel.refreshGinList[index]?.suppliername ??
                                    ""),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            );
          },
          itemCount: viewModel?.refreshGinList?.length,
        ))
      ],
    );
  }
}

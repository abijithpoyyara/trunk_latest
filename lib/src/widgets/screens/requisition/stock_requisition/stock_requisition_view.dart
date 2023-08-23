import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/requisition/stock_requisition/stock_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/approval_button.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/new_item_sheet.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/partials/stock_requisition_list_view.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/partials/stock_view.dart';
import 'package:redstars/utility.dart';

import 'model/stock_requisition_model.dart';

final keyForm = GlobalKey<ApprovalButtonsState>();
String stockStatus;

class StockRequisitionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    // Future<int>userDepart()async{
    //   departId=await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    //   return departId;
    // }

    return BaseView<AppState, StockRequisitionViewModel>(
        init: (store, con) {
          final state = store.state.requisitionState.stockRequisitionState;
          store.dispatch(fetchInitialData());
          store.dispatch(fetchDataItems());
          // store.dispatch(fetchStockViewListData(
          //     filterModel: SRFilterModel(
          //         fromDate: state.fromDate, toDate: state.toDate)));
        },
        onDidChange: (viewModel, context) {
          if (viewModel.isSaved)
            showSuccessDialog(
                context, "Stock Requisition Saved" + "Successfully", "Success",
                () {
              viewModel.onClear();
            });
        },
        builder: (con, viewModel) {
          print(stockStatus);
          return Scaffold(
            appBar: BaseAppBar(
              title: Text("Stock Requisition"),
              actions: [
                Visibility(
                  visible: viewModel.stockReqId == 0,
                  //  stockStatus != "APPROVED",
                  child: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        String message = viewModel.validateSave();
                        if (message != null && message.isEmpty) {
                          keyForm.currentState.onSubmit(context);
                        } else {
                          BaseSnackBar.of(context).show(message);
                        }
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      // if (viewModel.stockViewListModel.stockViewList)
                      _awaitReturnValueFromSecondScreen(context, viewModel);
                    })
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15),
                  if (viewModel.stockReqId == 0)
                    FloatingActionButton(
                        onPressed: () {
                          String msg = viewModel.validateSave();
                          if (msg != null && msg.isEmpty) {
                            showItemAddSheet(context, viewModel: viewModel);
                          } else {
                            BaseSnackBar.of(con).show(msg);
                          }
                        },
                        heroTag: "items",
                        autofocus: true,
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: themeData.primaryColorDark,
                        ))
                ]),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LocationCard(
                          sourceLocation: viewModel.selectedSourceLocation,
                          destinationLocation:
                              viewModel.selectedDestinationLocation,
                          destinationLocations: viewModel.destinationLocations,
                          sourceLocations: viewModel.sourceLocations,
                          onDestinationChange: (location) {
                            viewModel.onLocationChange(location, true);
                          },
                          onSourceChange: (location) {
                            viewModel.onLocationChange(location, false);
                          },
                        )
                      ],
                    ),
                  ),
                  Flexible(
                      child: Stack(children: <Widget>[
                    if (viewModel.requisitionItems?.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (con, position) {
                          StockRequisitionModel object =
                              viewModel.requisitionItems[position];
                          return Dismissible(
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart)
                                  showStockDetails(context, object);
                                else
                                  viewModel.onRemoveItem(object);
                              },
                              background: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: _buildButton(theme))),
                              secondaryBackground: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: _buildButton(theme,
                                                icon: Icons.info_outline,
                                                title: "Stock"))
                                      ])),
                              key: Key(object.item?.code ?? ""),
                              confirmDismiss: (direction) {
                                String message =
                                    direction == DismissDirection.startToEnd
                                        ? "Do you want to delete this record"
                                        : "Do you want to show stock details";
                                return appChoiceDialog(
                                    message: message, context: con);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: ListItemStock(
                                  requisitionModel: object,
                                  onClick: (selected) => showItemAddSheet(
                                    con,
                                    selected: selected,
                                    viewModel: viewModel,
                                  ),
                                ),
                              ));
                        },
                        itemCount: viewModel.requisitionItems?.length ?? 0,
                      )
                    else
                      emptyView(theme, colors, context),
                  ])),
                  SizedBox(
                    height: 10,
                  ),
                  if (viewModel.requisitionItems.isNotEmpty)
                    ApprovalButtons(
                        key: keyForm,
                        id: viewModel.stockReqId,
                        sts: stockStatus,
                        initsta: viewModel.requisitionItems.first.remarks,
                        onSubmit: ({String remarks}) {
                          //BasePrefs.setInt(BaseConstants.USER_DEPARTMENT_ID,null);
                          String validation = viewModel.validateSave();
                          if (validation != null && validation.isEmpty) {
                            viewModel.saveRequisition(remarks: remarks);
                          } else {
                            BaseSnackBar.of(con).show(validation);
                          }
                        }),
                ]),
          );
        },
        converter: (store) => StockRequisitionViewModel.fromStore(store),
        onDispose: (store) => store.dispatch(OnClearAction()));
  }

  void showItemAddSheet(BuildContext context,
      {StockRequisitionViewModel viewModel, StockRequisitionModel selected}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => ItemStockView<StockRequisitionModel>(
          viewModel: viewModel,
          onNewItem: (reqItem) => viewModel
              .onAdd(StockRequisitionModel.fromRequisitionModel(reqItem)),
          selected: selected),
    );
  }

  void showStockDetails(BuildContext context, StockRequisitionModel selected) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_context) => StockView(selectedItem: selected),
    );
  }

  Widget _buildButton(BaseTheme theme,
      {bool reverse = false, IconData icon, String title}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(icon ?? Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          title ?? "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget emptyView(BaseTheme theme, BaseColors colors, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Container(
          height: height / 4.5,
          width: width / 2,
          child: Stack(children: [
            Positioned.fill(
              // top: MediaQuery.of(context).size.height * .14,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AppVectors.emptyBox
                    // color: Colors.black,
                    ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

void _awaitReturnValueFromSecondScreen(
    BuildContext context, StockRequisitionViewModel viewModel) async {
  final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SRListView(
          viewmodel: viewModel,
        ),
      ));
  // setState(() {
  stockStatus = result;
  print("status------${result}");
}

class LocationCard extends StatelessWidget {
  final StockLocation sourceLocation;
  final StockLocation destinationLocation;
  final ValueSetter<StockLocation> onSourceChange;
  final ValueSetter<StockLocation> onDestinationChange;
  final List<StockLocation> sourceLocations;
  final List<StockLocation> destinationLocations;

  const LocationCard({
    Key key,
    this.sourceLocation,
    this.destinationLocation,
    this.onSourceChange,
    this.onDestinationChange,
    this.sourceLocations,
    this.destinationLocations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return
        //   Container(
        //
        //     child: IntrinsicHeight(
        //         child: Row(
        //   children: [
        //     Padding(
        //       padding:EdgeInsets.symmetric(vertical: 30,horizontal: 22),
        //       child: Column(
        //         children: [
        //           ImageIcon(AppImages.source,color:theme.colors.white),
        //           ImageIcon(AppImages.dot,color:theme.colors.white),
        //           ImageIcon(AppImages.dot,color:theme.colors.white),
        //           ImageIcon(AppImages.target,color:theme.colors.white)
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         children: [
        //         Container(child:       DocumentTypeTile(
        //           title: sourceLocation?.name,
        //           icon: Icons?.location_on_outlined,
        //           selected: sourceLocation?.id == sourceLocation?.id,
        //           onPressed: () => Navigator.pop(context, sourceLocation),
        //         ),)
        //
        //         ],
        //       ),
        //     ),
        //   ],
        // )));

        Container(
      color: themeData.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            color: themeData.scaffoldBackgroundColor,
            child: IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.gps_fixed_outlined,
                              size: 22, color: theme.colors.white),
                          ImageIcon(AppImages.dot, color: theme.colors.white),
                          ImageIcon(AppImages.dot, color: theme.colors.white),
                          Icon(Icons.location_on_outlined,
                              size: 22, color: theme.colors.white)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: BaseOutlineButton(
                                color: Colors.transparent,
                                onPressed: () async {
                                  StockLocation result =
                                      await showListDialog<StockLocation>(
                                    context,
                                    sourceLocations,
                                    title: "Source Locations",
                                    builder: (data, position) =>
                                        DocumentTypeTile(
                                      isVector: true,
                                      title: data.name,
                                      icon: Icons.location_on_outlined,
                                      selected: data.id == sourceLocation.id,
                                      onPressed: () =>
                                          Navigator.pop(context, data),
                                    ),
                                  );
                                  onSourceChange(result);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white54))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text("Source Location",
                                                style: theme.body2)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(sourceLocation?.name ?? "",
                                            style: theme.display1Light.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400))
                                      ]),
                                )),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: BaseOutlineButton(
                                color: Colors.transparent,
                                onPressed: () async {
                                  StockLocation result =
                                      await showListDialog<StockLocation>(
                                    context,
                                    destinationLocations,
                                    title: "Target Locations",
                                    builder: (data, position) =>
                                        DocumentTypeTile(
                                      isVector: true,
                                      title: data?.name ?? "",
                                      icon: Icons.location_on_outlined,
                                      selected:
                                          data.id == destinationLocation?.id,
                                      onPressed: () =>
                                          Navigator.pop(context, data),
                                    ),
                                  );
                                  onDestinationChange(result);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white54))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text("Target Location",
                                                style: theme.body2)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(destinationLocation?.name ?? "",
                                            style: theme.display1Light.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400))
                                      ]),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}

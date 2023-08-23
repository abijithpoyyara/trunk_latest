import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/item_grade_rate_settings/item_grade_rate_settings_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/partials/item_grade_rate_add_item_sheet.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/partials/item_grade_rate_view_card.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/approval_button.dart';
import 'package:redstars/utility.dart';

import 'item_grade_rate_settings_saved_view_page.dart';

final keyForm = GlobalKey<ApprovalButtonsState>();
final _scaffoldKey = GlobalKey<ScaffoldState>();

class ItemGradeRateView extends StatelessWidget {
  String approvalStatus = "";
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, ItemGradeRateViewModel>(
        init: (store, con) {
          final state = store.state.itemGradeRateState;
          store.dispatch(fetchItemGradeRateSettingsInitialConfig());
          store.dispatch(fetchGrades());
          store.dispatch(fetchItemProducts(
              start: 0, scrollPosition: state.scrollPosition));
        },
        onDidChange: (viewModel, context) {
          if (viewModel.isSaved)
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              viewModel.onClear();
              Navigator.pop(context);
            });
        },
        builder: (con, viewModel) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.height;

          return Scaffold(
            key: _scaffoldKey,
            appBar: BaseAppBar(
              title: Text("Item Grade Rate Settings"),
              actions: [
                Visibility(
                  visible:
                      approvalStatus == "Pending" || viewModel.itemDtlId == 0,
                  child: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        if (viewModel.itemGradeRateListData != null &&
                            viewModel.itemGradeRateListData.isNotEmpty) {
                          viewModel.onSave();
                        } else {
                          BaseSnackBar.of(_scaffoldKey.currentContext)
                              .show("Please add items to save the transaction");
                        }
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      // BaseNavigate(
                      //     context,
                      //     ItemGradeRateSetViewPage(
                      //       viewModel: viewModel,
                      //     ));
                      // if (viewModel.stockViewListModel.stockViewList)
                      _awaitReturnStatus(context, viewModel);
                    })
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15),
                  //   if (viewModel.stockReqId == 0)
                  FloatingActionButton(
                      onPressed: () {
                        showItemAddSheet(context, viewModel: viewModel);
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
                    flex: (height * .015).toInt(),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LocationDateCard(
                          viewModel: viewModel,
                          sourceLocation: viewModel.selectedLocation,
                          sourceLocations: viewModel.itemGradeRateLocationObj,
                          onSourceChange: (location) {
                            viewModel.onLocationChange(location);
                          },
                          onDateChanged: (date) {
                            viewModel.onDateChange(date);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .006,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: height * .014, vertical: 20),
                    child: Text("Item Grade Rate :"),
                  ),
                  Expanded(
                      flex: 18,
                      child: Stack(children: <Widget>[
                        if (viewModel.itemGradeRateListData?.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (con, position) {
                              ItemGradeRateSubModel object =
                                  viewModel.itemGradeRateListData[position];
                              return Dismissible(
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      viewModel.onRemoveItem(object);
                                    } else {
                                      viewModel.onRemoveItem(object);
                                    }
                                  },
                                  background: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.red),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: _buildButton(theme))),
                                  key: UniqueKey(),
                                  confirmDismiss: (direction) {
                                    return appChoiceDialog(
                                        message:
                                            "Do you want to delete this record",
                                        context: con);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: ListItemGradeRateView(
                                      itemGradeRateModel: object,
                                      onClick: (selected) => showItemAddSheet(
                                        con,
                                        selected: selected,
                                        viewModel: viewModel,
                                      ),
                                    ),
                                  ));
                            },
                            itemCount:
                                viewModel.itemGradeRateListData?.length ?? 0,
                          )
                        else
                          Center(
                            child: EmptyResultView(
                              message: "No Data Found",
                            ),
                          )
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                ]),
          );
        },
        converter: (store) => ItemGradeRateViewModel.fromStore(store),
        onDispose: (store) {
          // store.dispatch(OnClearAction());
          store.dispatch(ItemGradeRatClearAction());
        });
  }

  void showItemAddSheet(BuildContext context,
      {ItemGradeRateViewModel viewModel, ItemGradeRateSubModel selected}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => SetGradeRateView<ItemGradeRateSubModel>(
          viewModel: viewModel,
          onNewItem: (reqItem) => viewModel
              .onAdd(ItemGradeRateSubModel.fromRequisitionModel(reqItem)),
          selected: selected),
    );
  }

  void showStockDetails(BuildContext context, ItemGradeRateSubModel selected) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_context) => ItemGradeRateViewCard(selectedItem: selected),
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

  void _awaitReturnStatus(
      BuildContext context, ItemGradeRateViewModel viewModel) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemGradeRateSetViewPage(
            viewModel: viewModel,
          ),
        ));
    // setState(() {
    approvalStatus = result;
    print("status------${result}");
  }
}

class LocationDateCard extends StatefulWidget {
  final StockLocation sourceLocation;
  final ValueSetter<StockLocation> onSourceChange;
  final List<StockLocation> sourceLocations;
  final ItemGradeRateViewModel viewModel;
  final Function(DateTime) onDateChanged;

  const LocationDateCard(
      {Key key,
      this.sourceLocation,
      this.onSourceChange,
      this.sourceLocations,
      this.viewModel,
      this.onDateChanged})
      : super(key: key);
  @override
  _LocationDateCardState createState() => _LocationDateCardState();
}

class _LocationDateCardState extends State<LocationDateCard> {
  DateTime date;
  @override
  void initState() {
    date = widget.viewModel.selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
      color: themeData.scaffoldBackgroundColor,
      margin: EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            color: themeData.primaryColor,
            child: IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: themeData.accentColor,
                              ),
                              Flexible(
                                child: Container(
                                  child: BaseOutlineButton(
                                      color: Colors.transparent,
                                      onPressed: () async {
                                        StockLocation result =
                                            await showListDialog<StockLocation>(
                                          context,
                                          widget.sourceLocations,
                                          title: "Source Locations",
                                          builder: (data, position) =>
                                              DocumentTypeTile(
                                            isVector: true,
                                            vector: AppVectors.direct,
                                            title: data.name,
                                            icon: Icons.location_on_outlined,
                                            selected: (data?.id) ==
                                                (widget.sourceLocation?.id),
                                            onPressed: () =>
                                                Navigator.pop(context, data),
                                          ),
                                        );
                                        widget.onSourceChange(result);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.0),
                                                  child: Text("Source Location",
                                                      style: theme.body2)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  widget.sourceLocation?.name ??
                                                      "",
                                                  style: theme.display1Light
                                                      .copyWith(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400))
                                            ]),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(right: 18),
                            child: BaseDatePicker(
                              // disablePreviousDates: true,
                              vector: AppVectors.calenderSettlement,
                              hint: "Pricing WEFDate",
                              icon: Icons.date_range,
                              initialValue: date,
                              isEnabled: true,
                              autovalidate: true,
                              validator: (val) {
                                return (val == null
                                    ? "Please select date"
                                    : null);
                              },
                              onChanged: (val) {
                                setState(() {
                                  date = val;
                                  widget.onDateChanged(val);
                                });
                                print("cahnged date$date");
                                print(
                                    "cahnged date${widget.viewModel.selectedDate}");
                              },
                            ),
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

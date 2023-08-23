import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/po_khat/po_khat_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/po_khat/po_khat_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/partials/lookup/supplier_quota_lookup_field.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/po_khat_item_sheet.dart';

import '../../../../utility.dart';
import 'model/po_khat_payment_types_model.dart';

// final keyForm = GlobalKey<ApprovalButtonsState>();
final pokhatScaffoldKey = GlobalKey<ScaffoldState>();

class POKhatViewListScreen extends StatefulWidget {
  final String apprvlStatus;
  final String purchasername;
  final POKhatPendingListModelList pokhatItem;
  final String purchaseorderno;
  final PokhatViewModel pokhatViewModel;

  POKhatViewListScreen(
      {Key key,
      this.apprvlStatus,
      this.pokhatItem,
      this.purchasername,
      this.purchaseorderno,
      this.pokhatViewModel})
      : super(key: key);

  @override
  _POKhatViewListScreenState createState() => _POKhatViewListScreenState();
}

class _POKhatViewListScreenState extends State<POKhatViewListScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    int start = 0;

    KhatPurchasers selectedPurchaserData;

    return BaseView<AppState, PokhatViewModel>(
        init: (store, con) {
          final state = store.state.pokhatState;
          final optionId = store.state.homeState.selectedOption.optionId;
          store.dispatch(fetchPOKhatDetailList(
              selectedPendingList: widget.pokhatItem,
              optionId: optionId,
              start: 0,
              sor_Id: widget.pokhatItem.start,
              eor_Id: widget.pokhatItem.limit,
              totalRecords: widget.pokhatItem.totalrecords,
              filterModel: state.filterModel));
          store.dispatch(fetchPokhatInitialConfigAction());
          store.dispatch(fetchKhatPoLocation());
          store.dispatch(fetchPoKhatSuppliers());
          // store.dispatch(fetchItemProducts(
          //     optionId: optionId,
          //     start: 0,
          //     scrollPosition: state.scrollPosition));
        },
        onDidChange: (viewModel, context) {
          if (viewModel.isPoKhatsaved)
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              viewModel.onClear();
              Navigator.pop(context);
              viewModel.onRefresh(
                  viewModel.poKhatPendingListModel,
                  start + 10,
                  FilterModel(
                      fromDate: viewModel.frmDate, toDate: viewModel.toDate),
                  []);

              // Navigator.pop(context);
            });
        },
        builder: (con, viewModel) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.height;

          if (viewModel.poKhatDetailListModel != null) {
            viewModel.purchasers.forEach((element) {
              if (element.personnelid ==
                  viewModel.poKhatDetailListModel.pokhatPendingDetailList[0]
                      .purchaserid) {
                selectedPurchaserData = element;
              }
              return selectedPurchaserData;
            });
          }
          return Scaffold(
              key: pokhatScaffoldKey,
              appBar: BaseAppBar(
                title: Text(widget.purchaseorderno),
                actions: [
                  // Text(
                  //     viewModel?.khatHdrModel?.selectedPurchaser?.description ??
                  //         ""
                  //             ""),
                  Visibility(
                    visible: widget.apprvlStatus == "Pending" ||
                        widget.apprvlStatus == "N/A" ||
                        widget.apprvlStatus == "Rejected" &&
                            viewModel.pokhatItems.length != null,
                    child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          if (viewModel.pokhatItems != null &&
                              viewModel.pokhatItems.isNotEmpty) {
                            viewModel.onSavePokhat();
                          } else {
                            BaseSnackBar.of(pokhatScaffoldKey.currentContext)
                                .show(
                                    "Please add items to save the transaction");
                          }
                        }),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.list),
                  //   onPressed: () {
                  // BaseNavigate(
                  //     context,
                  //     ItemGradeRateSetViewPage(
                  //       viewModel: viewModel,
                  //     ));
                  // if (viewModel.stockViewListModel.stockViewList)
                  // _awaitReturnStatus(context, viewModel);
                  //  })
                ],
              ),
              floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 15),
                    if (widget.apprvlStatus != "Approved")
                      FloatingActionButton(
                          onPressed: () {
                            showItemAddSheet(context,
                                viewModel: viewModel, typeOfadding: 1);
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
                        flex: (height * .028).toInt(),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            LocationDateCardDetails(
                              itemList: widget.pokhatItem,
                              viewModel: viewModel,
                              sourceLocation: viewModel?.selectedLocation,
                              approvalStatus: widget.apprvlStatus,
                              sourceLocations: viewModel.khatLocations,
                              onSourceChange: (location) {
                                viewModel.onPoKhatLocationChange(location);
                              },
                            ),
                          ],
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .006,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: height * .014, vertical: 20),
                      child: Text("Po-Khat items:"),
                    ),
                    Expanded(
                        flex: 18,
                        child: Stack(children: <Widget>[
                          if (viewModel.pokhatItems != null &&
                                  viewModel?.pokhatItems?.isNotEmpty ??
                              false)
                            Scrollbar(
                              child: widget.apprvlStatus != "Approved"
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (con, position) {
                                        POKhatSaveModel object =
                                            viewModel.pokhatItems[position];
                                        return Dismissible(
                                            onDismissed: (direction) {
                                              if (direction ==
                                                  DismissDirection.horizontal) {
                                                viewModel
                                                    .onRemovePokhatItem(object);
                                              } else {
                                                viewModel
                                                    .onRemovePokhatItem(object);
                                              }
                                            },
                                            background: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red),
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child:
                                                        _buildButton(theme))),
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
                                              child: PokhatItemView(
                                                pokhatItemModel: object,
                                                onClick: (selected, isEditPo) =>
                                                    showItemAddSheet(
                                                  con,
                                                  isEditPo: isEditPo,
                                                  selected: selected,
                                                  viewModel: viewModel,
                                                  typeOfadding: 0,
                                                ),
                                              ),
                                            ));
                                      },
                                      itemCount:
                                          viewModel.pokhatItems?.length ?? 0,
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (con, position) {
                                        POKhatSaveModel object =
                                            viewModel.pokhatItems[position];
                                        return Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: PokhatItemView(
                                            pokhatItemModel: object,
                                            onClick: null,
                                          ),
                                        );
                                      },
                                      itemCount:
                                          viewModel.pokhatItems?.length ?? 0,
                                    ),
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
                  ])

//                    BaseLoadingView(
//                      message: "Loading",
//                    ),

              );
        },
        converter: (store) => PokhatViewModel.fromStore(store),
        onDispose: (store) {
          //store.dispatch(PokhatClearAction());
          // store.dispatch(ItemGradeRatClearAction());
        });
  }

  void showItemAddSheet(
    BuildContext context, {
    PokhatViewModel viewModel,
    bool isEditPo,
    POKhatSaveModel selected,
    int typeOfadding,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => SetPokhatitemView<POKhatSaveModel>(
          isEditPo: isEditPo,
          typeOfadding: typeOfadding,
          viewModel: viewModel,
          onNewItem: (reqItem) => viewModel.onAddNewItem(
              khatItems: POKhatSaveModel.fromRequisitionModel(reqItem)),
          selected: selected),
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

class LocationDateCardDetails extends StatefulWidget {
  final BranchStockLocation sourceLocation;
  final POKhatPendingListModelList itemList;
  final ValueSetter<BranchStockLocation> onSourceChange;
  final List<BranchStockLocation> sourceLocations;
  final PokhatViewModel viewModel;
  final Function(DateTime) onDateChanged;
  final String approvalStatus;

  LocationDateCardDetails({
    Key key,
    this.sourceLocation,
    this.itemList,
    this.onSourceChange,
    this.sourceLocations,
    this.viewModel,
    this.onDateChanged,
    this.approvalStatus,
  }) : super(key: key);

  @override
  _LocationDateCardDetailsState createState() =>
      _LocationDateCardDetailsState();
}

class _LocationDateCardDetailsState extends State<LocationDateCardDetails> {
  DateTime date;

  String selectedValue;
  KhatPurchasers purchaserData;

  @override
  void initState() {
    date = widget.viewModel.selectedDate;
    super.initState();
  }

  bool isTaped = false;
  List<POKhatPaymentTypesModel> poPaymentTypes = [
    POKhatPaymentTypesModel(name: "Cash", code: "CA"),
    POKhatPaymentTypesModel(name: "Credit", code: "CR")
  ];

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    KhatPurchasers editPurchaser = widget.viewModel.purchasers.firstWhere(
        (element) => element?.userid == widget.viewModel.user.userId,
        orElse: () => null);
    return Container(
      color: themeData.scaffoldBackgroundColor,
      margin: EdgeInsets.only(top: 2),
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
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: themeData.accentColor,
                              ),
                              Flexible(
                                child: Container(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: BaseOutlineButton(
                                        color: Colors.transparent,
                                        onPressed: () async {
                                          BranchStockLocation result =
                                              await showListDialog<
                                                  BranchStockLocation>(
                                            context,
                                            widget.sourceLocations,
                                            title: "Location",
                                            builder: (data, position) =>
                                                DocumentTypeTile(
                                              isVector: false,
                                              vector: AppVectors.direct,
                                              title: data.name,
                                              icon: Icons.location_on_outlined,
                                              selected: (data?.id) ==
                                                  (widget.sourceLocation?.id),
                                              onPressed: () =>
                                                  Navigator.pop(context, data),
                                            ),
                                          );
                                          widget?.onSourceChange(result);
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
                                                    child: Text("Location",
                                                        style: theme.body2
                                                            .copyWith(
                                                                fontSize: 13))),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                    widget.sourceLocation
                                                            ?.name ??
                                                        "",
                                                    style: theme.body2Medium)
                                              ]),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 18),
                            child: BaseDatePicker(
                              displayTitle: "Del.Due Date",
                              // disablePreviousDates: true,
                              vector: AppVectors.calenderSettlement,
                              hint: "Pricing WEFDate",
                              icon: Icons.date_range,
                              initialValue: date,
                              isEnabled: false,
                              autovalidate: true,
                              validator: (val) {
                                return (val == null
                                    ? "Please select date"
                                    : null);
                              },
                              onChanged: (val) {
                                setState(() {
                                  date = val;
//                                  widget.onDateChanged(val);
                                });
                                print("cahnged date$date");
                                print(
                                    "cahnged date${widget.viewModel.selectedDate}");
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          // AbsorbPointer(
                          //   absorbing: widget.approvalStatus == "Pending",
                          //   child:
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: themeData.accentColor,
                              ),
                              Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(right: 18),
                                    child: SupplierQuotaLookupTextField(
                                      displayTitle: "Supplier",
                                      isEnabled: false,
                                      // initialValue:  widget.viewModel.selectedSupplier,
                                      initialValue: SupplierQuotaItem(
                                          name: widget.itemList.supplier),
                                      hint: "Select supplier",
                                      onChanged: (supplier) {
                                        widget.viewModel.supplierChange(
                                            newSupplierId: supplier.Id);
                                        print(
                                            "${supplier.name}- ${supplier.Id.toString()}");
                                      },
                                    )),
                              ),
                            ],
                          ),
                          //  ),
                          SizedBox(
                            height: 5,
                          ),
                          AbsorbPointer(
                            absorbing: editPurchaser?.userid ==
                                    widget.viewModel.user.userId
                                ? true
                                : false,
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.burst_mode,
                                //   color: themeData.accentColor,
                                // ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      right: 18,
                                    ),
                                    child: BaseDialogField<KhatPurchasers>(
                                      displayTitle: "Purchaser",
                                      // vector: AppVectors.direct,
                                      isVector: true,
                                      hint: "Tap select data",
                                      icon: Icons.person_pin,
                                      list: widget.viewModel.purchasers,
                                      initialValue: KhatPurchasers(
                                              personnelid:
                                                  widget.itemList.purchaserid,
                                              description: widget
                                                  .itemList.purchasername) ??
                                          widget.viewModel.khatHdrModel
                                              .selectedPurchaser,

                                      isEnabled: widget.approvalStatus ==
                                                  "Approved" ||
                                              widget.viewModel.user.userId ==
                                                  widget.itemList.purchaserid
                                          ? false
                                          : true,
                                      listBuilder: (val, pos) =>
                                          DocumentTypeTile(
                                        selected: true,
                                        //isVector: true,,
                                        icon: Icons.person_pin_sharp,
                                        title: val?.description ?? "",
                                        onPressed: () =>
                                            Navigator.pop(context, val),
                                      ),
                                      fieldBuilder: (selected) => Text(
                                        selected?.description ?? "",
                                        style: BaseTheme.of(context).textfield,
                                        textAlign: TextAlign.start,
                                      ),
                                      validator: (val) =>
                                          val == null ? "please Select" : null,

                                      onSaved: (value) {},
                                      onChanged: (value) {
                                        // model.approvalStatus = value;
                                        widget.viewModel.purchaserChange(
                                            newPurchaserId: value.personnelid);
                                        print(
                                            "${value.description}- ${value.personnelid}");
                                      },
//          onSaved: (val) {}
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.viewModel.poKhatDetailListModel != null)
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      right: 18,
                                    ),
                                    child: BaseDialogField<
                                        POKhatPaymentTypesModel>(
                                      displayTitle: "Payment Mode",
                                      // vector: AppVectors.direct,
                                      isVector: true,
                                      hint: "Tap select data",
                                      icon: Icons.money,
                                      list: poPaymentTypes,
                                      initialValue: POKhatPaymentTypesModel(
                                              name:
                                                  widget.itemList.paymentmode ==
                                                          "CA"
                                                      ? "Cash"
                                                      : "Credit") ??
                                          widget.viewModel.khatHdrModel
                                              .selectedPaymentType,
                                      isEnabled:
                                          widget.approvalStatus != "Approved"
                                              ? true
                                              : false,
                                      listBuilder: (val, pos) =>
                                          DocumentTypeTile(
                                        selected: true,
                                        //isVector: true,,
                                        icon: Icons.attach_money,
                                        title: val.name,
                                        onPressed: () =>
                                            Navigator.pop(context, val),
                                      ),
                                      fieldBuilder: (selected) => Text(
                                        selected.name,
                                        style: BaseTheme.of(context).textfield,
                                        textAlign: TextAlign.start,
                                      ),
                                      validator: (val) =>
                                          val == null ? "please Select" : null,

                                      onSaved: (value) {},
                                      onChanged: (value) {
                                        // model.approvalStatus = value;
                                        widget.viewModel.paymentChange(
                                            newPaymentMode: value.code);
                                        print("${value.name}- ${value.code}");
                                      },
//          onSaved: (val) {}
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(
                                      right: 18,
                                    ),
                                    child: BaseTextField(
                                      vector: AppVectors.remarks,
                                      initialValue: widget.itemList.remarks,
                                      isEnabled:
                                          widget.approvalStatus != "Approved"
                                              ? true
                                              : false,
                                      displayTitle: "Remarks",
                                      onChanged: (value) {
                                        setState(() {
                                          widget.viewModel.khatHdrModel
                                              .remarks = value;
                                          print(
                                              "Pokhatmodel---${widget.viewModel.khatHdrModel.remarks}");
                                          widget.itemList.remarks = value;
                                          print(value);
                                          print(widget.itemList.remarks);
                                        });
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  void _resultData() async {
    BranchStockLocation result = await showListDialog<BranchStockLocation>(
      context,
      widget.sourceLocations,
      title: "Location",
      builder: (data, position) => DocumentTypeTile(
        isVector: false,
        vector: AppVectors.direct,
        title: data.name,
        icon: Icons.location_on_outlined,
        selected: (data?.id) == (widget.sourceLocation?.id),
        onPressed: () => Navigator.pop(context, data),
      ),
    );
    widget?.onSourceChange(result);
  }
}

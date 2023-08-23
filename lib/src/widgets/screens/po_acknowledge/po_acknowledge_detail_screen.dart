import 'dart:ui';

import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/actions/po_acknowledge/po_acknowledge_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/utility.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'description_view.dart';

class POADetailScreen extends StatelessWidget {
  final PurchaseOrderModel order;
  final AcknowledgeType type;
  final int supplierId;

  const POADetailScreen({
    Key key,
    this.order,
    this.type,
    this.supplierId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context).style;
    return StoreConnector<AppState, AcknowledgeViewModel>(
        onInit: (store) => store.dispatch(fetchPODetails(order)),
        converter: (store) => AcknowledgeViewModel.fromStore(store),
        onWillChange: (prev, viewModel) {
          if (!prev.saveStatus && viewModel.saveStatus) {
            Future.delayed(kThemeChangeDuration, () {
              showSuccessDialog(
                  context, 'Acknowledgement Saved successfully', 'Success', () {
                viewModel.ordersToDefault();
                Navigator.pop(context);
              });
            });
          }
        },
        onDispose: (store) => store.dispatch(POADetailClearAction()),
        builder: (context, viewModel) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          if (viewModel.loadingStatus == LoadingStatus.loading)
            return showLoading();
          return Scaffold(
            appBar: BaseAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.transNo ?? "PO Acknowledgement"),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${order?.transDate ?? ""}',
                      style: BaseTheme.of(context)
                          .smallMedium
                          .copyWith(letterSpacing: .75),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color: themedata.scaffoldBackgroundColor,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: height * 0.08,
                              color: themedata.primaryColor,
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.shopping_cart_rounded),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Items',
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: themedata.accentColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${viewModel.orderItems.length}',
                                            style: BaseTheme.of(context)
                                                .body2Medium
                                                .copyWith(
                                                  color: themedata.primaryColor,
                                                ),
                                          ),
                                        )),
                                  ]),
                            ),
                            ItemList(itemDetails: viewModel.orderItems),
                            SizedBox(height: 10),
                            Container(
                              height: height * .08,
                              color: themedata.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.directions_bus_rounded),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Vehicles',
                                        style: BaseTheme.of(context)
                                            .body
                                            .copyWith(),
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: themedata.accentColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${viewModel.vehicles.length}',
                                            style: BaseTheme.of(context)
                                                .body
                                                .copyWith(
                                                  color: themedata.primaryColor,
                                                ),
                                          ),
                                        )),
                                  ]),
                            ),
                            VehicleList(
                                vehicles: viewModel.vehicles,
                                onItemSelect: (vehicle) => (!type.isCompleted)
                                    ? _onShowVehicle(context,
                                        selected: vehicle, viewModel: viewModel)
                                    : null),
                          ],
                        ),
                      ),
                    ),
                    if (!type.isCompleted)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            backgroundColor: colors.accentColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            mini: true,
                            tooltip: 'Add new vehicle',
                            onPressed: () =>
                                _onShowVehicle(context, viewModel: viewModel),
                            child: Icon(
                              Icons.add,
                              color: themedata.primaryColorDark,
                            ),
                          )
                        ],
                      ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!type.isCompleted && !type.isPending)
                            InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () async {
                                final conformation = await baseChoiceDialog(
                                  message:
                                      'Are you sure, you want to delete this acknowledgement?',
                                  context: context,
                                  title: 'Delete ${order.transNo} ?',
                                );
                                if (conformation)
                                  viewModel.deleteAcknowledgement();
                              },
                              child: CircleAvatar(
                                foregroundColor: colors.white,
                                backgroundColor: colors.warningColor,
                                child: Icon(Icons.delete_forever_rounded),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              color: themedata.primaryColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: themedata.primaryColor,
                                    //border: Border.all(color: colors.hintColor),
                                    borderRadius: BorderRadius.circular(8)),
                                child: BaseTextField(
                                  vector: AppVectors.remarks,
                                  padding: EdgeInsets.zero,
                                  displayTitle: 'Remarks',
                                  isEnabled: (!type.isCompleted),
                                  initialValue: viewModel.remarks,
                                  onChanged: viewModel.onRemarksChange,
                                ),
                              ),
                            ),
                            flex: 4,
                          ),
                          if (!type.isCompleted)
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                color: themedata.primaryColorDark,
                                onPressed: () {
                                  String message =
                                      viewModel.validateSaveAcknowledgement(
                                          type, supplierId);
                                  if (message.isNotEmpty ?? true) {
                                    BaseSnackBar.of(context).show(message);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: themedata.accentColor,
                                    ),
                                    Text(
                                      'Save',
                                      style: BaseTheme.of(context)
                                          .body
                                          .copyWith(
                                              color: themedata.accentColor),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget showLoading() {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          BaseLoadingSpinner(size: 65),
        ])));
  }

  Future<void> _onShowVehicle(
    BuildContext context, {
    POVehicleModel selected,
    AcknowledgeViewModel viewModel,
  }) async {
    await Navigator.push(
        context,
        BaseNavigate.slideUp(VehicleView(
          vehicle: selected ?? POVehicleModel(),
          isNewRecord: selected == null,
          onDelete: (record) {
            viewModel.onDeleteVehicle(record);
            Navigator.pop(context);
          },
          onSubmit: (record) {
            viewModel.saveVehicle(record);
            Navigator.pop(context);
          },
        )));
  }
}

class ItemList extends StatelessWidget {
  final List<POItemModel> itemDetails;

  const ItemList({
    Key key,
    this.itemDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context).style;
    ThemeData themedata = ThemeProvider.of(context);

    return Container(
      color: themedata.primaryColor,
      margin: EdgeInsets.only(bottom: .2),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemDetails.length,
          itemBuilder: (context, position) {
            bool isLast = position + 1 == itemDetails.length;
            POItemModel item = itemDetails[position];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom: AppBorderSide(
              //             color: isLast
              //                 ? Colors.transparent
              //                 : colors.primaryColor))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    '${item.itemName}',
                    style: BaseTheme.of(context).body2Medium,
                  )),
                  Text(
                    '${item.qty}',
                    style: BaseTheme.of(context)
                        .body2Medium
                        .copyWith(color: themedata.accentColor),
                  ),
                  SizedBox(width: 3),
                  Text('${item.uom}',
                      style: BaseTheme.of(context)
                          .body2Medium
                          .copyWith(color: themedata.accentColor)),
                ],
              ),
            );
          }),
    );
  }
}

class VehicleList extends StatelessWidget {
  final ValueSetter<POVehicleModel> onItemSelect;
  final List<POVehicleModel> vehicles;

  const VehicleList({
    Key key,
    this.onItemSelect,
    this.vehicles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    final textStyle = BaseTheme.of(context).style;
    ThemeData themedata = ThemeProvider.of(context);

    return vehicles.isNotEmpty
        ? Container(
            color: themedata.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: vehicles.length,
                itemBuilder: (context, position) {
                  bool isLast = position + 1 == vehicles.length;
                  final item = vehicles[position];
                  return TextButton(
                    onPressed: () => onItemSelect(item),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      // decoration: BoxDecoration(
                      //     border: Border(
                      //         bottom: AppBorderSide(
                      //             color: isLast
                      //                 ? Colors.transparent
                      //                 : colors.primaryColor))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${item.vehicleNo}',
                            style: BaseTheme.of(context)
                                .body
                                .copyWith(color: themedata.accentColor),
                          ),
                          SizedBox(height: 2),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 1),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 6),
                            child: Text(
                              BaseStringCase('${item.description}')
                                  .sentenceCase,
                              style: BaseTheme.of(context).body.copyWith(
                                  color: themedata.accentColor,
                                  wordSpacing: 1.2,
                                  letterSpacing: .15),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: EmptyResultViewPO(
              icon: Icons.directions_bus_rounded,
              message: "No Vehicles Added",
            ),
          );
  }
}

class EmptyResultViewPO extends StatelessWidget {
  const EmptyResultViewPO({
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
    ThemeData themedata = ThemeProvider.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: height * .25,
            ),
            Icon(
              icon,
              color: themedata.accentColor,
              size: height * 1 / 18,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style:
                  theme.body2MediumHint.copyWith(color: themedata.accentColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themedata.primaryColor,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: Icon(
                    Icons.refresh,
                    color: themedata.primaryColorDark,
                  ),
                  label: const Text("Refresh"))
          ]),
    );
  }
}

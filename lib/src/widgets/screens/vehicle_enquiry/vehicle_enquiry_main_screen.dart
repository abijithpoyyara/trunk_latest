import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/vehicle_enquiry/vehicle_enquiry_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/vehicle_enquiry/vehicle_enquiry_viewmodel.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';

import 'filter_model_vehicle_enquiry.dart';
import 'filter_screen.dart';

class VehicleEnquiryScreen extends StatefulWidget {
  @override
  _VehicleEnquiryScreenState createState() => _VehicleEnquiryScreenState();
}

class _VehicleEnquiryScreenState extends State<VehicleEnquiryScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    return BaseView<AppState, VehicleEnquiryProductionDetailViewModel>(
      init: (store, context) {
        store.dispatch(fetchVechicleProductionListAction());
      },
      // onDispose: (store) =>
      //     store.dispatch(UnconfirmedTransactionDetailClearAction()),
      converter: (store) =>
          VehicleEnquiryProductionDetailViewModel.fromStore(store),
      builder: (context, viewmodel) {
        print("neeiuiworu${viewmodel.productionDetails.length}");
        return Scaffold(
          appBar: BaseAppBar(
            title: Text("Vehicle Enquiry - Production Details"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              VehicleEProductionFilterModel result =
                  await appShowChildDialog<VehicleEProductionFilterModel>(
                      context: context,
                      child: FilterVEProductionScreen(
                          viewModel: viewmodel, model: viewmodel.filter));
              viewmodel.onSaveFilter(result);
              viewmodel.onChangeFilter(VehicleEProductionFilterModel(
                lookupItemVE: viewmodel?.filter?.lookupItemVE,
              ));
            },
            child: Icon(
              Icons.filter_list,
              color: themeData.primaryColorDark,
            ),
          ),
          body: viewmodel.productionDetails != null &&
                  viewmodel.productionDetails.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          color: themeData.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Model No:",
                                  style: theme.body2Medium.copyWith(
                                      fontSize: 12,
                                      letterSpacing: .3,
                                      color: themeData.accentColor
                                          .withOpacity(.5)),
                                ),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    (viewmodel?.productionDetails?.first
                                            ?.modelname) ??
                                        "".toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Chassis No:",
                                    style: theme.body2Medium.copyWith(
                                        fontSize: 12,
                                        letterSpacing: .3,
                                        color: themeData.accentColor
                                            .withOpacity(.5))),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    ((viewmodel?.productionDetails?.first
                                                ?.chassisno) ??
                                            "")
                                        .toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Customer Name:",
                                    style: theme.body2Medium.copyWith(
                                        fontSize: 12,
                                        letterSpacing: .3,
                                        color: themeData.accentColor
                                            .withOpacity(.5))),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    ((viewmodel?.productionDetails?.first
                                                ?.customername) ??
                                            "")
                                        .toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Engine No:",
                                    style: theme.body2Medium.copyWith(
                                        fontSize: 12,
                                        letterSpacing: .3,
                                        color: themeData.accentColor
                                            .withOpacity(.5))),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    ((viewmodel?.productionDetails?.first
                                                ?.engineno) ??
                                            "")
                                        .toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Vehicle No:",
                                    style: theme.body2Medium.copyWith(
                                        fontSize: 12,
                                        letterSpacing: .3,
                                        color: themeData.accentColor
                                            .withOpacity(.5))),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    ((viewmodel?.productionDetails?.first
                                                ?.registrationno) ??
                                            "")
                                        .toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Last Service Done on:",
                                    style: theme.body2Medium.copyWith(
                                        fontSize: 12,
                                        letterSpacing: .3,
                                        color: themeData.accentColor
                                            .withOpacity(.5))),
                                SizedBox(
                                  height: 1.5,
                                ),
                                Text(
                                    ((viewmodel?.productionDetails?.first
                                                ?.lastserviceon) ??
                                            "")
                                        .toUpperCase(),
                                    style: theme.textfield.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      height: 50,
                      color: themeData.primaryColor,
                      child: Text(
                        "Production Details",
                        style: theme.headline
                            .copyWith(letterSpacing: .2, fontSize: 17),
                      ),
                    ),
                    viewmodel?.productionDetails != null &&
                            viewmodel?.productionDetails?.first
                                    ?.productionJsonData !=
                                null &&
                            viewmodel?.productionDetails?.first
                                    ?.productionJsonData?.length >
                                0
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: viewmodel.productionDetails.first
                                    .productionJsonData.length,
                                itemBuilder: (context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(15),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: themeData.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  // padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Trans. No:",
                                                        style: theme.body2Medium
                                                            .copyWith(
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                    .3,
                                                                color: themeData
                                                                    .accentColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          (viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .transno) ??
                                                              "",
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text("Trans. Type:",
                                                          style: theme
                                                              .body2Medium
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .3,
                                                                  color: themeData
                                                                      .accentColor
                                                                      .withOpacity(
                                                                          .5))),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          ((viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .transtype) ??
                                                              ""),
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text("Branch:",
                                                          style: theme
                                                              .body2Medium
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .3,
                                                                  color: themeData
                                                                      .accentColor
                                                                      .withOpacity(
                                                                          .5))),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          ((viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .branchname) ??
                                                              ""),
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 6,
                                                ),
                                                Expanded(
                                                  // padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Trans. Date:",
                                                          style: theme
                                                              .body2Medium
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .3,
                                                                  color: themeData
                                                                      .accentColor
                                                                      .withOpacity(
                                                                          .5))),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          ((viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .transdate) ??
                                                              ""),
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text("Status:",
                                                          style: theme
                                                              .body2Medium
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .3,
                                                                  color: themeData
                                                                      .accentColor
                                                                      .withOpacity(
                                                                          .5))),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          ((viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .apprvlstatus) ??
                                                              ""),
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text("Location:",
                                                          style: theme
                                                              .body2Medium
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .3,
                                                                  color: themeData
                                                                      .accentColor
                                                                      .withOpacity(
                                                                          .5))),
                                                      SizedBox(
                                                        height: 1.5,
                                                      ),
                                                      Text(
                                                          ((viewmodel
                                                                  ?.productionDetails
                                                                  ?.first
                                                                  ?.productionJsonData[
                                                                      index]
                                                                  .locationname) ??
                                                              ""),
                                                          style: theme.textfield
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize:
                                                                      14.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                dividerColor:
                                                    Colors.transparent,
                                              ),
                                              child: ExpansionTile(
                                                  trailing: Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    color:
                                                        themeData.accentColor,
                                                  ),
                                                  title: Text("Remark:",
                                                      style: theme.body2Medium
                                                          .copyWith(
                                                              fontSize: 12,
                                                              letterSpacing: .3,
                                                              color: themeData
                                                                  .accentColor
                                                                  .withOpacity(
                                                                      .5))),
                                                  tilePadding: EdgeInsets.zero,
                                                  childrenPadding:
                                                      EdgeInsets.zero,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Container(
                                                            height:
                                                                height * 0.15,
                                                            width: width,
                                                            child: Card(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            7.0)),
                                                                elevation: 0,
                                                                color: themeData
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                        .15),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child: Text(
                                                                      viewmodel
                                                                              ?.productionDetails
                                                                              ?.first
                                                                              ?.productionJsonData[index]
                                                                              ?.remark ??
                                                                          "No remarks",
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                        : Center(
                            heightFactor: 5,
                            child: EmptyResultView(
                              message: "No production details....",
                            ),
                          ),
                  ],
                )
              : Center(
                  child: EmptyResultView(
                    message: "No data found",
                  ),
                ),
        );
      },
    );
  }

  Row buildRow(BuildContext context, String title, String value) => Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: BaseTheme.of(context).smallMedium,
                ),
                Text(
                  value,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
        ],
      );
  Text buildText(String title) => Text(
        title,
        textAlign: TextAlign.start,
      );
}

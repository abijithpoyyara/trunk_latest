import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/pricing/pricing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/pricing/_partial/filter_view.dart';
import 'package:redstars/src/widgets/screens/pricing/_partial/priicing_content_list.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/approval_button.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';


final keyForm = GlobalKey<ApprovalButtonsState>();

class PricingView extends StatelessWidget {
  final PricingViewModel viewModel;

  PricingView({Key key, this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData selectedTheme=ThemeProvider.of(context);
    return BaseView<AppState, PricingViewModel>(
        converter: (store) => PricingViewModel.fromStore(store),
        onDispose: (store) => store.dispatch(OnClearAction()),
        init: (store, con) {
          store.dispatch(fetchLocations());
          store.dispatch(fetchLocationProducts());
          store.dispatch(fetchItemGrpProducts());
          store.dispatch(fetchItemModelProducts());
          store.dispatch(fetchItemBrandProducts());
          store.dispatch(fetchBrandProducts());
          store.dispatch(fetchClassificationProducts());
          store.dispatch(fetchItemProducts());
        },
        onDidChange: (viewModel, context) {
          List<String> k = [];
          viewModel.multipleItems.forEach((element) {
            k.add(element.name + "- 0 Sales Enquires updated ,");
          });
          if (viewModel.isSaved)
            showSuccessDialog(
                context,
                viewModel.multipleItems != null
                    ? k.join("") +
                        viewModel.selectedLocation?.name +
                        "- 0 Sales Enquires updated"
                    : viewModel.selectedLocation.name +
                        "- 0 Sales Enquires updated",
                "Success", () {
              viewModel.onClear();
              Navigator.pop(context);
            });
        },
        builder: (context, viewModel) {
          return Scaffold(
            appBar: BaseAppBar(
              title: Text("Pricing "),
              actions: [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      viewModel.placePricing();
                    })
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15),
                  FloatingActionButton(
                      onPressed: () {
                        showItemDetailSelectionSheet(context,
                            viewModel: viewModel);
                      },
                      heroTag: "Filter",
                      autofocus: true,
                      child: Icon(
                        Icons.filter_list,
                        color: selectedTheme.primaryColorDark,
                      ))
                ]),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 30,
                    child: LocationView(
                      onMultiLocation: (data) {
                        viewModel.onMultiLocationSelect(data);
                      },
                      sourceLocation: viewModel?.selectedLocation,
                      sourceLocations: viewModel?.location,
                      viewModel: viewModel,
                      copyToLocation: viewModel?.locationItems,
                      onSourceChange: (location) {
                        viewModel.onLocationChange(location, false);
                      },
                    ),
                  ),
                  Expanded(
                      flex: 33,
                      child: ItemDtlUpdate(
                        viewModel: viewModel,
                      ))
                ]),
          );
        });
  }
}

void showItemDetailSelectionSheet(BuildContext context,
    {PricingViewModel viewModel, PricingModel selected}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_context) => ItemDetailView<PricingModel>(
        onAdd: (data) => viewModel.onAdd(data),
        onViewDetails: (itemDetails) => viewModel.onViewDetails(itemDetails),
        viewModel: viewModel,
        selected: selected),
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
                child: Image(
                  image: AppImages.emptybox,
                )),
          ),
        ]),
      ),
    ),
  );
}

class LocationView extends StatefulWidget {
  final StockLocation sourceLocation;
  final ValueSetter<StockLocation> onSourceChange;
  final List<LocationLookUpItem> copyToLocation;
  final PricingViewModel viewModel;
  final List<StockLocation> sourceLocations;
  final Function(List<LocationLookUpItem> locations) onMultiLocation;

  const LocationView(
      {Key key,
      this.sourceLocation,
      this.onSourceChange,
      this.copyToLocation,
      this.viewModel,
      this.onMultiLocation,
      this.sourceLocations})
      : super(key: key);
  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<LocationLookUpItem> locations = [];
  List<String> data = [];

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);

    final _multiLocation = widget.viewModel.locationItems
        .map((grp) => MultiSelectItem<LocationLookUpItem>(grp, grp.name))
        .toList();

    return Container(
      color:themeData.primaryColor,
      margin: EdgeInsets.only(bottom: height * .07),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Column(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 20, left: 15),
                    child: BaseDatePicker(
                      isEnabled: false,
                      vector: AppVectors.calenderSettlement,
                    )),
                Container(
                    // height: 200,
                    //margin: EdgeInsets.only(bottom: 50),
                   color:themeData.primaryColor,
                    child: IntrinsicHeight(
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 35, left: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.gps_fixed_outlined,
                                      size: 22, color: theme.colors.white),
                                  ImageIcon(AppImages.dot,
                                      color: theme.colors.white),
                                  ImageIcon(AppImages.dot,
                                      color: theme.colors.white),
                                  Icon(Icons.location_on_outlined,
                                      size: 22, color: theme.colors.white)
                                ],
                              ),
                            ),
                            Expanded(
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
                                              await showListDialog<
                                                  StockLocation>(
                                            context,
                                            widget.sourceLocations,
                                            title: "Location",
                                            builder: (data, position) =>
                                                DocumentTypeTile(
                                              isVector: true,
                                              title: data.name,
                                              icon: Icons.location_on_outlined,
                                              selected: data.id ==
                                                  widget.sourceLocation.id,
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
                                                    child: Text("Location",
                                                        style: theme.body2)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    widget.sourceLocation
                                                            ?.name ??
                                                        "",
                                                    style: theme.display1Light
                                                        .copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400))
                                              ]),
                                        )),
                                  ),
                                  //  SizedBox(height: 10),
                                  if (widget.viewModel?.itemDtl != null &&
                                      widget.viewModel.itemDtl.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: MultiSelectDialogField(
                                          confirmText: Text(
                                            "OK",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                color: themeData.primaryColorDark),
                                          ),
                                          cancelText: Text(
                                            "CANCEL",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                color:themeData.primaryColorDark),
                                          ),
                                          itemsTextStyle: TextStyle(
                                              color:
                                              themeData.accentColor),
                                          selectedItemsTextStyle: TextStyle(
                                              color:
                                              themeData.accentColor),
                                          checkColor:themeData.accentColor,
                                          backgroundColor:
                                          themeData.scaffoldBackgroundColor,
                                          searchable: true,
                                          // initialValue: _selectedAnimals,
                                          items: _multiLocation,
                                          title: Text("Copy to Location"),
                                          selectedColor:
                                          themeData.primaryColorDark,
                                          decoration: BoxDecoration(
                                            color: themeData.primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            border: Border.all(
                                              color: themeData.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          buttonIcon: Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            color: Colors.white,
                                          ),
                                          buttonText: Text(
                                            "Copy to Location",
                                            style: TextStyle(
                                              color: themeData.accentColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onSelectionChanged: (data) {
                                            setState(() {
                                              locations = data;
                                              widget.onMultiLocation(locations);
                                            });
                                            print("Locations${locations}");
                                          }),
                                    ),
                                ],
                              ),
                            ),
                          ]),
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

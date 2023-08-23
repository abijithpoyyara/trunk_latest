import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/requisition/purchase_requisition/purchase_requestion_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';
import 'package:redstars/src/widgets/screens/requisition/model/requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

class ListItem<T extends RequisitionModel> extends StatelessWidget {
  final T requisitionModel;
  final ValueSetter<T> onClick;
  final PurchaseRequisitionViewModel viewModel;

  const ListItem({Key key, this.requisitionModel, this.onClick, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return Column(
      children: [
        Container(
          color: themeData.scaffoldBackgroundColor,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: themeData.scaffoldBackgroundColor,
                border: Border(
                    bottom: BaseBorderSide(color: theme.colors.primaryColor))),
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
              onPressed: () => onClick(requisitionModel),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(requisitionModel.item.description,
                            style: theme.subhead1
                                .copyWith(fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(requisitionModel.item.code,
                              style: theme.body),
                        ),
                      ],
                    )),
                    SizedBox(width: 22),
                    Column(
                      children: <Widget>[
                        Text(
                          "${requisitionModel.qty}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(requisitionModel.uom.uomname,
                              style: theme.body),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        //  SizedBox(height: 10),
      ],
    );
  }
}

class ListItemStock<T extends RequisitionModel> extends StatelessWidget {
  final T requisitionModel;
  final ValueSetter<T> onClick;
  final StockRequisitionViewModel viewModel;
  final List<StockRequisitionModel> requisitionItems;

  ListItemStock(
      {Key key,
      this.requisitionModel,
      this.onClick,
      this.viewModel,
      this.requisitionItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: theme.colors.secondaryColor,
              border: Border(bottom: BaseBorderSide())),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            onPressed: () => onClick(requisitionModel),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(requisitionModel.item.description,
                          style: theme.subhead1),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child:
                            Text(requisitionModel.item.code, style: theme.body),
                      ),
                    ],
                  )),
                  SizedBox(width: 22),
                  Column(
                    children: <Widget>[
                      Text("${requisitionModel.qty}"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Text(requisitionModel.uom.uomname,
                            style: theme.body),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class ItemDetailView<T extends PricingModel> extends StatefulWidget {
  final Function(PricingModel pricingModel) onViewDetails;
  final Function(PricingModel pricingModel) onAdd;
  final Function(List<LocationLookUpItem> locations) onMultiLocation;
  final PricingViewModel viewModel;
  final T selected;

  const ItemDetailView({
    Key key,
    this.onAdd,
    this.onViewDetails,
    this.onMultiLocation,
    this.selected,
    this.viewModel,
  }) : super(key: key);

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  PricingModel model;
  List<ItemLookupItem> items = [];
  List<ItemGroupLookupItem> itemGrp = [];
  List<ItemGroupLookupItem> itemModel = [];
  List<ItemGroupLookupItem> itemBrand = [];
  List<ItemGroupLookupItem> brand = [];
  List<ItemGroupLookupItem> classification = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    model = widget.viewModel?.model ?? PricingModel();
    //itemGrp = widget?.selected?.itemGrp;
    itemGrp = model?.itemGrp;
    itemModel = model?.itemModel;
    itemBrand = model?.itemBrand;
    classification = model?.classificationList;
    items = model?.items;
    brand = model?.brandList;
    super.initState();
    print("grp====${model.itemGrp}");
    print("ItemBrand====${model.itemBrand}");
    print("items====${model.items}");
    print("ItemModel====${model.itemModel}");
    print("classification====${model.classificationList}");
    print("brandList====${model.brandList}");
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    final _itemGrp = widget.viewModel.itemGroupItems
        .map(
            (grp) => MultiSelectItem<ItemGroupLookupItem>(grp, grp.description))
        .toList();

    final _classification = widget.viewModel.classificationItems
        .map(
            (cls) => MultiSelectItem<ItemGroupLookupItem>(cls, cls.description))
        .toList();
    final _brand = widget.viewModel.brandItems
        .map((brand) =>
            MultiSelectItem<ItemGroupLookupItem>(brand, brand.description))
        .toList();
    final _itemBrand = widget.viewModel.itemBrandItems
        .map(
            (val) => MultiSelectItem<ItemGroupLookupItem>(val, val.description))
        .toList();
    final _itemModel = widget.viewModel.itemModelItems
        .map((result) =>
            MultiSelectItem<ItemGroupLookupItem>(result, result.description))
        .toList();
    final _items = widget.viewModel.items
        .map((pro) => MultiSelectItem<ItemLookupItem>(pro, pro.description))
        .toList();
    print("length-----${_itemGrp.length}");

    return Container(color: themeData.primaryColor,
      child: Column(
        children: [
          Expanded(
            flex: 30,
            child: new AnimatedPadding(
                padding: EdgeInsets.only(top: height * .06),
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: new Container(
                  color:themeData.scaffoldBackgroundColor,
                  height: height * 1,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      //  physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: themeData.primaryColor,
                            child: Row(children: [
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                              Text("Filter",
                                  textAlign: TextAlign.center,
                                  style: theme.subhead1Bold.copyWith(
                                      fontSize: 18, fontWeight: FontWeight.w500)),
                            ]),
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          MultiSelectDialogField(
                            // initialValue: itemGrp,
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
                            itemsTextStyle:
                                TextStyle(color: themeData.accentColor),
                            selectedItemsTextStyle:
                                TextStyle(color:themeData.accentColor),
                            checkColor: themeData.accentColor,
                            backgroundColor:
                                themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor:themeData.primaryColorDark,
                            initialValue: itemGrp,
                            items: _itemGrp,
                            title: Text("Itemgroup"),
                            selectedColor: themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "Itemgroup",
                              style: TextStyle(
                                color: themeData.accentColor,
                                fontSize: 16,
                              ),
                            ),
                            // chipDisplay: MultiSelectChipDisplay(
                            //   items: itemGrp
                            //       ?.map((e) => MultiSelectItem(e, e.description))
                            //       ?.toList(),
                            //   onTap: (value) {
                            //     setState(() {
                            //       itemGrp.remove(value);
                            //     });
                            //   },
                            // ),
                            onSelectionChanged: (data) {
                              model?.itemGrp = data;
                              print("Itemgroup${itemGrp?.length}");
                            },
                            onConfirm: (data) {
                              itemGrp = data;
                            },
                          ),

                          MultiSelectDialogField(
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
                            itemsTextStyle:
                                TextStyle(color: themeData.accentColor),
                            selectedItemsTextStyle:
                                TextStyle(color: themeData.accentColor),
                            // unselectedColor: BaseColors.of(context).white,
                            checkColor:themeData.accentColor,
                            backgroundColor:
                                themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor: themeData.primaryColorDark,
                            initialValue: classification,
                            items: _classification,
                            title: Text("Classification"),
                            selectedColor: themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color:themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "Classification",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onSelectionChanged: (data) {
                              model?.classificationList = data;
                              print("classification${classification}");
                            },
                            onConfirm: (data) {
                              classification = data;
                            },
                          ),

                          MultiSelectDialogField(
                            confirmText: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color:themeData.primaryColorDark),
                            ),
                            cancelText: Text(
                              "CANCEL",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color:themeData.primaryColorDark),
                            ),
                            itemsTextStyle:
                                TextStyle(color:themeData.accentColor),
                            selectedItemsTextStyle:
                                TextStyle(color: themeData.accentColor),
                            checkColor: themeData.accentColor,
                            backgroundColor:
                            themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor:themeData.primaryColorDark,
                            initialValue: brand,
                            items: _brand,
                            title: Text("Brand"),
                            selectedColor: themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color:themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "Brand",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onSelectionChanged: (data) {
                              //  brand.clear();
                              model?.brandList = data;
                              print("brand${brand}");
                            },
                            onConfirm: (data) {
                              brand = data;
                            },
                          ),
                          MultiSelectDialogField(
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
                                  color: themeData.primaryColorDark),
                            ),
                            itemsTextStyle:
                                TextStyle(color: BaseColors.of(context).white),
                            selectedItemsTextStyle:
                                TextStyle(color: BaseColors.of(context).white),
                            checkColor: themeData.accentColor,
                            backgroundColor:
                            themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor: themeData.primaryColorDark,
                            initialValue: itemBrand,
                            items: _itemBrand,
                            title: Text("Itembrand"),
                            selectedColor:themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color:themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "Itembrand",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onSelectionChanged: (data) {
                              //itemBrand.clear();
                              model?.itemBrand = data;
                              print("itemBrand${itemBrand}");
                            },
                            onConfirm: (data) {
                              itemBrand = data;
                            },
                          ),
                          MultiSelectDialogField(
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
                                  color: themeData.primaryColorDark),
                            ),
                            itemsTextStyle:
                                TextStyle(color: BaseColors.of(context).white),
                            selectedItemsTextStyle:
                                TextStyle(color: BaseColors.of(context).white),
                            checkColor: themeData.accentColor,
                            // key: _multiSelectKey,
                            backgroundColor:
                                themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor: themeData.primaryColorDark,
                            initialValue: itemModel,
                            items: _itemModel,
                            title: Text("ItemModel"),
                            selectedColor: themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color:themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "ItemModel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onSelectionChanged: (data) {
                              model?.itemModel = data;
                              print("itemModel${itemModel}");
                            },
                            onConfirm: (data) {
                              itemModel = data;
                            },
                          ),
                          MultiSelectDialogField(
                            confirmText: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color:themeData.primaryColorDark),
                            ),
                            cancelText: Text(
                              "CANCEL",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color: themeData.primaryColorDark),
                            ),
                            itemsTextStyle:
                                TextStyle(color: themeData.accentColor,),
                            selectedItemsTextStyle:
                                TextStyle(color:themeData.accentColor,),
                            checkColor: themeData.accentColor,
                            backgroundColor:
                            themeData.scaffoldBackgroundColor,
                            searchable: true,
                            barrierColor: themeData.primaryColorDark,
                            initialValue: items,
                            items: _items,
                            title: Text("Item"),
                            selectedColor:themeData.primaryColorDark,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                            buttonText: Text(
                              "Item",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onSelectionChanged: (data) {
                              model?.items = data;
                              print("items${items?.length}");
                              //  items.clear();
                            },
                            onConfirm: (data) {
                              items = data;
                            },
                          ),
                          //SizedBox(height: height * .08),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height * .03,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width,
                child: BaseRaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: themeData.primaryColorDark,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      widget.onAdd(model);
                      List<ItemGroupLookupItem> finalAry = [];
                      finalAry.clear();
                      if (itemGrp != null && itemGrp.isNotEmpty)
                        finalAry?.addAll(itemGrp);
                      if (itemModel != null && itemModel.isNotEmpty)
                        finalAry.addAll(itemModel);
                      if (itemBrand != null && itemBrand.isNotEmpty)
                        finalAry.addAll(itemBrand);
                      if (classification != null && classification.isNotEmpty)
                        finalAry?.addAll(classification);
                      if (brand != null && brand.isNotEmpty)
                        finalAry?.addAll(brand);

                      finalAry.removeWhere((element) => element == null);
                      List<ItemLookupItem> finalItemsAry = [];
                      if (items != null && items.isNotEmpty)
                        finalItemsAry.addAll(items);
                      widget.onViewDetails(
                          PricingModel(items: finalItemsAry, finalAry: finalAry));

                      Navigator.pop(context);
                    }
                  },
                  child: Text("View Details"),
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';

class PricingModel {
  ItemLookupItem item;
  List<ItemLookupItem> items;
  List<ItemGroupLookupItem> itemGrp;
  List<ItemGroupLookupItem> itemBrand;
  List<ItemGroupLookupItem> itemModel;
  List<ItemGroupLookupItem> classificationList;
  List<ItemGroupLookupItem> brandList;
  List<ItemGroupLookupItem> finalAry;
  ItemGroupLookupItem selectedGrp;
  ItemGroupLookupItem selectedBrand;
  ItemGroupLookupItem selectedItemModel;
  ItemGroupLookupItem selectedclassificationList;
  ItemGroupLookupItem selectedItemBarnd;
  ItemDetailListItems pricingData;
  DateTime date;

  PricingModel(
      {this.item,
      this.items,
      this.classificationList,
      this.brandList,
      this.itemBrand,
      this.itemGrp,
      this.itemModel,
      this.finalAry,
      this.selectedBrand,
      this.selectedclassificationList,
      this.selectedGrp,
      this.selectedItemBarnd,
      this.selectedItemModel,
      this.date,
      this.pricingData});
}

class UpdatedModel {
  String itemCode;
  String itemName;
  String uom;
  double currentRate;
  double newRate;
  UpdatedModel(
      {this.itemName, this.itemCode, this.uom, this.currentRate, this.newRate});
}

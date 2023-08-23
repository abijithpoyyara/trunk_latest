import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/services/repository/pricing/pricing_repository.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';
import 'package:redux_thunk/redux_thunk.dart';

class LocationSelectAction {
  List<StockLocation> location;
  LocationSelectAction(this.location);
}

class PricingSaveAction {}

class ViewDetailsAction {
  PricingModel item;

  ViewDetailsAction(this.item);
}

class ItemDetailsFetchAction {
  List<ItemDetailListItems> itemDeailListItems;

  ItemDetailsFetchAction(this.itemDeailListItems);
}

class LocationsFetchAction {
  List<StockLocation> locations;
  List<StockLocation> sources;
  int locationId;

  LocationsFetchAction(this.locations, this.sources, this.locationId);
}

class ItemGrpProductFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ItemGroupLookupItem> itemGrps;
  String searchQuery;
  double scrollPosition;

  ItemGrpProductFetchAction(
    this.itemGrps, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class locationLookupFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<LocationLookUpItem> locationItems;
  String searchQuery;
  double scrollPosition;

  locationLookupFetchAction(
    this.locationItems, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ItemBrandProductFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ItemGroupLookupItem> itemBrand;
  String searchQuery;
  double scrollPosition;

  ItemBrandProductFetchAction(
    this.itemBrand, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ItemModelProductFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ItemGroupLookupItem> itemModel;
  String searchQuery;
  double scrollPosition;

  ItemModelProductFetchAction(
    this.itemModel, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ClassificationProductFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ItemGroupLookupItem> classificationItems;
  String searchQuery;
  double scrollPosition;

  ClassificationProductFetchAction(
    this.classificationItems, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class BrandProductFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ItemGroupLookupItem> brandItems;
  String searchQuery;
  double scrollPosition;

  BrandProductFetchAction(
    this.brandItems, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class LocationProductsFetchAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<LocationLookUpItem> locationItems;
  String searchQuery;
  double scrollPosition;

  LocationProductsFetchAction(
    this.locationItems, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ItemsFetchedAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ProductModel> products;
  String searchQuery;
  double scrollPosition;

  ItemsFetchedAction(
    this.products, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ItemDetailClearAction {}

class LocationChangeAction {
  StockLocation selectedLocation;
  LocationChangeAction(this.selectedLocation);
}

class CopyToAnotherLocationFetchAction {
  List<StockLocation> multipleLocation;
  CopyToAnotherLocationFetchAction(this.multipleLocation);
}

class BrandListFetchAction {
  List<ItemGroupLookupItem> brandList;
  BrandListFetchAction(this.brandList);
}

class ClassificationListFetchAction {
  List<ItemGroupLookupItem> classificationList;
  ClassificationListFetchAction(this.classificationList);
}

class ItemGroupListFetchAction {
  List<ItemGroupLookupItem> itemGroupList;
  ItemGroupListFetchAction(this.itemGroupList);
}

class ItemBrandListFetchAction {
  List<ItemGroupLookupItem> itemBrandList;
  ItemBrandListFetchAction(this.itemBrandList);
}

class ItemModelListFetchAction {
  List<ItemGroupLookupItem> itemModelList;
  ItemModelListFetchAction(this.itemModelList);
}

class ItemGrpsListFetchAction {
  List<ItemGroup> itemList;
  ItemGrpsListFetchAction(this.itemList);
}

class CopyToLocationChange {
  StockLocation location;
  bool isTarget;

  CopyToLocationChange({this.location, this.isTarget});
}

class MultiLocationSelectAction {
  List<LocationLookUpItem> locationItems;
  MultiLocationSelectAction(this.locationItems);
}

class ClearListAction {
  ClearListAction();
}

ThunkAction onSearchItemGrpAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemGrpLIst(
          searchQuery: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemGrpProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Items ",
      ));

      PricingRepository().getProductList(
          optionId: optionId,
          start: start,
          code: code,
          name: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemsFetchedAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchLocationProducts(
    {String code,
    String searchQuery,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Items ",
      ));

      PricingRepository().getLocationList(
          start: 0,
          code: code,
          searchQuery: searchQuery,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(LocationProductsFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemGrpProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemGrpLIst(
          start: 0,
          code: code,
          searchQuery: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemGrpProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction onSearchItemModelAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemModelLIst(
          searchQuery: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemModelProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemBrandProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemBrandLIst(
          start: 0,
          code: code,
          searchQuery: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemBrandProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction onSearchBrandAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getBrandList(
          searchQuery: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(BrandProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchClassificationProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getClassificationLIst(
          start: 0,
          code: code,
          searchQuery: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ClassificationProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction onSearchClassificationAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getClassificationLIst(
          searchQuery: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ClassificationProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchBrandProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getBrandList(
          start: 0,
          code: code,
          searchQuery: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(BrandProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction onSearchItemBrandAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemBrandLIst(
          searchQuery: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemBrandProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemModelProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
      ));

      PricingRepository().getItemModelLIst(
          start: 0,
          code: code,
          searchQuery: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemModelProductFetchAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemGroup() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      PricingRepository().getItemGroup(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new ItemGrpsListFetchAction(response)));
    });
  };
}

ThunkAction fetchLocations() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      PricingRepository().getLocationObjects(
          onRequestSuccess: (locations, sources, locationId) => store
              .dispatch(LocationsFetchAction(locations, sources, locationId)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

// ThunkAction fetchItemDetails(
//   List<ItemLookupItem> itemDtl,
//   List<ItemGroupLookupItem> lookupDtl,
// ) {
//   return (Store store) async {
//     new Future(() async {
//       store.dispatch(new LoadingAction(
//           status: LoadingStatus.loading, message: "Getting List"));
//       PricingRepository().getItemDetails(
//           itemDtl: itemDtl,
//           lookupDtl: lookupDtl,
//           onRequestSuccess: (response) =>
//               store.dispatch(ItemDetailsFetchAction(response)),
//           onRequestFailure: (error) => store.dispatch(new LoadingAction(
//               status: LoadingStatus.error, message: error.toString())));
//     });
//   };
// }

ThunkAction fetchItemDetails(
  List<ItemLookupItem> itemDtl,
  List<ItemGroupLookupItem> lookupDtl,
) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      PricingRepository().getItemDetails(
          itemDtl: itemDtl,
          lookupDtl: lookupDtl,
          onRequestSuccess: (response) =>
              store.dispatch(ItemDetailsFetchAction(response)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

ThunkAction savePricing({
  int optionId,
  List<PricingModel> requisitionItems,
  StockLocation sourceLocation,
  StockLocation targetLocation,
  List<ItemDetailListItems> itemDetails,
  List<LocationLookUpItem> locationItems,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Pricing ",
      ));

      PricingRepository().savePricing(
        items: requisitionItems,
        optionId: optionId,
        itemDetails: itemDetails,
        sourceLocation: sourceLocation,
        targetLocation: targetLocation,
        locationItems: locationItems,
        onRequestSuccess: () => store.dispatch(new PricingSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/pricing/pricing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/widgets/screens/pricing/helpers/multiselection_formfield.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';

class LocationC extends StatefulWidget {
  final Function(PricingModel pricingModel) onViewDetails;
  final Function(List<LocationLookUpItem> locations) onMultiLocation;
  // final T selected;

  const LocationC({
    Key key,
    this.onViewDetails,
    this.onMultiLocation,
    // this.selected,
  }) : super(key: key);

  @override
  _LocationCState createState() => _LocationCState();
}

class _LocationCState extends State<LocationC> {
  ItemLookupItem selectedItem;
  ItemGroupLookupItem selectedGrp;
  ItemGroupLookupItem selectedItemModel;
  ItemGroupLookupItem selectedItemBrand;
  ItemGroupLookupItem selectedBrand;
  ItemGroupLookupItem selectedClassification;

  List<LocationLookUpItem> locations = [];
  List<ItemLookupItem> items = [];
  List<ItemGroupLookupItem> itemGrp = [];
  List<ItemGroupLookupItem> itemModel = [];
  List<ItemGroupLookupItem> itemBrand = [];
  List<ItemGroupLookupItem> brand = [];
  List<ItemGroupLookupItem> classification = [];
  List<String> itemG = [];
  List<String> itemB = [];
  List<String> itemM = [];
  List<String> brandIt = [];
  List<String> classificationIt = [];
  List<String> itemProducts = [];
  List<String> data = [];
  List<String> l = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // selectedItem = widget?.selected?.item;
    //  selectedGrp = widget.selected?.selectedGrp;
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, PricingViewModel>(
        converter: (store) => PricingViewModel.fromStore(store),
        init: (store, context) {
          // store.dispatch(fetchItemModelProducts());
          // store.dispatch(fetchItemBrandProducts());
          //store.dispatch(fetchItemGrpProducts());
          //  store.dispatch(fetchBrandProducts());
          //store.dispatch(fetchClassificationProducts());
          //  store.dispatch(fetchItemProducts());
          store.dispatch(fetchLocationProducts());
        },
        builder: (context, viewModel) {
          itemBrand = viewModel?.itemBrandItems;
          itemB.clear();
          itemBrand.forEach((element) {
            itemB.add(element.description);
          });
          itemGrp = viewModel.itemGroupItems;
          itemG.clear();
          itemGrp.forEach((element) {
            itemG.add(element.description);
          });

          locations = viewModel.locationItems;
          l.clear();
          locations.forEach((element) {
            l.add(element.name);
          });

          itemModel = viewModel.itemModelItems;
          itemM.clear();
          itemModel.forEach((element) {
            itemM.add(element.description);
          });
          classification = viewModel.classificationItems;
          classificationIt.clear();
          classification.forEach((element) {
            classificationIt.add(element.description);
          });

          brand = viewModel.brandItems;
          brandIt.clear();
          viewModel.brandItems.forEach((element) {
            brandIt.add(element.description);
          });
          items = viewModel.items;
          itemProducts.clear();
          items.forEach((element) {
            itemProducts.add(element.description);
          });
          List<ItemLookupItem> finalSelectedItemAry = [];
          // itemProducts

          return new AnimatedPadding(
            padding: EdgeInsets.zero,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new Container(
                color: BaseColors.of(context).secondaryColor,
                height: height * 1,
                //alignment: Alignment.bottomCenter,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        //SizedBox(height: height * .06),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   color: theme.colors.primaryColor,
                        //   child: Row(children: [
                        //     IconButton(
                        //       icon: Icon(
                        //         Icons.close,
                        //         color: Colors.white,
                        //       ),
                        //       onPressed: () {
                        //         Navigator.pop(context);
                        //       },
                        //     ),
                        //     SizedBox(
                        //       width: width * .03,
                        //     ),
                        //     Text("Filter",
                        //         textAlign: TextAlign.center,
                        //         style: theme.subhead1Bold.copyWith(
                        //             fontSize: 18, fontWeight: FontWeight.w500)),
                        //   ]),
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Item Group",
                        //   questionText: "Item Group",
                        //   initialValue: data ?? [],
                        //   itemList: itemG,
                        //   onChanged: (val) {
                        //     itemG = val;
                        //     print("kkk1==${itemG}");
                        //   },
                        //   onSaved: (val) {
                        //     itemG = val;
                        //     print("kkk==${itemG}");
                        //   },
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Classification",
                        //   questionText: "Classification",
                        //   initialValue: data ?? [],
                        //   itemList: classificationIt,
                        //   onSaved: (val) {
                        //     classificationIt = val;
                        //   },
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Brand",
                        //   questionText: "Brand",
                        //   initialValue: data ?? [],
                        //   itemList: brandIt,
                        //   onSaved: (val) {
                        //     brandIt = val;
                        //   },
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Item Brand",
                        //   questionText: "Item Brand",
                        //   initialValue: data ?? [],
                        //   itemList: itemB,
                        //   onSaved: (val) {
                        //     itemB = val;
                        //   },
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Item Model",
                        //   questionText: "Item Model",
                        //   initialValue: data ?? [],
                        //   itemList: itemM,
                        //   onSaved: (val) {
                        //     itemM = val;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // MultiSelectFormField(
                        //   context: context,
                        //   buttonText: "Items",
                        //   questionText: "Items",
                        //   initialValue: data ?? [],
                        //   itemList: itemProducts,
                        //   onChanged: (val) {
                        //     itemProducts = val;
                        //   },
                        //   onSaved: (val) {
                        //     itemProducts = val;
                        //     print("items${itemProducts}");
                        //   },
                        // ),

                        MultiSelectFormField(
                          context: context,
                          buttonText: "Location",
                          questionText: "Location",
                          initialValue: data ?? [],
                          itemList: l,
                          onChanged: (val) {
                            l = val;
                            print("locatopm===  ${l}");
                          },
                          onSaved: (val) {
                            l = val;
                            print("locatopm===  ${l}");
                          },
                        ),
                        SizedBox(height: height * .2),
                        Container(
                          height: MediaQuery.of(context).size.height * .06,
                          margin: EdgeInsets.only(
                              right: width * .05, left: width * .06),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width,
                          child: BaseRaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                BaseColors.of(context).selectedColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                // List<ItemGroupLookupItem> finalAryOfItemMdl = [];
                                // List<ItemGroupLookupItem> finalAry = [];
                                // itemModel?.forEach((element) {
                                //   itemM?.forEach((val) {
                                //     if (val == element.description) {
                                //       return finalAry.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });
                                //
                                // itemGrp?.forEach((element) {
                                //   itemG?.forEach((val) {
                                //     if (val == element.description) {
                                //       return finalAry.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });
                                //
                                // // List<ItemGroupLookupItem> finalAryOfItemBrand =[];
                                // itemBrand?.forEach((element) {
                                //   itemB?.forEach((val) {
                                //     if (val == element.description) {
                                //       //  return finalAryOfItemBrand.add(element);
                                //       return finalAry.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });
                                //
                                // // List<ItemGroupLookupItem>finalAryOfClassification = [];
                                // classification?.forEach((element) {
                                //   classificationIt?.forEach((val) {
                                //     if (val == element.description) {
                                //       return finalAry.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });
                                //
                                // // List<ItemGroupLookupItem> finalAryOFBrand = [];
                                // brand?.forEach((element) {
                                //   brandIt?.forEach((val) {
                                //     if (val == element.description) {
                                //       return finalAry.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });
                                //
                                // List<ItemLookupItem> finalAryOfItems = [];
                                // finalAryOfItems.clear();
                                // items?.forEach((element) {
                                //   itemProducts?.forEach((val) {
                                //     if (val == element.description) {
                                //       return finalAryOfItems.add(element);
                                //     }
                                //   }); // return finalAry.add(element);
                                // });

                                List<LocationLookUpItem> f = [];
                                f.clear();
                                locations?.forEach((element) {
                                  l?.forEach((val) {
                                    if (val == element.name) {
                                      return f.add(element);
                                    }
                                  }); // return finalAry.add(element);
                                });

                                // widget.onViewDetails(PricingModel(
                                //     items: finalAryOfItems,
                                //     finalAry: finalAry));
                                widget.onMultiLocation(f);
                                Navigator.pop(context);
                              }
                            },
                            child: Text("View Details"),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}

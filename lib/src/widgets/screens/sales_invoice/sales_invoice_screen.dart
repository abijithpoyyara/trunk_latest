import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_strings.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redstars/src/redux/actions/sales_invoice/sales_invoice_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_invoice/salesinvoice_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/partial/sales_invoice_view_list_screen.dart';

import '../../../../utility.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    var theme = BaseTheme.of(context);
    return BaseView<AppState, SalesInvoiceViewModel>(
        converter: (store) => SalesInvoiceViewModel.fromStore(store),
        init: (store, context) {
          store.dispatch(fetchInvoiceConfig());
          store.dispatch(fetchProducts());
          store.dispatch(onSearchIemAction(""));
          store.dispatch(fetchInitialList());
          store.dispatch(fetchCustomerTypes());
          store.dispatch(fetchDespatchFrom());
          store.dispatch(fetchCurrencyExchangeList());
          store.dispatch(fetchInvoiceConfig());
          store.dispatch(fetchCustomerTypes());
          //   store.dispatch(fetchBranchesList());
          store.dispatch(fetchSalesman());
          store.dispatch(fetchDespatchFrom());
          store.dispatch(fetchCustomersList());
          store.dispatch(fetchUomData());
        },
        onDidChange: (viewModel, context) {
          print("hello");
          if (viewModel.enquirySaved) {
            showSuccessDialog(
                context, "Sale invoice saved successfully", "Success", () {
              viewModel.onCartItemRemove(viewModel.cartItems);
              viewModel.saleInvoiceClear();
              // print("${viewModel.cartItems.first}");

              print("clear");
              Navigator.pop(context);
            });
          }
        },
        builder: (context, viewModel) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return Scaffold(
            // resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            appBar: BaseAppBar(
              actions: [
                isSearching
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          // size: 14,
                        ),
                        onPressed: () {
                          setState(() {
                            viewModel.onClearSearch();
                            this.isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            this.isSearching = true;
                          });
                        }),
                // Expanded(
                //   child: SearchWidget(
                //     viewModel: viewModel,
                //   ),
                // ),

                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      String message = viewModel.validateItems();
                      if (message != null && message.isEmpty) {
                        viewModel.placeEnquiry();
                      } else {
                        BaseSnackBar.of(context).show(message);
                      }
                    }),
                IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      BaseNavigate(
                          context,
                          SalesInvoiceViewList(
                            viewmodel: viewModel,
                          ));
                    }),
              ],
              title: !isSearching
                  ? Text("${BaseStrings.instance.appName} ",
                      style: theme.appBarTitle.copyWith(color: colors.white))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          // autovalidate: true,
                          enabled: true,
                          initialValue: viewModel.searchText,
                          onFieldSubmitted: (query) =>
                              viewModel.onSearch(query),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            icon: Icon(Icons.search),
                            enabledBorder: InputBorder.none,
                            hintText: "Search",
                            contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none,

                            //OutlineInputBorder(),
                            focusedBorder: InputBorder.none,
                            // UnderlineInputBorder(
                            //     borderSide: BaseBorderSide(color: Colors.transparent)),
                          ))),
              backcolor: ThemeProvider.of(context).primaryColor,
              brightness: Brightness.dark,
              useLeading: false,
              centerTitle: true,
              elevation: 8,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: (height * .15).toInt(),
                  child: viewModel.enquiryItems.isNotEmpty
                      ? ProductList(
                          viewModel: viewModel,
                        )
                      : Center(
                          child: EmptyResultView(
                              icon: Icons.remove_shopping_cart,
                              message: "No products to show",
                              onRefresh: () {
                                viewModel.onRefresh();
                              })),
                ),
                Expanded(
                    flex: (height * .3).toInt(),
                    child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: viewModel.cartItems?.length ?? 0,
                        itemBuilder: (context, position) {
                          CartItemModel item = viewModel.cartItems[position];
                          return CartProduct(
                              isQtyEditable: viewModel.isQtyUpdatable,
                              filePath: viewModel.filePath,
                              product: item,
                              onRemove: () => viewModel.onItemRemove(item),
                              onQtyUpdate: (qty) {
                                viewModel.onItemUpdate(item, qty);
                              });
                        })),

                //  viewModel.onTax(item.taxDtl);

                CartPriceDtl(
                  viewModel: viewModel,
                ),
                //     Container(
                //       height: 150,
                // color: Colors.green,
                // ),
              ],
            ),
          );

          // viewModel.enquiryItems.isNotEmpty
          //   ? ProductList(viewModel: viewModel)
          //   : Center(
          //       child: EmptyResultView(
          //           icon: Icons.remove_shopping_cart,
          //           message: "No products to show",
          //           onRefresh: () {
          //             viewModel.onRefresh();
          //           }));
        },
        onDispose: (store) {
          store.dispatch(OnClearAction());
        });
  }

  filterSortListOption(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
              child: FilterRow(
                icon: Icons.filter_list,
                title: "Filter",
                onPressed: () {
                  //filterBottomSheet(context);
                },
              ),
              flex: 30),
          Container(
            width: 2,
            color: Colors.grey.shade400,
            height: 20,
          ),
          Expanded(child: FilterRow(icon: Icons.sort, title: "Sort"), flex: 30)
        ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ProductList extends StatefulWidget {
  final SalesInvoiceViewModel viewModel;
  final VoidCallback clearCart;

  const ProductList({Key key, this.viewModel, this.clearCart})
      : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  bool _isLoading;
  AnimationController _hideSearchAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        keepScrollOffset: true,
        initialScrollOffset: widget.viewModel.scrollPosition);

    _isLoading = false;
    _hideSearchAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideSearchAnimation.forward();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoading) _loadItems();
      }
    });
  }

  _loadItems({bool initLoad = false, String searchQuery = ""}) async {
    setState(() {
      _isLoading = true;
    });
    var _scrollPosition = _scrollController.position.pixels;

    widget.viewModel.loadMoreItems(_scrollPosition);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeProvider.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          Container(
              color: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 8),
              child: RefreshIndicator(
                  onRefresh: () {
                    widget.viewModel.onRefresh();
                    return Future.delayed(
                      kThemeAnimationDuration,
                    );
                  },
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, childAspectRatio: 0.55),
                      itemCount: widget.viewModel.enquiryItems?.length ?? 0,
                      itemBuilder: (context, position) {
                        var product = widget.viewModel.enquiryItems[position];
                        return ProductItem(
                            viewModel: widget.viewModel,
                            position: position,
                            product: product,
                            filePath: widget.viewModel.filePath,
                            tag: "image $position ${product.itemcode}",
                            onProductClick: () {
                              String msg = widget.viewModel.validateItems();
                              print("MEssage ${msg}");
                              if (msg != null && msg.isEmpty) {
                                widget.viewModel.onAddToCart(product);
                                widget.viewModel.refreshCart();
                              } else {
                                BaseSnackBar.of(context).show(msg + 'gberh');
                              }
                            });
                      }))),
          // ScaleTransition(
          //     scale: _hideSearchAnimation,
          //     alignment: Alignment.bottomCenter,
          //     child: SearchWidget(viewModel: widget.viewModel)),
        ],
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideSearchAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideSearchAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            _hideSearchAnimation.forward();
            break;
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideSearchAnimation.dispose();
    super.dispose();
  }
}

class FilterRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const FilterRow({Key key, this.icon, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                ),
                SizedBox(width: 4),
                Text(title, style: BaseTheme.of(context).body2Medium)
              ])),
    );
  }
}

class ProductItem extends StatelessWidget {
  final int position;
  final ProductModel product;
  final VoidCallback onProductClick;
  final String filePath;
  final String tag;
  final SalesInvoiceViewModel viewModel;

  const ProductItem(
      {Key key,
      this.position,
      this.product,
      this.onProductClick,
      this.filePath,
      this.viewModel,
      this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme _theme = BaseTheme.of(context);
    ThemeData theme = ThemeProvider.of(context);
    return GestureDetector(
        onTap: () {
          onProductClick();
        },
        child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.all(4),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                child: Hero(
                    tag: "$tag",
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            color:
                                theme.scaffoldBackgroundColor.withOpacity(.70),
                            //color: Colors.grey.shade100,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Container(
                            height: 60,
                            child: PhotoWidget(
                                imageUrl:
                                    "${filePath + (product?.thumbnail ?? "")}")))),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(children: <Widget>[
                      Expanded(
                          child: Container(
                              child: Text("${product.itemdescription}",
                                  style:
                                      _theme.body2Medium.copyWith(fontSize: 12),
                                  textAlign: TextAlign.start),
                              alignment: Alignment.topLeft)),
                      SizedBox(height: 5),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if ((product?.actualprice ?? -1) > 0)
                              Text("${product.actualprice}",
                                  style: _theme.body2MediumHint.copyWith(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough)),
                            SizedBox(height: 1.5),
                            BaseCurrencyField(product.sellingprice,
                                style:
                                    _theme.body2Medium.copyWith(fontSize: 12)),
                            SizedBox(height: 12),
                          ])
                    ])),
              )
            ])));
  }
}

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1));

    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      tooltip: "close",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text("Filter",
                        style: theme.subhead1Bold
                            .copyWith(fontSize: 16, letterSpacing: 0.8)),
                    Text("Reset", style: theme.body2Medium)
                  ]),
              SizedBox(height: 28),
              Container(
                child: Text("Price Range", style: theme.subhead1Bold),
                margin: EdgeInsets.only(left: 4),
              ),
              SizedBox(height: 14),
              Slider(
                value: 500,
                onChanged: (double value) {},
                divisions: 100,
                min: 50,
                max: 1000,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Minimum",
                                    hintStyle: theme.body2MediumHint
                                        .copyWith(color: Colors.grey.shade800),
                                    focusedBorder: border,
                                    contentPadding: EdgeInsets.only(
                                        right: 8, left: 8, top: 12, bottom: 12),
                                    border: border,
                                    enabledBorder: border))),
                        flex: 47),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 4),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Maximum",
                                    hintStyle: theme.body2MediumHint
                                        .copyWith(color: Colors.grey.shade800),
                                    focusedBorder: border,
                                    contentPadding: EdgeInsets.only(
                                        right: 8, left: 8, top: 12, bottom: 12),
                                    border: border,
                                    enabledBorder: border))),
                        flex: 47)
                  ]),
              SizedBox(height: 16),
              Container(
                  width: double.infinity,
                  child: RaisedButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text("Apply Filter",
                          style: theme.body.copyWith(color: Colors.white)),
                      color: Colors.indigo))
            ])));
  }
}

class SearchWidget extends StatefulWidget {
  final SalesInvoiceViewModel viewModel;

  const SearchWidget({Key key, this.viewModel}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    return Container(
        height: MediaQuery.of(context).size.height * .058,
        color: colors.primaryColor,
        child: Card(
          color: BaseColors.of(context).primaryColor,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          // elevation: 2,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: TextFormField(
              initialValue: widget.viewModel.searchText,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (query) => widget.viewModel.onSearch(query),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,

                hintText: "Search",
                contentPadding: EdgeInsets.all(2),

                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 14,
                  ),
                  onPressed: () {
                    widget.viewModel.onClearSearch();
                  },
                ),
                border: InputBorder.none,
                //OutlineInputBorder(),
                focusedBorder: InputBorder.none,
                // UnderlineInputBorder(
                //     borderSide: BaseBorderSide(color: Colors.transparent)),
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ));
  }
}

class CartProduct extends StatefulWidget {
  final CartItemModel product;
  final bool isQtyEditable;
  final Function onRemove;
  final Function(int) onQtyUpdate;
  final String filePath;
  final SalesInvoiceViewModel viewModel;

  const CartProduct(
      {Key key,
      this.product,
      this.isQtyEditable,
      this.onRemove,
      this.onQtyUpdate,
      this.filePath,
      this.viewModel})
      : super(key: key);
  @override
  CartProductState createState() => CartProductState();
}

class CartProductState extends State<CartProduct> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "${widget.product.qty}";

    // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String qtyValue = _controller.text;
    double width = MediaQuery.of(context).size.width;
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return Container(
      height: height * .14,
      margin: EdgeInsets.only(bottom: 1),
      child: Column(children: [
        Container(
            decoration: BoxDecoration(
                color: colors.secondaryColor,
                border:
                    Border(bottom: BorderSide(color: colors.secondaryColor))),
            child: Column(children: [
              Row(children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                  //EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: colors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: PhotoWidget(
                    imageUrl:
                        "${widget.filePath + (widget.product?.thumbnail ?? "")}",
                    // iconSize: 34,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                    flex: 20,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("${widget.product.itemName}",
                              theme.subhead1Bold.copyWith(fontSize: 13.5)),
                          SizedBox(height: 6),
                          // buildText(
                          //     "${widget.product.itemName}",
                          //     theme.body2MediumHint.copyWith(
                          //         color: colors.white.withOpacity(.70))),
                          // SizedBox(height: 8),
                          Text(
                              BaseNumberFormat2().formatCurrency(widget
                                      .product?.rateDtl?.mrpDtl?.rateInclTax ??
                                  0.000),
                              style: theme.subhead1Bold.copyWith(
                                  color: colors.white, fontSize: 13.5)),
                          // SizedBox(height: 5),
                          SizedBox(height: 6)
                        ])),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      height: 40,
                      //MediaQuery.of(context).size.height * .06,
                      width: 60,
                      //MediaQuery.of(context).size.width * .16,
                      // width: 60.0,
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: colors.selectedColor,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              // maxLines: 2,
                              // initialValue: "${value}",
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  int value = int.parse(val);
                                  int result = value;
                                  widget.onQtyUpdate(result);
                                  //  _controller.text = result.toString();
                                });
                              },
                              controller: _controller,
                            ),
                          ),
                          // Container(
                          //   height: 45.0,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           border: Border(
                          //             bottom: BorderSide(
                          //                 width: 0.5,
                          //                 color: colors.selectedColor),
                          //           ),
                          //         ),
                          //         child: InkWell(
                          //           child: Icon(
                          //             Icons.arrow_drop_up,
                          //             size: 18.0,
                          //             color: Colors.white,
                          //           ),
                          //           onTap: () {
                          //             int currentValue =
                          //                 int.parse(_controller.text);
                          //             setState(() {
                          //               widget.onQtyUpdate(currentValue + 1);
                          //               _controller.text = (currentValue)
                          //                   .toString(); // incrementing value
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //       InkWell(
                          //         child: Icon(
                          //           Icons.arrow_drop_down,
                          //           size: 18.0,
                          //           color: Colors.white,
                          //         ),
                          //         onTap: () {
                          //           int currentValue =
                          //               int.parse(_controller.text);
                          //           setState(() {
                          //             print("Setting state");
                          //             widget.onQtyUpdate(currentValue - 1);
                          //
                          //             _controller.text = (currentValue > 0
                          //                     ? currentValue
                          //                     : 0)
                          //                 .toString(); // decrementing value
                          //           });
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),

                /*  Expanded(
                          flex: 20,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(
                                    "${product.itemName}", theme.subhead1Bold),
                                SizedBox(height: 8),
                                buildText(
                                    "${product.itemName}",
                                    theme.body2MediumHint.copyWith(
                                        color: colors.white.withOpacity(.70))),
                                SizedBox(height: 8),
                                Text(
                                    BaseNumberFormat2().formatCurrency(
                                        product?.rateDtl?.mrpDtl?.rateInclTax ??
                                            0.000),
                                    style: theme.subhead1Bold
                                        .copyWith(color: colors.white)),
                                SizedBox(height: 5),
                                SizedBox(height: 10)
                              ])),
                      Expanded(
                          flex: 6,
                          child: Column(children: [
                            // if (isQtyEditable)
                            IconButton(
                                color: Colors.white,
                                disabledColor: Colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  onQtyUpdate(product.qty + 1);
                                },
                                tooltip: "Add an item"),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration:
                                BoxDecoration(color: colors.primaryColor),
                                child:
                                // BaseTextField(
                                //   initialValue: "${product.qty}",
                                // )),
                                Text("Qty : ${product.qty}",
                                    style: theme.subhead1Semi.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400))),
                            //  if (isQtyEditable && (product?.qty ?? -1) > 0)
                            IconButton(
                                color: colors.white,
                                disabledColor: colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  onQtyUpdate(product.qty - 1);
                                },
                                tooltip: "Remove an item")
                          ]))*/
              ])
            ])),
        Row(children: [
          Container(
              width: width / 2,
              height: MediaQuery.of(context).size.height * .04,
              decoration: BoxDecoration(
                  color: colors.selectedColor,
                  border:
                      Border(right: BorderSide(color: colors.primaryColor))),
              child: FlatButton(
                  onPressed: () async {
                    var result = await baseChoiceDialog(
                            message: "Do you wish to remove the item from cart",
                            context: context) ??
                        false;
                    if (result) widget.onRemove();
                  },
                  child: Text(
                    ("Remove").toUpperCase(),
                    style: TextStyle(color: colors.white, fontSize: 13),
                  ))),
          Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height * .04,
                  color: colors.selectedColor,
                  width: width / 2,
                  child: FlatButton(
                      child: Text(("Tax Details").toUpperCase(),
                          style: TextStyle(color: colors.white, fontSize: 13)),
                      onPressed: () {
                        displayBottomSheet(context);
                      })))
        ])
      ]),
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return CartItemTaxDtlView(
            taxDtls: widget.product.rateDtl.taxes,
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

buildText(String value, TextStyle style) =>
    Align(alignment: Alignment.centerLeft, child: Text(value, style: style));

Row buildRow(String title, double value, TextStyle style) => Row(children: [
      Expanded(flex: 8, child: Text(title, style: style)),
      Expanded(
          flex: 12,
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(BaseNumberFormat2().formatCurrency(value),
                  style: style)))
    ]);

class CartPriceDtl extends StatelessWidget {
  final SalesInvoiceViewModel viewModel;

  const CartPriceDtl({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        color: themeData.primaryColor,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.only(top: 8, left: 10, right: 10),
              child: buildText(
                  "PRICE DETAILS", theme.subhead1Bold.copyWith(fontSize: 15))),
          SizedBox(
            height: 3,
          ),
          Divider(thickness: 1.5, color: themeData.scaffoldBackgroundColor),
          Padding(
              padding: EdgeInsets.only(top: 4, left: 10, right: 10),
              child: Column(children: [
                buildRow(
                    "Total Value (${viewModel.cartItems.length} items)",
                    viewModel.totalRate,
                    theme.subhead1Semi
                        .copyWith(color: colors.hintColor, fontSize: 13)),
                SizedBox(height: 5),
                buildRow(
                    "Total Tax (+)",
                    viewModel.totalTax,
                    theme.subhead1Semi
                        .copyWith(color: colors.hintColor, fontSize: 13)),
                SizedBox(height: 5),
                buildRow(
                    "With Holding Tax (-)",
                    viewModel.withHoldingTaxAmount,
                    theme.subhead1Semi
                        .copyWith(color: colors.hintColor, fontSize: 13)),
              ])),
          Divider(thickness: 1.5, color: themeData.scaffoldBackgroundColor),
          Container(
              margin: EdgeInsets.all(10),
              child: buildRow(
                  "Net Total",
                  double.parse(viewModel.grossTotal.toStringAsFixed(2)),
                  theme.subhead1Bold
                      .copyWith(color: colors.white, fontSize: 16))),
          SizedBox(height: 5)
        ]));
  }
}

class CartItemTaxDtlView extends StatelessWidget {
  final List<CartTaxDtlModel> taxDtls;

  const CartItemTaxDtlView({Key key, this.taxDtls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return Container(
        decoration: BoxDecoration(
            color: colors.secondaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Tax Details", style: theme.appBarTitle))),
                SizedBox(width: 20),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context))
              ])),
          Container(
              margin: EdgeInsets.all(20),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_con, pos) =>
                      buildTaxItem(theme, colors, taxDtls[pos]),
                  separatorBuilder: (_con, post) => Divider(),
                  itemCount: taxDtls?.length ?? 0)),
          Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.primaryColor)),
              ),
              margin: const EdgeInsets.only(right: 15, left: 15, bottom: 18),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Total Tax",
                            style: theme.appBarTitle.copyWith(fontSize: 20))),
                    Spacer(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: BaseCurrencyField(
                            taxDtls.fold(
                                0,
                                (prev, tax) =>
                                    prev + tax.taxAmt - tax.deductedTax),
                            style: theme.appBarTitle.copyWith(fontSize: 20)))
                  ])))
        ]));
  }

  buildTaxItem(
      BaseTheme theme, BaseColors colors, CartTaxDtlModel taxDtlModel) {
    String taxPerc =
        ' ${taxDtlModel.effectOnParty > 0 ? '+' : '-'} ${taxDtlModel.taxPerc}% ';
    return Row(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text("${taxDtlModel.attachmentDesc} ($taxPerc)",
              style: theme.body2Medium.copyWith(color: colors.hintColor))),
      Spacer(),
      Align(
          alignment: Alignment.centerRight,
          child: BaseCurrencyField(
              (taxDtlModel.effectOnParty > 0
                  ? taxDtlModel.taxAmt
                  : taxDtlModel.deductedTax),
              style: theme.appBarTitle)),
    ]);
  }
}

class SearchAppBar extends SearchDelegate<ProductModel> {
  final List<ProductModel> products;
  final SalesInvoiceViewModel viewModel;

  SearchAppBar(this.products, this.viewModel);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: new TextStyle(fontFamily: 'Roboto', fontSize: 12)),
        primaryColor: BaseColors.of(context).primaryColor,
        primaryIconTheme: theme.primaryIconTheme
            .copyWith(color: BaseColors.of(context).accentColor, size: 12),
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            size: 20,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, size: 20),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final productList = products.where((name) {
      final itemName = name.itemdescription != null
          ? name.itemdescription.toUpperCase()
          : "";

      final itemCode = name.itemcode != null ? name.itemcode.toUpperCase() : "";
      final itemId =
          name.itemid != null ? (name?.itemid).toString()?.toUpperCase() : "";

      return itemName.contains(query.toUpperCase()) ||
          itemCode.contains(query.toUpperCase()) ||
          itemId.contains(query.toUpperCase());
    }).toList();
    return Column(
      children: [
        Expanded(
          flex: (height * .15).toInt(),
          child: productList.isNotEmpty
              ? ProductList(
                  viewModel: viewModel,
                )
              : Center(
                  child: EmptyResultView(
                      icon: Icons.remove_shopping_cart,
                      message: "No products to show",
                      onRefresh: () {
                        viewModel.onRefresh();
                      })),
        ),
        Expanded(
            // flex: 120,
            flex: (height * .3).toInt(),
            child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.cartItems?.length ?? 0,
                itemBuilder: (context, position) {
                  CartItemModel item = viewModel.cartItems[position];
                  return CartProduct(
                      isQtyEditable: viewModel.isQtyUpdatable,
                      filePath: viewModel.filePath,
                      product: item,
                      onRemove: () => viewModel.onItemRemove(item),
                      onQtyUpdate: (qty) {
                        viewModel.onItemUpdate(item, qty);
                      });
                })),

        //  viewModel.onTax(item.taxDtl);

        CartPriceDtl(
          viewModel: viewModel,
        ),
        //     Container(
        //       height: 150,
        // color: Colors.green,
        // ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final productList = products.where((name) {
      final itemName = name.itemdescription != null
          ? name.itemdescription.toUpperCase()
          : "";

      final itemCode = name.itemcode != null ? name.itemcode.toUpperCase() : "";
      final itemId =
          name.itemid != null ? (name?.itemid).toString()?.toUpperCase() : "";

      return itemName.contains(query.toUpperCase()) ||
          itemCode.contains(query.toUpperCase()) ||
          itemId.contains(query.toUpperCase());
    }).toList();
    return Column(
      children: [
        Expanded(
          // flex: 80,
          flex: (height * .15).toInt(),
          child: productList.isNotEmpty
              ? ProductList(
                  viewModel: viewModel,
                )
              : Center(
                  child: EmptyResultView(
                      icon: Icons.remove_shopping_cart,
                      message: "No products to show",
                      onRefresh: () {
                        viewModel.onRefresh();
                      })),
        ),
        Expanded(
            //  flex: 120,
            flex: (height * .3).toInt(),
            child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.cartItems?.length ?? 0,
                itemBuilder: (context, position) {
                  CartItemModel item = viewModel.cartItems[position];
                  return CartProduct(
                      isQtyEditable: viewModel.isQtyUpdatable,
                      filePath: viewModel.filePath,
                      product: item,
                      onRemove: () => viewModel.onItemRemove(item),
                      onQtyUpdate: (qty) {
                        viewModel.onItemUpdate(item, qty);
                      });
                })),

        //  viewModel.onTax(item.taxDtl);

        CartPriceDtl(
          viewModel: viewModel,
        ),
        //     Container(
        //       height: 150,
        // color: Colors.green,
        // ),
      ],
    );
  }
}

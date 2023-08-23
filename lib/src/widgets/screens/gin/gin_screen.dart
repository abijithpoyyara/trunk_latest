import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/gin/gin_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/repository/gin/gin_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/lookup/supplier_lookup_dialog.dart';
import 'package:redstars/src/widgets/screens/gin/gin_detail_screen.dart';
import 'package:redstars/src/widgets/screens/gin/helper/gin_initial_filter_view.dart';
import 'package:redstars/src/widgets/screens/gin/view/gin_saved_list_view.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item_list_view.dart';
import 'package:redstars/utility.dart';

class GINScreen extends StatelessWidget {
  final String title;

  const GINScreen({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, GINViewModel>(
      isShowErrorSnackBar: false,
      init: (store, context) {
        // final state = store.state.ginState;
        // store.dispatch(fetchPOList(
        //   filters: state.filterRange,
        // ));
        store.dispatch(fetchGinSuppliers());
        store.dispatch(fetchInitialData());
      },
      converter: (store) => GINViewModel.fromStore(store),
      onDispose: (store) => store.dispatch(GINClearAction()),
      builder: (context, viewModel) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              GINFilterModel result = await appShowChildDialog<GINFilterModel>(
                  context: context,
                  child: GINInitialFilterDialog(
                      viewModel: viewModel,
                      ginInitialModel: GINFilterModel(
                          fromDate: viewModel.ginInitialFilter.fromDate,
                          //viewModel.fromDate,
                          toDate: viewModel.ginInitialFilter.toDate,
                          //viewModel.toDate,
                          supplier: viewModel.ginInitialFilter.supplier,
                          transNo: viewModel.ginInitialFilter.transNo)));
              viewModel.onSaveGINFilterModelData(result);
              viewModel.onChangeGINFilter(result);
              viewModel.onFilterApply(GINFilterModel(
                  fromDate: viewModel.ginInitialFilter.fromDate,
                  //viewModel.fromDate,
                  toDate: viewModel.ginInitialFilter.toDate,
                  //viewModel.toDate,
                  supplier: viewModel.ginInitialFilter.supplier,
                  transNo: viewModel.ginInitialFilter.transNo));
            },
            child: Icon(
              Icons.filter_list,
              color: themeData.primaryColorDark,
            ),
          ),
          appBar: BaseAppBar(
            title: Text(title ?? "Goods Inspect Note"),
            actions: [
              IconButton(
                  onPressed: () {
                    BaseNavigate(
                        context,
                        GINSavedViewListPage(
                          viewmodel: viewModel,
                        ));
                  },
                  icon: Icon(Icons.list))
            ],
          ),
          body: _GINScreenBody(
            viewModel: viewModel,
          ),
          // RefreshIndicator(
          //   onRefresh: () {
          //     return Future.delayed(kThemeChangeDuration);
          //   },
          //   child:
          //   _GINScreenBody(
          //     viewModel: viewModel,
          //   ),
          // ),
        );
      },
    );
  }
}

class _GINScreenBody extends StatefulWidget {
  final GINViewModel viewModel;

  const _GINScreenBody({Key key, this.viewModel}) : super(key: key);

  @override
  _GINScreenBodyState createState() => _GINScreenBodyState();
}

class _GINScreenBodyState extends State<_GINScreenBody> {
  ScrollController _scrollController;

  bool _isLoading;
  bool _isLoadingLess;
  int start = 0;
  int limit;
  List<PoModel> pokhatList;
  List<PoModel> pokhatList2;
  @override
  void initState() {
    super.initState();
    pokhatList = [];
    pokhatList2 = [];
    start = 0;
    _isLoading = false;
    limit = 10;
    _loadItems(initLoad: true);
    _scrollController = ScrollController(
      initialScrollOffset: widget.viewModel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _scrollController.addListener(() {
      if (_scrollController?.position.pixels ==
          _scrollController?.position.maxScrollExtent) {
        if (pokhatList2.length < pokhatList.first.totalRecords) {
          if (!_isLoading) _loadItems();
        }
      }
    });
  }

  _loadItems({bool initLoad = false}) async {
    print("initload called");
    setState(() {
      _isLoading = true;
      if (initLoad) start = 0;
    });
    await GINRepository().getPurchaseOrders(
        filter: GINFilterModel(
            fromDate: widget.viewModel.ginInitialFilter.fromDate,
            toDate: widget.viewModel.ginInitialFilter.toDate,
            supplier: widget.viewModel.ginInitialFilter.supplier,
            transNo: widget.viewModel.ginInitialFilter.transNo),
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                pokhatList = [];
                _isLoading = false;
                start = null;
              })
            },
        onRequestSuccess: (result) => setState(() {
              _isLoading = false;
              if (initLoad) {
                print("initLoad called");
                print("purchase----${pokhatList.length}");
                pokhatList2 = result;
                pokhatList = result;
              } else {
                print("secd called");
                pokhatList.addAll(result);
                print("purchase----${result}");
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);

    return ListView(controller: _scrollController, children: [
      Builder(
        builder: (context) {
          final innerScrollController = PrimaryScrollController.of(context);
          return pokhatList.length > 0
              ? POList(
                  isPoLoading: _isLoading,
                  orders: pokhatList,
                  viewModel: widget.viewModel,
                  scrollOffset: widget.viewModel.scrollPosition,
                  scrollController: innerScrollController,
                )
              : _EmptyListView();
        },
      ),
    ]);
  }

  Widget getFilterWidget(bool isExpanded, GINViewModel viewModel) {
    return Builder(builder: (BuildContext context) {
      BaseTheme style = BaseTheme.of(context);
      final colors = BaseTheme.of(context).colors;
      ThemeData themeData = ThemeProvider.of(context);
      return (viewModel.purchaseOrders != null)
          ? Container(
              decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  border: Border(
                    top:
                        BorderSide(color: themeData.primaryColorDark, width: 2),
                    bottom:
                        BorderSide(color: themeData.primaryColorDark, width: 2),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RichText(
                  text: TextSpan(
                      text: "Showing results from ",
                      style:
                          style.bodyHint.copyWith(color: themeData.accentColor),
                      children: [
                    TextSpan(
                        text:
                            BaseDates(viewModel.fromDate, month: 'MMM').format,
                        style: style.body2Medium
                            .copyWith(color: themeData.accentColor)),
                    TextSpan(
                        text: " to ",
                        style: style.bodyHint
                            .copyWith(color: themeData.accentColor)),
                    TextSpan(
                        text: BaseDates(viewModel.toDate, month: 'MMM').format,
                        style: style.body2Medium
                            .copyWith(color: themeData.accentColor))
                  ])))
          : Container();
    });
  }
}

class POList extends StatefulWidget {
  final List<PoModel> orders;
  final ScrollController scrollController;
  final double scrollOffset;
  final bool isPoLoading;
  final Function(
    double,
    int,
  ) loadMoreItems;
  final Function(
    double,
    int,
  ) loadLessItems;
  final Future<void> Function() onRefresh;
  final GINViewModel viewModel;

  const POList(
      {Key key,
      this.onRefresh,
      this.scrollController,
      this.loadMoreItems,
      this.loadLessItems,
      this.orders,
      this.scrollOffset,
      this.isPoLoading,
      this.viewModel})
      : super(key: key);

  @override
  POListState createState() => POListState();
}

class POListState extends State<POList> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // if (widget.orders.isNotEmpty && widget.orders.length != null)
    return ListView.builder(
        // controller: widget.scrollController,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.isPoLoading
            ? widget.orders.length + 1 ?? 0
            : widget.orders.length,
        itemBuilder: (BuildContext context, int index) => (widget.isPoLoading ==
                    true &&
                index == widget.orders?.length &&
                widget.orders.length > 0)
            ? Padding(padding: EdgeInsets.all(8), child: BaseLoadingSpinner())
            : POListItem(
                order: widget.orders[index],
                onTap: () {
                  return BaseNavigate(
                      context,
                      GINDetailScreen(
                        order: widget.orders[index],
                        viewModel: widget.viewModel,
                      ));
                },
              ));
    // : _EmptyListView();
    // final order = widget.orders[index];
    // return POListItem(
    //   order: order,
    //   onTap: () {
    //     return BaseNavigate(
    //         context,
    //         GINDetailScreen(
    //           order: order,
    //           viewModel: widget.viewModel,
    //         ));
    //   },
    // );
    //   })
    //: _EmptyListView();
  }
}

class _EmptyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // ListView(children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.done, color: Colors.green, size: 54),
                  SizedBox(height: 4),
                  Text("All Caught up",
                      style: BaseTheme.of(context).body.copyWith(fontSize: 18))
                ]));
  }
}

class POListItem extends StatelessWidget {
  final PoModel order;
  final VoidCallback onTap;

  const POListItem({
    Key key,
    this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = BaseTheme.of(context);
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 12),
                      child: InkWell(
                          onTap: onTap,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 12.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("${order.transactionNo}",
                                          style: style.subhead1),
                                    ),
                                    Text("${order.status}"),
                                    SizedBox(width: 4.0),
                                  ],
                                ),
                                Text("${order.transactionDate}"),
                                SizedBox(height: 4.0),
                                Text(
                                    order.supplierName?.isEmpty ?? true
                                        ? ""
                                        : BaseStringCase(
                                                '${order.supplierName}')
                                            .titleCase,
                                    style: style.body),
                                SizedBox(height: 12.0)
                              ])))),
            ])));
  }
}

class _SearchWidget extends StatefulWidget {
  final String searchQuery;
  final ValueSetter<String> onQuery;

  const _SearchWidget({Key key, this.searchQuery, this.onQuery})
      : super(key: key);

  @override
  __SearchWidgetState createState() => __SearchWidgetState();
}

class __SearchWidgetState extends State<_SearchWidget> {
  bool isSearchEmpty;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery);
    isSearchEmpty = widget.searchQuery?.trim()?.isEmpty ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      BaseTheme theme = BaseTheme.of(context);
      final colors = BaseTheme.of(context).colors;
      ThemeData themeData = ThemeProvider.of(context);

      return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: Container(
                        decoration: BoxDecoration(
                          color: themeData.scaffoldBackgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(38.0)),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 22),
                            child: TextFormField(
                                style: theme.body2MediumHint.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                cursorColor: themeData.scaffoldBackgroundColor,
                                controller: _textController,
                                onFieldSubmitted: widget.onQuery,
                                onChanged: (val) {
                                  setState(() => isSearchEmpty = val.isEmpty);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Tap to search trans No.',
                                    hintStyle: theme.body2MediumHint.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal))))))),
            Container(
                decoration: BoxDecoration(
                  color: themeData.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.onQuery(_textController.text.toString());
                          _textController.clear();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: AnimatedSwitcher(
                              duration: Duration(seconds: 5),
                              child: Icon(
                                // icon: AnimatedIcons.search_ellipsis,
                                isSearchEmpty
                                    ? Icons.search_outlined
                                    : Icons.search_outlined,
                                // progress: controller,
                                size: 20,
                                color: colors.white,
                              ),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            )))))
          ]));
    });
  }
}

class _FilterWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTimeRange, SupplierLookupItem) onFilter;
  final SupplierLookupItem supplier;

  const _FilterWidget({
    Key key,
    @required this.startDate,
    @required this.endDate,
    this.onFilter,
    this.supplier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      BaseTheme theme = BaseTheme.of(context);
      final colors = BaseTheme.of(context).colors;
      ThemeData themeData = ThemeProvider.of(context);
      SupplierLookupItem s;

      return Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 16),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showDateFilterDialog(
                            context,
                            fromDate: startDate,
                            toDate: endDate,
                            onSubmit: (range) => onFilter(range, supplier),
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Choose Date',
                                      style: theme.bodyHint
                                          .copyWith(color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Text(
                                      '${BaseDates(startDate, dd: "dd", month: "MMM", year: 'yy').format} - ${BaseDates(endDate, dd: "dd", month: "MMM", year: 'yy').format}',
                                      style: theme.body2Medium
                                          .copyWith(color: Colors.white))
                                ])))),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                        width: 1,
                        height: 42,
                        color: themeData.primaryColorDark.withOpacity(.4))),
                Expanded(
                    child: InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final supplier = await supplierLookupDialog(
                            title: "Supplier",
                            context: context,
                            flag: 0,
                          );

                          if (supplier != null) {
                            onFilter(
                                DateTimeRange(
                                  start: startDate,
                                  end: endDate,
                                ),
                                supplier);
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Supplier',
                                      style: theme.bodyHint
                                          .copyWith(color: Colors.white)),
                                  const SizedBox(height: 8),
                                  if (supplier != null)
                                    DocumentTypeWidget(
                                      docName: s.name,
                                      icon: Icons.person.codePoint,
                                    )
                                  else
                                    Text('Tap to select ',
                                        style: theme.body2MediumHint
                                            .copyWith(color: Colors.white))
                                ]))))
              ]),
        ),
      );
    });
  }
}

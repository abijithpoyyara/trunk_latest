import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/repository/back_dated_entry_permission/back_dated_entry_permission_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/lookup/supplier_lookup_dialog.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/back_date_main_page.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item_list_view.dart';
import 'package:redstars/utility.dart';

import 'filter_dialog.dart';

class BackDateViewScreenPage extends StatelessWidget {
  final String title;

  const BackDateViewScreenPage({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return BaseView<AppState, BackDatedEntryViewModel>(
      isShowErrorSnackBar: false,
      init: (store, context) {
        final state = store.state.backDatedEntryState;
        // store.dispatch(fetchBackDateList(
        //   filters: state.filterRange,
        // ));
        store.dispatch(
            fetchBackDateView(backDateFilterModel: state.backDateFilterModel));
      },
      converter: (store) => BackDatedEntryViewModel.fromStore(store),
      onDispose: (store) => store.dispatch(OnClearFunction()),
      builder: (context, viewModel) {
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     GINFilterModel result = await appShowChildDialog<GINFilterModel>(
          //         context: context,
          //         child: GINInitialFilterDialog(
          //             viewModel: viewModel,
          //             ginInitialModel: GINFilterModel(
          //                 fromDate: viewModel.ginInitialFilter.fromDate,
          //                 //viewModel.fromDate,
          //                 toDate: viewModel.ginInitialFilter.toDate,
          //                 //viewModel.toDate,
          //                 supplier: viewModel.ginInitialFilter.supplier,
          //                 transNo: viewModel.ginInitialFilter.transNo)));
          //     viewModel.onSaveGINFilterModelData(result);
          //     viewModel.onChangeGINFilter(result);
          //     viewModel.onFilterApply(GINFilterModel(
          //         fromDate: viewModel.ginInitialFilter.fromDate,
          //         //viewModel.fromDate,
          //         toDate: viewModel.ginInitialFilter.toDate,
          //         //viewModel.toDate,
          //         supplier: viewModel.ginInitialFilter.supplier,
          //         transNo: viewModel.ginInitialFilter.transNo));
          //   },
          //   child: Icon(
          //     Icons.filter_list,
          //     color: themeData.primaryColorDark,
          //   ),
          // ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.filter_list,
              color: themeData.primaryColor,
            ),
            onPressed: () async {
              BackDateFilterModel result = await appShowChildDialog<
                      BackDateFilterModel>(
                  context: context,
                  child: BackDateFilterDialog(
                      viewModel: viewModel,
                      model: BackDateFilterModel(
                          periodFrom: viewModel
                                  ?.backDateFilterModel?.periodFrom ??
                              startDate,
                          periodTo: viewModel?.backDateFilterModel?.periodTo ??
                              currentDate,
                          isActive:
                              viewModel?.backDateFilterModel?.isActive ?? true,
                          branch: viewModel?.backDateFilterModel?.branch,
                          option: viewModel?.backDateFilterModel?.option,
                          transNo: viewModel?.backDateFilterModel?.transNo)));
              viewModel.onSaveFilter(result);

              viewModel.onChangeViewData(BackDateFilterModel(
                  periodFrom: viewModel.backDateFilterModel.periodFrom,
                  periodTo: viewModel.backDateFilterModel.periodTo,
                  isActive: viewModel.backDateFilterModel.isActive,
                  branch: viewModel.backDateFilterModel.branch,
                  option: viewModel.backDateFilterModel.option,
                  transNo: viewModel.backDateFilterModel.transNo));
            },
          ),
          appBar: BaseAppBar(
            title: Text(title ?? "Back Date Entry Permission"),
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         BaseNavigate(
            //             context,
            //             GINSavedViewListPage(
            //               viewmodel: viewModel,
            //             ));
            //       },
            //       icon: Icon(Icons.list))
            // ],
          ),
          body: _BackDateScreenBody(
            viewModel: viewModel,
          ),
          // RefreshIndicator(
          //   onRefresh: () {
          //     return Future.delayed(kThemeChangeDuration);
          //   },
          //   child:
          //   _BackDateScreenBody(
          //     viewModel: viewModel,
          //   ),
          // ),
        );
      },
    );
  }
}

class _BackDateScreenBody extends StatefulWidget {
  final BackDatedEntryViewModel viewModel;

  const _BackDateScreenBody({Key key, this.viewModel}) : super(key: key);

  @override
  _BackDateScreenBodyState createState() => _BackDateScreenBodyState();
}

class _BackDateScreenBodyState extends State<_BackDateScreenBody> {
  ScrollController _scrollController;

  bool _isLoading;
  bool _isLoadingLess;
  int start = 0;
  int limit;
  List<BackDateViewDetails> backDateViewList;
  List<BackDateViewDetails> backDateViewList2;
  @override
  void initState() {
    super.initState();
    backDateViewList = [];
    backDateViewList2 = [];
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
        if (backDateViewList2.length < backDateViewList.first.totalrecords) {
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
    await BackDatedEntryRepository().getBacDateViewDtlList(
        backDateFilterModel: BackDateFilterModel(
            periodFrom: widget.viewModel.backDateFilterModel?.periodFrom,
            periodTo: widget.viewModel.backDateFilterModel?.periodTo,
            isActive: widget.viewModel.backDateFilterModel?.isActive,
            branch: widget.viewModel.backDateFilterModel?.branch,
            option: widget.viewModel.backDateFilterModel?.option,
            transNo: widget.viewModel.backDateFilterModel?.transNo),
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                backDateViewList = [];
                _isLoading = false;
                start = null;
              })
            },
        onRequestSuccess: (result) => setState(() {
              _isLoading = false;
              if (initLoad) {
                print("initLoad called");
                print("purchase----${backDateViewList.length}");
                backDateViewList = result;
                backDateViewList = result;
              } else {
                print("secd called");
                backDateViewList.addAll(result);
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
          return backDateViewList.length > 0
              ? BackDateList(
                  isPoLoading: _isLoading,
                  orders: backDateViewList,
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

class BackDateList extends StatefulWidget {
  final List<BackDateViewDetails> orders;
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
  final BackDatedEntryViewModel viewModel;

  const BackDateList(
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
  BackDateListState createState() => BackDateListState();
}

class BackDateListState extends State<BackDateList>
    with SingleTickerProviderStateMixin {
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
            : GestureDetector(
                onTap: () {
                  widget.viewModel.getDetailViewList(widget.orders[index]);
                  BaseNavigate(
                      context,
                      BackDatedEntryView(
                        title: widget.orders[index].transno,
                      ));
                },
                child: BackDateListItem(
                  order: widget.orders[index],
                  // onTap: () {
                  //   return BaseNavigate(
                  //       context,
                  //       GINDetailScreen(
                  //         order: widget.orders[index],
                  //         viewModel: widget.viewModel,
                  //       ));
                  // },
                ),
              ));
    // : _EmptyListView();
    // final order = widget.orders[index];
    // return BackDateListItem(
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

class BackDateListItem extends StatelessWidget {
  final BackDateViewDetails order;
  final VoidCallback onTap;

  const BackDateListItem({
    Key key,
    this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = BaseTheme.of(context);
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    return Column(
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
                      "Trans No:",
                      style: theme.body2Medium.copyWith(
                          fontSize: 12,
                          letterSpacing: .3,
                          color: themeData.accentColor.withOpacity(.5)),
                    ),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text((order.transno) ?? "".toUpperCase(),
                        style: theme.textfield.copyWith(
                            letterSpacing: 1,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Valid Upto:",
                        style: theme.body2Medium.copyWith(
                            fontSize: 12,
                            letterSpacing: .3,
                            color: themeData.accentColor.withOpacity(.5))),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text(((order.validupto) ?? ""),
                        style: theme.textfield.copyWith(
                            letterSpacing: 1,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Option:",
                        style: theme.body2Medium.copyWith(
                            fontSize: 12,
                            letterSpacing: .3,
                            color: themeData.accentColor.withOpacity(.5))),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text(((order.optionname) ?? "").toUpperCase(),
                        style: theme.textfield.copyWith(
                            letterSpacing: .1,
                            fontSize: 13,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Branch:",
                        maxLines: 5,
                        style: theme.body2Medium.copyWith(
                            fontSize: 14,
                            letterSpacing: .1,
                            color: themeData.accentColor.withOpacity(.5))),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text(((order.branchname).toUpperCase() ?? ""),
                        style: theme.textfield.copyWith(
                            letterSpacing: 1,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Period From:",
                        style: theme.body2Medium.copyWith(
                            fontSize: 12,
                            letterSpacing: .3,
                            color: themeData.accentColor.withOpacity(.5))),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text(((order.periodfrom) ?? "").toUpperCase(),
                        style: theme.textfield.copyWith(
                            letterSpacing: 1,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Period To:",
                        style: theme.body2Medium.copyWith(
                            fontSize: 12,
                            letterSpacing: .3,
                            color: themeData.accentColor.withOpacity(.5))),
                    SizedBox(
                      height: 1.5,
                    ),
                    Text(((order.periodto) ?? "").toUpperCase(),
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
      ],
    );

    // return Container(
    //     margin: EdgeInsets.all(6),
    //     decoration: BoxDecoration(
    //       color: themeData.primaryColor,
    //       borderRadius: BorderRadius.circular(12.0),
    //     ),
    //     child: IntrinsicHeight(
    //         child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //           Expanded(
    //               child: Container(
    //                   margin: EdgeInsets.only(left: 12),
    //                   child: InkWell(
    //                       onTap: onTap,
    //                       child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             SizedBox(height: 12.0),
    //                             Row(
    //                               children: [
    //                                 Expanded(
    //                                   child: Text("${order.branchname}",
    //                                       style: style.subhead1),
    //                                 ),
    //                                 Text("${order.optionname}"),
    //                                 SizedBox(width: 4.0),
    //                               ],
    //                             ),
    //                             Text("${order.transno}"),
    //                             SizedBox(height: 4.0),
    //                             Text(
    //                                 order.periodfrom?.isEmpty ?? true
    //                                     ? ""
    //                                     : BaseStringCase('${order.periodfrom}')
    //                                         .titleCase,
    //                                 style: style.body),
    //                             SizedBox(height: 12.0)
    //                           ])))),
    //         ])));
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

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/po_acknowledgement/purchase_order_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/po_acknowledge/po_acknowledge_detail_screen.dart';
import 'package:redstars/utility.dart';

import '_views/filter_view.dart';

class POAcknowledgeScreen extends StatefulWidget {
  final String title;

  const POAcknowledgeScreen({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  _POAcknowledgeScreenState createState() => _POAcknowledgeScreenState();
}

class _POAcknowledgeScreenState extends State<POAcknowledgeScreen> {
  POAckSupplierLookupItem selectedItem;

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    final colors = BaseTheme.of(context).colors;
    return BaseView<AppState, AcknowledgeViewModel>(
      converter: (store) => AcknowledgeViewModel.fromStore(store),
      appBar: BaseAppBar(
        // backcolor: colors.primaryColor,
        title: Text(widget.title ?? "PO Acknowledgement"),
      ),
      onDispose: (store) => store.dispatch(OnClearAction('POA')),
      builder: (context, viewModel) {
        return Container(
          color: themedata.scaffoldBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    BaseNestedTabBar(
                      color: themedata.primaryColor,
                      labelColor: colors.white,
                      tabs: [
                        BaseTabPage(
                            title: 'Pending',
                            body: viewModel.loadingStatus ==
                                    LoadingStatus.loading
                                ? BaseLoadingView(
                                    message: viewModel.loadingMessage,
                                  )
                                : POList(
                                    type: AcknowledgeType.PENDING,
                                    orders: viewModel.pendingOrders,
                                    onSelect: (selected) {},
                                    scrollPosition:
                                        viewModel.pendingScrollOffset,
                                    onRefresh: () => viewModel
                                        .onRefresh(AcknowledgeType.PENDING),
                                    loadMoreItems: (position) =>
                                        viewModel.onLoadMore(
                                            AcknowledgeType.PENDING, position),
                                    supplierId: viewModel.supplierObj?.id)),
                        BaseTabPage(
                            title: 'Processing',
                            body: viewModel.loadingStatus ==
                                    LoadingStatus.loading
                                ? BaseLoadingView(
                                    message: viewModel.loadingMessage,
                                  )
                                : POList(
                                    scrollPosition:
                                        viewModel.processingScrollOffset,
                                    type: AcknowledgeType.PROCESSING,
                                    orders: viewModel.processingOrders,
                                    onSelect: (selected) {},
                                    loadMoreItems: (position) =>
                                        viewModel.onLoadMore(
                                            AcknowledgeType.PROCESSING,
                                            position),
                                    onRefresh: () => viewModel
                                        .onRefresh(AcknowledgeType.PROCESSING),
                                    supplierId: viewModel.supplierObj?.id)),
                        BaseTabPage(
                            title: 'Completed',
                            body: viewModel.loadingStatus ==
                                    LoadingStatus.loading
                                ? BaseLoadingView(
                                    message: viewModel.loadingMessage,
                                  )
                                : POList(
                                    loadMoreItems: (position) =>
                                        viewModel.onLoadMore(
                                            AcknowledgeType.COMPLETED,
                                            position),
                                    scrollPosition:
                                        viewModel.completedScrollOffset,
                                    type: AcknowledgeType.COMPLETED,
                                    orders: viewModel.completedOrders,
                                    onSelect: (selected) {},
                                    onRefresh: () => viewModel
                                        .onRefresh(AcknowledgeType.COMPLETED),
                                    supplierId: viewModel.supplierObj?.id)),
                      ],
                    ),
                    Positioned(
                        right: 12,
                        bottom: 24,
                        child: FloatingActionButton(
                          backgroundColor: colors.accentColor,
                          onPressed: () async {
                            POFilterModel result =
                                await appShowChildDialog<POFilterModel>(
                                    context: context,
                                    child: FilterDialog(
                                        viewModel: viewModel,
                                        model: POFilterModel(
                                          fromDate: viewModel.startDate,
                                          toDate: viewModel.endDate,
                                          supplier: viewModel.supplierObj,
                                        )));
                            viewModel.saveModelVar(result);
                          },
                          child: Icon(
                            Icons.filter_list_outlined,
                            color: themedata.primaryColorDark,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class POList extends StatefulWidget {
  final List<PurchaseOrderModel> orders;
  final ValueSetter<PurchaseOrderModel> onSelect;
  final Future<void> Function() onRefresh;
  final AcknowledgeType type;
  final double scrollPosition;
  final Function(double) loadMoreItems;
  final int supplierId;

  const POList({
    Key key,
    @required this.orders,
    @required this.onSelect,
    this.onRefresh,
    this.type,
    this.scrollPosition,
    this.loadMoreItems,
    this.supplierId,
  }) : super(key: key);

  @override
  _POListState createState() => _POListState();
}

class _POListState extends State<POList> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        keepScrollOffset: true, initialScrollOffset: widget.scrollPosition);

    _isLoading = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels !=
              _scrollController.position.minScrollExtent &&
          _scrollController.position.pixels ==
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
    widget.loadMoreItems(_scrollPosition);
  }

  @override
  Widget build(BuildContext context) {
    final _colors = BaseTheme.of(context).colors;
    return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: widget.orders.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.orders.length ?? 10,
                itemBuilder: (BuildContext context, int index) {
                  final order = widget.orders[index];
                  return POListItem(
                    order: order,
                    onTap: () {
                      return BaseNavigate(
                          context,
                          POADetailScreen(
                              order: order,
                              type: widget.type,
                              supplierId: widget.supplierId));
                    },
                  );
                })
            : _EmptyListView());
  }
}

class _EmptyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _colors = BaseTheme.of(context).colors;
    return ListView(children: [
      Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.done, color: Colors.green, size: 54),
                SizedBox(height: 4),
                Text(
                  "All Caught up",
                  /*style: BaseTheme.of(context).style.body2.copyWith(fontSize: 18,color: _colors.white)*/
                )
              ]))
    ]);
  }
}

class POListItem extends StatelessWidget {
  final PurchaseOrderModel order;
  final VoidCallback onTap;

  const POListItem({
    Key key,
    this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = BaseTheme.of(context).style;
    final colors = BaseTheme.of(context).colors;
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: themedata.primaryColor,
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
                                      child: Text(
                                        "${order.transNo}",
                                        /*style: BaseTheme.of(context).subhead3.semiMedium.copyWith(color: colors.accentColor)*/
                                      ),
                                    ),
                                    Text(
                                      "${order.transDate}",
                                      style:
                                          TextStyle(color: colors.accentColor),
                                    ),
                                    SizedBox(width: 4.0),
                                  ],
                                ),
                                if (order.remarks?.isNotEmpty ?? false)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: colors.accentColor
                                                .withOpacity(.45)),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      order.remarks?.isEmpty ?? true
                                          ? ""
                                          : BaseStringCase(order.remarks)
                                              .sentenceCase,
                                    ),
                                  ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _InfoTile(
                                        icon: Icons.location_on_outlined,
                                        value: order.branchName,
                                      ),
                                    ),
                                    if (order.ackDateTime != null)
                                      Expanded(
                                        flex: 2,
                                        child: _InfoTile(
                                          icon: Icons
                                              .check_circle_outline_outlined,
                                          value: order.ackDateTime,
                                        ),
                                      )
                                  ],
                                ),
                                SizedBox(height: 12.0)
                              ])))),
            ])));
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoTile({Key key, this.icon, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Icon(icon, size: 12),
      Expanded(
          child: Text(
        '$value',
        style: BaseTheme.of(context).smallHint,
      ))
    ]);
  }
}

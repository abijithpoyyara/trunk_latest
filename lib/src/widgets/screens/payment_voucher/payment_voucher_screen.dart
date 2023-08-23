import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/payment_voucher/payment_voucher_viewmodel.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/payment_voucher_process_from_view.dart';

import '../../../../utility.dart';
import 'helper/filter_view.dart';
import 'model/filter_model.dart';

class PaymentVoucherListScreen extends StatelessWidget {
  const PaymentVoucherListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themedata = ThemeProvider.of(context);
    return BaseView<AppState, PaymentVoucherViewModel>(
      appBar: BaseAppBar(title: Text("Payment Voucher")),
      init: (store, _cont) {
        final state = store.state.paymentVoucherState;
        store.dispatch(fetchVoucherInitialData());
        store.dispatch(fetchCurrencyExchangeList());
        store.dispatch(fetchVoucherPurchaseList(
            filterRange:
                PVFilterModel(fromDate: state.fromDate, toDate: state.toDate),
            transNo: ""));
      },
      converter: (store) => PaymentVoucherViewModel.fromStore(store),
      builder: (con, viewModel) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              PVFilterModel result = await appShowChildDialog(
                  context: context,
                  child: FilterDialog(
                      viewModel: viewModel,
                      model: PVFilterModel(
                        fromDate: viewModel?.fromDate,
                        toDate: viewModel?.toDate,
                      )));
              viewModel.saveModelVar(result);
            },
            child: Icon(
              Icons.filter_list,
              color: themedata.primaryColorDark,
            ),
          ),
          body: Container(
            color: themedata.scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: POList(
                    orders: viewModel.voucherPurchaseOrderList,
                    onRefresh: () {
                      return viewModel.onRefresh();
                    },
                    loadMoreItems: (model) {},
                    scrollPosition: 1,
                  ),
                )
              ],
            ),
          ),
        );
      },
      onDispose: (store) => store.dispatch(OnClearAction()),
    );
  }
}

class POList extends StatefulWidget {
  final List<VoucherPurchaseOder> orders;
  final Function() onRefresh;
  final double scrollPosition;
  final Function(double) loadMoreItems;

  const POList({
    Key key,
    @required this.orders,
    this.onRefresh,
    this.scrollPosition,
    this.loadMoreItems,
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
    ThemeData themedata = ThemeProvider.of(context);
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
                    poData: order,
                    onTap: () {
                      return BaseNavigate(
                          context,
                          PaymentVoucherProcessFrom(
                            title: order.transno,
                            processedData: order,
                          ));
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
    ThemeData themedata = ThemeProvider.of(context);
    return ListView(children: [
      Container(
          color: themedata.scaffoldBackgroundColor,
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
  final VoucherPurchaseOder poData;
  final VoidCallback onTap;

  const POListItem({
    Key key,
    this.poData,
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
                                        "${poData.transno}",
                                        /*style: BaseTheme.of(context).subhead3.semiMedium.copyWith(color: colors.accentColor)*/
                                      ),
                                    ),
                                    Text(
                                      "${poData.transactiondate}",
                                      style:
                                          TextStyle(color: colors.accentColor),
                                    ),
                                    SizedBox(width: 4.0),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _InfoTile(
                                        icon: Icons.person_pin_outlined,
                                        value: poData.suppliername,
                                      ),
                                    ),
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

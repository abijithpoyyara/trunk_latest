import 'package:base/redux.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/requisition/stock_requisition/stock_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';
import 'package:redstars/utility.dart';

class ItemGradeRateViewCard extends StatelessWidget {
  final ItemGradeRateSubModel selectedItem;

  const ItemGradeRateViewCard({Key key, this.selectedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStore<AppState, StockRequisitionViewModel>(
        converter: (store) => StockRequisitionViewModel.fromStore(store),
        init: (store, con) =>
            store.dispatch(fetchStockDetails(selectedItem?.item)),
        onDidChange: (viewModel, context) {
          if (viewModel.stockDtlLoading == LoadingStatus.error) {
            BaseSnackBar.of(context).show(viewModel.loadingError);
          }
        },
        builder: (con, viewModel) {
          return viewModel.stockDtlLoading == LoadingStatus.loading
              ? BaseLoadingView(message: viewModel.loadingMessage)
              : BaseListDialog<StockDetail>(
                  title: selectedItem.item.description,
                  builder: (stock, position) => _StockItem(
                    title: stock.businessLevelName,
                    qty: stock.closingBookStockQty,
                    itemName: stock.itemName,
                    uomName: stock.uomName,
                  ),
                  list: viewModel.stockDetails,
                );
        });
  }
}

class _StockItem extends StatelessWidget {
  final String title;
  final String itemName;
  final String uomName;
  final double qty;

  const _StockItem({Key key, this.title, this.itemName, this.uomName, this.qty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);

    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border(bottom: BaseBorderSide())),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.subhead1),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(itemName, style: theme.body),
                  ),
                ],
              )),
              SizedBox(width: 22),
              Column(
                children: <Widget>[
                  Text("${qty}"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(uomName, style: theme.body),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

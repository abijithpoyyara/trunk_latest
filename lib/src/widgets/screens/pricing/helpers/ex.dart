import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/pricing/pricing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
import 'package:redstars/src/widgets/screens/pricing/helpers/dynamic_checkbox.dart';

class ItemGrp extends StatelessWidget {
  final PricingViewModel viewModel;

  const ItemGrp({Key key, this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PricingViewModel>(
        converter: (store) => PricingViewModel.fromStore(store),
        init: (store, context) {
          store.dispatch(fetchItemModelProducts());
          store.dispatch(fetchItemBrandProducts());
          store.dispatch(fetchItemGrpProducts());
          store.dispatch(fetchBrandProducts());
          store.dispatch(fetchClassificationProducts());
        },
        builder: (context, viewModel) {
          return Column(
            children: [
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  BaseNavigate(
                    context,
                    DynamicallyCheckBox(
                      values: viewModel?.itemGroupItems,
                      // title: Text(""),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  BaseNavigate(
                    context,
                    DynamicallyCheckBox(
                      values: viewModel?.itemModelItems,
                      // title: Text(""),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  BaseNavigate(
                    context,
                    DynamicallyCheckBox(
                      values: viewModel?.itemBrandItems,
                      // title: Text(""),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  BaseNavigate(
                    context,
                    DynamicallyCheckBox(
                      values: viewModel?.classificationItems,
                      // title: Text(""),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  BaseNavigate(
                    context,
                    DynamicallyCheckBox(
                      values: viewModel?.brandItems,
                      // title: Text(""),
                    ),
                  );
                },
              )
            ],
          );
        });
  }
}

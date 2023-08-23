import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/src/redux/actions/sales_invoice/sales_invoice_action.dart';
import 'package:redstars/src/redux/actions/sign_in/login_action.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/login/login_viewmodel.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_detail_listing.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_listing.dart';

import '../../../../utility.dart';
import '../../../redux/viewmodels/login/login_viewmodel.dart';
import '_partials/login.dart';

class SplashPage extends StatelessWidget
    with BaseViewMixin<AppState, LoginViewModel> {
  const SplashPage({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  final bool isColdStart;

  @override
  void init(Store store, BuildContext context)async {
    final String SharedCompanyString = await BasePrefs.getString('CompanyList');
    store.dispatch(CheckTokenAction(
        hasTokenCallback: (model) {
          if(SharedCompanyString.isNotEmpty){
            store.dispatch(getClientInfo());
            store.dispatch(fetchLiveClientList());
            store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
            store.dispatch(ChangeScreenStateAction(ScreenState.Company));
            store.dispatch(signInUser(model));
          }
//      store.dispatch(signInUser(model));
    }, noTokenCallback: () {
      store.dispatch(getClientInfo());
      store.dispatch(fetchLiveClientList());
      store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
      store.dispatch(ChangeScreenStateAction(ScreenState.SINGIN));
      if (store?.state?.salesInvoiceState?.cartItems == null) {
        store.dispatch(
            removeListItemFromCart(store.state.salesInvoiceState.cartItems));
      }
      store.dispatch(fetchActionTypes());
    }));
  }

  @override
  LoginViewModel converter(Store store) {
    return LoginViewModel.fromStore(store);
  }

  @override
  Widget childBuilder(BuildContext context, LoginViewModel viewModel) {
    return Stack(fit: StackFit.expand, children: [
      viewModel.type ==ScreenState.Branch?
      SavedCompanyDetailListPage(viewmodel:viewModel):
        (
            viewModel.type ==ScreenState.WELCOME ?
        _SplashScreen() : Login(viewModel: viewModel)
        )
    ]);
  }

  @override
  Widget showLoading({String loadingMessage, TextStyle style}) {
//    return _SplashScreen();
    return null;
  }

  @override
  BaseAppBar appBarBuilder(String title, BuildContext context) => null;
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Stack(fit: StackFit.expand, children: <Widget>[
      Center(child: Image(image: AppImages.logo, width: 148.0)),
      Positioned.fill(
          top: null,
          bottom: 32.0,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(padding: const EdgeInsets.all(8.0)),
            Text(BaseStrings.instance.appName,
                style: theme.display2Semi
                    .copyWith(color: colors.white.withOpacity(.6)),
                textAlign: TextAlign.center),
            Text(Settings.getVersion(),
                style: theme.small
                    .copyWith(color: colors.white.withOpacity(.4), height: 1.5),
                textAlign: TextAlign.center)
          ])),
      Positioned.fill(
          top: null, bottom: 124.0, child: const BaseLoadingSpinner(size: 45))
    ]);
  }
}

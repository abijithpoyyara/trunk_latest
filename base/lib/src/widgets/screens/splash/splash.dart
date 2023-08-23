import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import '_partials/login.dart';

class SplashPage extends StatelessWidget
    with BaseViewMixin<BaseAppState, BaseLoginViewModel> {
  const SplashPage({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  final bool isColdStart;

  @override
  void init(Store store, BuildContext context) {
    store.dispatch(CheckTokenAction(hasTokenCallback: (model) {
      store.dispatch(model);
    }, noTokenCallback: () {
      store.dispatch(getClientInfo());
      store.dispatch(ChangeScreenStateAction(ScreenState.SINGIN));
    }));
  }

  @override
  BaseLoginViewModel converter(Store store) {
    return BaseLoginViewModel.fromStore(store);
  }

  @override
  Widget childBuilder(BuildContext context, BaseLoginViewModel viewModel) {
    return viewModel.type == ScreenState.WELCOME
        ? _SplashScreen()
        : Login(viewModel: viewModel);
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Stack(fit: StackFit.expand, children: <Widget>[
//      Center(child:  Image(image: BaseImages.logo, width: 148.0)),
      Positioned.fill(
          top: null,
          bottom: 32.0,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(padding: const EdgeInsets.all(8.0)),
            Text(BaseStrings.instance.appName,
                style: theme.display2Semi
                    .copyWith(color: colors.kTextBaseColor.withOpacity(.6)),
                textAlign: TextAlign.center),
            Text(Settings.getVersion(),
                style: theme.small.copyWith(
                    color: colors.kTextBaseColor.withOpacity(.4), height: 1.5),
                textAlign: TextAlign.center)
          ])),
      Positioned.fill(
          top: null,
          bottom: 124.0,
          child: BaseLoadingSpinner(color: themeData.primaryColor, size: 45))
    ]);
  }
}

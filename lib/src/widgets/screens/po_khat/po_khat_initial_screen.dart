import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:redstars/src/redux/actions/po_khat/po_khat_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/po_khat/po_khat_viewmodel.dart';
import 'package:redstars/src/widgets/screens/po_khat/po_khat_list.dart';

class POKhatInitialScreen extends StatefulWidget {
  const POKhatInitialScreen({
    Key key,
  }) : super(key: key);

  @override
  _POKhatInitialScreenState createState() => _POKhatInitialScreenState();
}

class _POKhatInitialScreenState extends State<POKhatInitialScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PokhatViewModel>(
        isShowErrorSnackBar: false,
        converter: (store) => PokhatViewModel.fromStore(store),
        init: (store, context) {
          store.dispatch(fetchKhatPoLocation());
          store.dispatch(fetchPoKhatSuppliers());
          store.dispatch(fetchPokhatInitialConfigAction());
        },
        onDispose: (store) => store.dispatch(PokhatClearAction()),
        builder: (context, viewModel) {
          return KhatListScreen(
            pokhatViewModel: viewModel,
          );
        });
  }
}

class StockEmptyResultView extends StatelessWidget {
  const StockEmptyResultView({
    Key key,
    this.message = "No results",
    this.icon = Icons.equalizer,
    this.onRefresh,
  }) : super(key: key);

  final String message;
  final IconData icon;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    final ThemeData themeData = ThemeProvider.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //  SizedBox(height: height*.25,),
            Expanded(
              child: Icon(
                icon,
                color: BaseColors.of(context).accentColor,
                size: height * 1 / 18,
              ),
            ),
            //  const SizedBox(height: 8.0),
            Expanded(
                child: Text(
              message,
              style: theme.body2MediumHint.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            )),

            //  SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themeData.primaryColorDark,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh")),
          ]),
    );
  }
}

import 'package:base/resources.dart';
import 'package:base/src/redux/models/loading_status.dart';
import 'package:base/src/redux/viewmodels/base_viewmodel.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BaseView<BaseAppState, U extends BaseViewModel> extends StatefulWidget {
  final PreferredSizeWidget appBar;

//  final PreferredSizeWidget Function(U) appBarBuilder;
  final Function(U, BuildContext) onDidChange;
  final Widget floatingActionButton;
  final U Function(Store) converter;
  final Widget Function(BuildContext, U) builder;
  final void Function(Store<BaseAppState> store, BuildContext context) init;
  final void Function(Store store) onDispose;

  final void Function(U) onInitialBuild;
  final bool isShowErrorSnackBar;

  const BaseView(
      {Key key,
      this.appBar,
      this.onDidChange,
      this.floatingActionButton,
      @required this.converter,
      @required this.builder,
      this.init,
      this.onInitialBuild,
      this.onDispose,
      this.isShowErrorSnackBar = true})
      : super(key: key);

  @override
  _BaseViewState<BaseAppState, U> createState() =>
      _BaseViewState<BaseAppState, U>();
}

class _BaseViewState<BaseAppState, U extends BaseViewModel>
    extends State<BaseView<BaseAppState, U>> {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return willPop(context);
        },
        child: BaseStatusBar(
            child: Scaffold(
//                resizeToAvoidBottomPadding: true,
                resizeToAvoidBottomInset: true,
                floatingActionButton: widget.floatingActionButton,
                appBar: widget.appBar,
                body: Builder(
                    builder: (BuildContext context) =>
                        StoreConnector<BaseAppState, U>(
                            onInit: (store) {
                              if (widget.init != null)
                                widget.init(store, context);
                            },
                            onDidChange: (U viewModel) {
                              switch (viewModel.loadingStatus) {
                                case LoadingStatus.error:
                                  if (widget.isShowErrorSnackBar)
                                    BaseSnackBar.of(context)
                                        .show(viewModel.loadingError ?? "");
                                  break;
                                case LoadingStatus.success:
                                  break;
                                case LoadingStatus.loading:
                                  break;
                              }
                              if (widget.onDidChange != null)
                                widget.onDidChange(viewModel, context);
                            },
                            onInitialBuild: widget.onInitialBuild,
                            converter: (store) => widget.converter(store),
                            builder: (context, viewModel) {
                              if (viewModel.loadingStatus ==
                                      LoadingStatus.loading &&
                                  showLoading() != null)
                                return showLoading(
                                    loadingMessage:
                                        viewModel?.loadingMessage ?? "",
                                    style: BaseTheme.of(context)
                                        .subhead1
                                        .copyWith(color: Colors.white));
                              return widget.builder(context, viewModel);
                            },
                            onDispose: widget.onDispose)))));
//    );
  }

  Future<bool> willPop(BuildContext context) {
    return Future.value(true);
  }

  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(loadingMessage ?? "", style: style)
        ]));
  }
}

class BaseStore<BaseAppState, U extends BaseViewModel> extends StatelessWidget {
  final Function(U, BuildContext) onDidChange;
  final U Function(Store) converter;
  final Widget Function(BuildContext, U) builder;
  final void Function(Store<BaseAppState> store, BuildContext context) init;
  final void Function(Store store) onDispose;
  final Widget Function(BuildContext context, String loadingError) onError;

  const BaseStore(
      {Key key,
      this.onDidChange,
      @required this.converter,
      @required this.builder,
      this.init,
      this.onDispose,
      this.onError})
      : super(key: key);

  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) => StoreConnector<BaseAppState, U>(
            onInit: (store) {
              if (init != null) init(store, context);
            },
            onDidChange: (U viewModel) {
              switch (viewModel.loadingStatus) {
                case LoadingStatus.error:
                  if (context is ScaffoldState)
                    BaseSnackBar.of(context).show(viewModel.loadingError ?? "");
                  break;

                case LoadingStatus.success:
                  break;
                case LoadingStatus.loading:
                  break;
              }
              if (onDidChange != null) onDidChange(viewModel, context);
            },
            converter: (store) => converter(store),
            builder: (context, viewModel) {
              if (viewModel.loadingStatus == LoadingStatus.loading &&
                  showLoading(style: TextStyle(color: Colors.white)) != null)
                return showLoading(
                    loadingMessage: viewModel?.loadingMessage ?? "",
                    style: BaseTheme.of(context).subhead1);
              else if (viewModel.loadingStatus ==
                  LoadingStatus.error) if (onError != null)
                return onError(context, viewModel.loadingError);
              else
                ErrorResultView(message: viewModel.loadingError);

              return builder(context, viewModel);
            },
            onDispose: onDispose));
  }

  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Center(
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(loadingMessage ?? "", style: style)
        ])));
  }
}

mixin BaseViewMixin<BaseAppState, U extends BaseViewModel> on StatelessWidget {
  Widget build(BuildContext context) {
    return BaseStatusBar(
        child: Scaffold(
            // resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            floatingActionButton: buildFloatingActionButton(),
            appBar: appBarBuilder(
              "",
              context,
            ),
            body: Builder(
                builder: (BuildContext context) =>
                    StoreConnector<BaseAppState, U>(
                        onInit: (store) => init(store, context),
                        onDidChange: (U viewModel) {
                          switch (viewModel.loadingStatus) {
                            case LoadingStatus.error:
                              BaseSnackBar.of(context)
                                  .show(viewModel.loadingError ?? "");
                              break;
                            case LoadingStatus.success:
                              break;
                            case LoadingStatus.loading:
                              break;
                          }
                          onDidChange(viewModel, context);
                        },
                        converter: (store) => converter(store),
                        builder: (context, viewModel) {
                          if (viewModel.loadingStatus ==
                                  LoadingStatus.loading &&
                              showLoading() != null)
                            return showLoading(
                                loadingMessage: viewModel?.loadingMessage ?? "",
                                style: BaseTheme.of(context).subhead1);
                          return childBuilder(context, viewModel);
                        },
                        onDispose: onDispose))));
  }

  BaseAppBar appBarBuilder(
    String title,
    BuildContext context,
  ) {
    return BaseAppBar(
      title: Text("${title ?? ""}"),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return null;
  }

  void init(Store<BaseAppState> store, BuildContext context) {}

  void onDidChange(U viewModel, BuildContext context) {}

  U converter(Store store);

  Widget childBuilder(BuildContext context, U viewModel);

  void onDispose(Store store) {
//    store.dispatch(OnClearAction());
  }

  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(loadingMessage ?? "", style: style)
        ]));
  }
}
mixin BaseStoreMixin<T, U extends BaseViewModel> on StatelessWidget {
  Widget build(BuildContext context) {
    return StoreConnector<T, U>(
        onInit: (store) => init(store, context),
        onDidChange: (U viewModel) {
          switch (viewModel.loadingStatus) {
            case LoadingStatus.error:
              BaseSnackBar.of(context).show(viewModel.loadingError ?? "");
              break;
            case LoadingStatus.success:
              break;
            case LoadingStatus.loading:
              break;
          }
          onDidChange(viewModel, context);
        },
        converter: (store) => converter(store),
        builder: (_con, viewModel) {
          // if (viewModel.loadingStatus == LoadingStatus.loading &&
          //     showLoading() != null)
          //   return showLoading(
          //       loadingMessage: viewModel.loadingMessage,
          //       style: BaseTheme.of(_con).subhead1);
          // else
          return childBuilder(_con, viewModel);
        },
        onDispose: onDispose);
  }

  void init(Store store, BuildContext context) {}

  void onDidChange(U viewModel, BuildContext context) {}

  U converter(Store store);

  Widget childBuilder(BuildContext context, U viewModel);

  void onDispose(Store store) {
//    store.dispatch(OnClearAction());
  }

  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(loadingMessage ?? "", style: style)
        ]));
  }
}

mixin BaseStoreInitialMixin<T, U extends BaseViewModel> on StatelessWidget {
  Widget build(BuildContext context) {
    return StoreConnector<T, U>(
        onInit: (store) => init(store, context),
        onDidChange: (U viewModel) {
          onDidChange(viewModel, context);
        },
        converter: (store) => converter(store),
        builder: (_con, viewModel) =>
            viewModel.loadingStatus == LoadingStatus.loading
                ? showLoading(
                    loadingMessage: viewModel.loadingMessage,
                    style: BaseTheme.of(_con).subhead1)
                : viewModel.loadingStatus == LoadingStatus.error
                    ? buildErrorView(_con, viewModel.loadingError)
                    : buildChild(_con, viewModel),
        onDispose: onDispose);
  }

  void init(Store store, BuildContext context) {}

  void onDidChange(U viewModel, BuildContext context) {}

  U converter(Store store);

  Widget buildChild(BuildContext context, U viewModel);

  Widget buildErrorView(BuildContext context, String message);

  void onDispose(Store store) {
//    store.dispatch(OnClearAction());
  }

  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(loadingMessage, style: style)
        ]));
  }
}

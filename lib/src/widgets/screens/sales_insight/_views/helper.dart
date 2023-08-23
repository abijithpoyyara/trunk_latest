import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/mis_helper.dart';

class GraphDataView<T> extends StatelessWidget {
  final List<T> data;
  final Widget headerChild;
  final Widget totalCard;
  final double minHeaderHeight;
  final double maxHeaderHeight;
  final Function(T data) builder;

  final ScrollController scrollController;

  const GraphDataView({
    Key key,
    @required this.data,
    @required this.builder,
    this.scrollController,
    this.headerChild,
    this.totalCard,
    this.maxHeaderHeight = 280.0,
    this.minHeaderHeight = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          if (totalCard != null)
            SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: totalCard,
                )),
          if (headerChild != null)
            SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: SliverAppBarDelegate(
                    minHeight: minHeaderHeight,
                    maxHeight: maxHeaderHeight,
                    child: headerChild)),
          SliverList(
              delegate: SliverChildListDelegate(data != null && data.isNotEmpty
                  ? data.map<Widget>((item) => builder(item)).toList()
                  : [EmptyResultView()] ?? [EmptyResultView()])),
        ]);
  }
}

class EmptyResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors _colors = BaseColors.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.filter_vintage,
            color: _colors.hintColor.withOpacity(.4), size: 45),
        SizedBox(height: 10),
        Text("No Records Found, Try changing filter",
            textAlign: TextAlign.center,
            style: textTheme.body2.copyWith(color: _colors.hintColor))
      ],
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: const BaseLoadingSpinner(size: 65));
  }
}

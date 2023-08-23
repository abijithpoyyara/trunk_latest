import 'dart:ui';

import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import '../../../resources.dart';

typedef DialogListBuilder<T> = Widget Function(T, int);

Future<T> showListDialog<T>(BuildContext context,
    List<T> list, {
      @required DialogListBuilder<T> builder,
      @required String title,
      bool isChangeHeight = false,
      double height
    }) async {
  return baseShowChildDialog<T>(
    context: context,
    child: BaseListDialog<T>(list: list,
      builder: builder,
      title: title,
      isChangeHeight: isChangeHeight ?? false,
      itemHeight
      :height,),
    barrierDismissible: true,
  );
}


Future<T> showCenterDialog<T>(BuildContext context,
    List<T> list, {
      @required DialogListBuilder<T> builder,
      @required String title,
      bool isDismissible = true,
      double height,
    }) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (_context) =>
          BaseListCenterDialog<T>(
              list: list, builder: builder, title: title, height: height),
      isDismissible: isDismissible);
}

Future<T> showBottomListSheet<T>(BuildContext context,
    List<T> list, {
      @required DialogListBuilder<T> builder,
      @required String title,
      bool isDismissible = true,
      double height,
      bool isChangeHeight = false


    }) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (_context) =>
          BaseListDialog<T>(list: list,
            builder: builder,
            title: title,
            itemHeight: height,
            isChangeHeight: isChangeHeight,),
      isDismissible: isDismissible);
}

class BaseListCenterDialog<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final DialogListBuilder<T> builder;
  final double height;

  BaseListCenterDialog(
      {Key key, this.title, this.builder, this.list, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = BaseTheme
        .of(context)
        .title;
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

//    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: Container(
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          //   color: colors.primaryColor,
//        height: height / 2,
          child: Card(
              color: themeData.primaryColor,

              child: Column(children: [
                Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: themeData.primaryColor,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              flex: 7,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text('$title',
                                      style: textTheme.copyWith(color: colors
                                          .white),
                                      textAlign: TextAlign.start))),
                          Flexible(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.close, color: colors.white,),
                                  iconSize: 22,
                                  onPressed: () => Navigator.pop(context)))
                        ])),
                Expanded(
                    child: _List<T>(
                      list: list,
                      builder: builder,
                    ))
              ]))),
    );
  }
}

class BaseListDialog<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final DialogListBuilder<T> builder;
  final double itemHeight;
  final bool isChangeHeight;

  BaseListDialog(
      {Key key, this.title, this.builder, this.list, this.itemHeight, this.isChangeHeight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = BaseTheme
        .of(context)
        .title;
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(

      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),),
      child: BackdropFilter(

      filter: ImageFilter.blur(sigmaX: 3.6, sigmaY:3.6),
      child: Padding(
        padding:EdgeInsets.only(top:isChangeHeight==false? 0:height*.18),
        child: Align(
         alignment: Alignment.topCenter,

          child: Container(
              height: isChangeHeight == false ? height : itemHeight,
                decoration: BoxDecoration( borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),),
              //   color: colors.primaryColor,
//        height: height / 2,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    color: themeData.primaryColor,

                  child: Column(children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              ),
                          color: themeData.primaryColor,
                        ),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.keyboard_arrow_down_outlined, color: Theme.of(context).primaryColorDark,),
                                      iconSize: 22,
                                        onPressed: () => Navigator.pop(context)),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text('$title',)),
                                  ],
                                ),
                                // Flexible(
                                //     flex: 1,
                                //     child: IconButton(
                                //         icon: Icon(Icons.close, color: colors.white,),
                                //         iconSize: 22,
                                //         onPressed: () => Navigator.pop(context)))
                            ])),
                    Expanded(
                        child: _List<T>(
                          list: list,
                          builder: builder,
                        ))
                  ]))),
          ),
        ),
      ),
    );
  }
}

class _List<T> extends StatelessWidget {
  final List<T> list;
  final DialogListBuilder<T> builder;

  const _List({Key key, this.builder, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        shrinkWrap: true,
        itemCount: list?.length ?? 0,
        itemBuilder: (con, pos) {
          return builder(list[pos], pos);
        });
  }
}

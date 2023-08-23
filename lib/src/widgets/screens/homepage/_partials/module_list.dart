import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/home/home_viewmodel.dart';

class ModuleListWidget extends StatefulWidget {
  const ModuleListWidget({
    Key key,
    this.docAppCount,
    this.transUnblockCount,
    this.unconfirmedTransCount,
    this.counter,
    this.counter2,
    @required this.height,
    @required this.viewModel,
  }) : super(key: key);

  final int docAppCount;
  final int transUnblockCount;
  final int unconfirmedTransCount;
  final HomeViewModel viewModel;
  final ValueNotifier<int> counter;
  final int counter2;
  final double height;
  final int _crossAxisCount = 3;

  @override
  _ModuleListWidgetState createState() => _ModuleListWidgetState();
}

class _ModuleListWidgetState extends State<ModuleListWidget>
// with ChangeNotifier
{
  // @override
  // void initState() {
  //   super.initState();
  //   print("initState() called");
  // }
  // @override
  // void dispose() {
  //   if(mounted)
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (widget.height + size.width / widget.height);
    final double itemWidth = size.width / 9;
    final double mediaQueryHeight = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return new Expanded(
        child: GridView.count(
      physics: BouncingScrollPhysics(),
      crossAxisCount: widget._crossAxisCount,
      childAspectRatio: itemWidth / itemHeight,
      padding: EdgeInsets.all(0),
      children: List.generate(widget.viewModel.menuItems.length, (index) {
        return buildListItem(
          widget.viewModel.menuItems[index],
          context,
          widget.viewModel,
          widget.docAppCount,
          widget.transUnblockCount,
          widget.unconfirmedTransCount,
        );
      }),
      //itemWidth / itemHeight,
    ));
  }

  Widget buildListItem(
    MenuModel module,
    BuildContext context,
    HomeViewModel viewModel,
    int docAppCount,
    int transUnblockCount,
    int unconfirmedTransCount,
  ) {
    int count;
    if (viewModel.notificationCountDtls != null) {
      viewModel.notificationCountDtls.forEach((element) {
        if (element.notificationoptionid == module.module.id) {
          count = element.notificationcount;
        }
        return count;
      });
    }

    ValueNotifier<int> _counterDoc = ValueNotifier<int>(count);
    ValueNotifier<int> _counterTransUnblk = ValueNotifier<int>(count);
    ValueNotifier<int> _counterUnconfirmedTrans = ValueNotifier<int>(count);
    ValueNotifier<int> _counterUnconfirmed =
        ValueNotifier<int>(unconfirmedTransCount);
    final double mediaQueryHeight = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    BaseTheme theme = BaseTheme.of(context);
    return GestureDetector(
      onTap: () async {
        if (module.hasBadge == true && module.rightFlag == "MOBILE_DOC_APRVL") {
          _counterDoc = ValueNotifier<int>(count);
          print("hi");
        }
        module.onPressed();
        widget.viewModel.onOptionSelected(module.module);
      },
      child: Container(
        height: widget.height * 0.06,
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color(0x07000000),
          //     blurRadius: 15,
          //     offset: Offset(0, 10),
          //   ),
          // ],
          color: BaseColors.of(context).white,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: width,
                  height: mediaQueryHeight * .13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ThemeProvider.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: module.hasBadge == true &&
                  module.rightFlag == "MOBILE_DOC_APRVL" &&
                  count != null,
              child: Positioned(
                  left: 0.0001,
                  top: -8,
                  child: Visibility(
                    visible: count != null,
                    child: Container(
                      width: 20,
                        height: 20,
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                      child: StatefulBuilder(
                        builder: (context, StateSetter setterState) {
                          return ValueListenableBuilder(
                              valueListenable: _counterDoc,
                              builder: (context, int value, child) {
                                print("whatt $value");
                                return Text(
                                  "$value",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                );
                              });
                        },
                      ),
                    )),
                  )),
            ),
            Visibility(
              // visible: true,
              // visible: module.hasBadge == true && (docAppCount != 0 || transUnblockCount != 0),
              visible: module.hasBadge == true &&
                  module.rightFlag == "MOB_TRAN_UNBLK_REQ_APRVL" &&
                  count != null,
              child: Positioned(
                  left: 0.0001,
                  top: -8,
                  child: Visibility(
                    visible: count != null,
                    child: Container(
                        width: 20,
                        height: 20,
                      margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                      child: StatefulBuilder(
                        builder: (context, StateSetter setterState) {
                          return ValueListenableBuilder(
                              valueListenable: _counterTransUnblk,
                              builder: (context, int value, child) => Text(
                                    "$value",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ));
                        },
                      ),
                    )),
                  )),
            ),
            Visibility(
              // visible: true,
              // visible: module.hasBadge == true && (docAppCount != 0 || transUnblockCount != 0),
              visible: module.hasBadge == true &&
                  module.rightFlag == "UNCONFIRMED_TRANSACTION" &&
                  count != null,
              child: Positioned(
                  left: 0.0001,
                  top: -8,
                  child: Visibility(
                    visible: count != null,
                    child: Container(
                        width: 20,
                        height: 20,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),

                        child: Center(
                      child: StatefulBuilder(
                        builder: (context, StateSetter setterState) {
                          return ValueListenableBuilder(
                              valueListenable: _counterUnconfirmedTrans,
                              builder: (context, int value, child) => Text(
                                    "$value",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ));
                        },
                      ),
                    )),
                  )),
            ),
            Positioned(
              left: width * .10,
              top: mediaQueryHeight * .03,
              child: Container(
                width: width * .4,
                height: mediaQueryHeight * .06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: module.vector != null
                    ? SvgPicture.asset(
                        module?.vector ?? AppVectors.documentApproval_icon,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        semanticsLabel: module?.title ?? "",
                        height: 28,
                        width: 28)
                    : Container(
                        alignment: Alignment.centerLeft,
                        //height: 28,
                        width: width,
                        child: Icon(
                          module.icon,
                          size: 32,
                          color: ThemeProvider.of(context).accentColor,
                        )),
              ),
            ),
            Positioned(
              top: mediaQueryHeight * .12,
              child: Opacity(
                opacity: 0.80,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * .28,
                    height: mediaQueryHeight * .09,
                    margin: EdgeInsets.only(left: 8, right: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(module.count.toString(),
                        //   style: TextStyle(color: Colors.black),),
                        Expanded(
                          child: Text(
                            module.title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            maxLines: 5,
                            style: theme.body2Light.copyWith(
                                color: Colors.black,
                                fontSize: 13.2,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //   Container(
    //   height: 28,
    //   width: 100,
    //   margin: EdgeInsets.all(8),
    //   decoration:  BoxDecoration(
    //     color: Color(0xFFFA8F4B),
    //     borderRadius: BorderRadius.circular(15)
    //     // border: const Border(
    //     //     bottom: const BaseBorderSide(), right: const BaseBorderSide()),
    //   ),
    //   child: TMGridTile(
    //       icon: module.icon,
    //       color: module.color,
    //       title: module.title,
    //       onPressed: () =>
    //       {module.onPressed(), viewModel.onOptionSelected(module.module)}),
    // );
  }
}

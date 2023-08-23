import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/model/branch_model.dart';

class BranchListView extends StatelessWidget {
  final Function(SEMISBranchModel) onTap;

  const BranchListView({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStore<AppState, SalesEnquiryMisViewModel>(
      converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
      builder: (context, viewModel) {
        return CupertinoScrollbar(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: viewModel.selectedBranchWiseGroup.length,
            // physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (cont, pos) {
              var particularBranch = viewModel.selectedBranchWiseGroup[pos];
              return MISGridTile(
                position: pos,
                primaryColor: ThemeProvider.of(context).primaryColor,
                secondaryColor: ThemeProvider.of(context).primaryColor,
                primaryTitle: "${particularBranch.branchName} ",
                count: particularBranch.enquiryDetails?.length ?? 0,
                primaryIcon: Icons.location_on_outlined,
                onClick: () => onTap(particularBranch),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 4.0,
              crossAxisCount: 3,
            ),
          ),
        );
      },
    );
  }
}

class MISGridTile extends StatelessWidget {
  final Color primaryColor;
  final IconData primaryIcon;
  final String primaryTitle;
  final Color secondaryColor;
  final int count;
  final VoidCallback onClick;

  final int position;

  MISGridTile(
      {this.primaryColor,
      this.primaryIcon,
      this.primaryTitle,
      this.secondaryColor,
      this.count,
      this.onClick,
      this.position});

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        margin: EdgeInsets.only(
            // top: position.isOdd ? 15 : 0,
            // bottom: position.isEven ? 35 : 0,
            ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: themeData.primaryColorDark.withOpacity(.70),
                  offset: Offset(-2, -2),
                  blurRadius: 2),
              BoxShadow(
                  color: themeData.primaryColorDark.withOpacity(0.70),
                  offset: Offset(0, 2),
                  blurRadius: 2)
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
            ),
            // borderRadius: BorderRadius.circular(10),
            // border: Border.fromBorderSide(BaseBorderSide()),
            // color: Colors.white,
            gradient: RadialGradient(
              colors: [
                (primaryColor ?? ThemeProvider.of(context).primaryColor)
                    .withOpacity(.6),
                (secondaryColor ?? themeData.scaffoldBackgroundColor)
                    .withOpacity(.06),
              ],
              tileMode: TileMode.repeated,
            )),
        child: InkWell(
            onTap: onClick,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          child: Text(primaryTitle,
                              textAlign: TextAlign.center,
                              style: style.bodyBold
                                  .copyWith(color: Colors.white)))),
                  Flexible(
                      flex: 1,
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 2),
                        alignment: Alignment.center,
                        child: _CountItem(count: count),
                        decoration: BoxDecoration(
                            color:
                                secondaryColor ??themeData.scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  offset: Offset(-2, -2),
                                  blurRadius: 6)
                            ],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(22),
                            )),
                      ))
                ]))));
  }
}

class _CountItem extends StatefulWidget {
  final int count;

  _CountItem({@required this.count});

  @override
  _CountItemState createState() => _CountItemState();
}

class _CountItemState extends State<_CountItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animationCount;
  Animation<double> animationHour;

  int count;

  @override
  void initState() {
    super.initState();
    count = widget.count;
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        // setState(() {});
      });

    animationCount = IntTween(begin: 0, end: count ?? 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    animationHour = _controller.drive(Tween<double>(begin: 0.6, end: 1));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);

    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) => Text(
            animationCount.value.toString(),
            style: style.display1Semi
                .copyWith(color: Theme.of(context).cardColor)));
  }

  @override
  void didUpdateWidget(_CountItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.forward(from: 0);
  }
}

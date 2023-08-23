import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';

class ProgressFlowTile extends StatelessWidget {
  final Color primaryColor;
  final IconData primaryIcon;
  final String primaryTitle;
  final Color secondaryColor;
  final int count;
  final VoidCallback onClick;

  final int position;

  ProgressFlowTile(
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
    return Container(
        margin: EdgeInsets.only(),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.5),
                  offset: Offset(-2, -2),
                  blurRadius: 2),
              BoxShadow(
                  color: Colors.black.withOpacity(.5),
                  offset: Offset(0, 2),
                  blurRadius: 2)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), bottomRight: Radius.circular(33)),
            border: Border.fromBorderSide(BaseBorderSide(color: Colors.white)),
            gradient: LinearGradient(
              colors: [
                (primaryColor ?? Theme.of(context).primaryColor)
                    .withOpacity(.6),
                (secondaryColor ??style.colors.secondaryColor)
                    .withOpacity(.6),
              ],
              tileMode: TileMode.repeated,
            )),
        child: InkWell(
            onTap: onClick,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(primaryTitle,
                    textAlign: TextAlign.center,
                    style: style.bodyBold.copyWith(color: Colors.white)))));
  }
}

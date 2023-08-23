import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:redstars/resources.dart';

class SummaryGridTile extends StatelessWidget {
  final Color primaryColor;
  final IconData primaryIcon;
  final String primaryTitle;
  final Color secondaryColor;
  final dynamic count;
  final VoidCallback onClick;
  final bool isSelected;
  final bool isPercentage;
  final int position;

  SummaryGridTile({
    this.primaryColor,
    this.primaryIcon,
    this.primaryTitle,
    this.secondaryColor,
    this.count,
    this.onClick,
    this.position,
    this.isSelected = false,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: isSelected ? null : Colors.white,
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      (primaryColor ?? style.colors.secondaryColor)
                        ,
                      (secondaryColor ?? style.colors.selectedColor)

                    ],
                    tileMode: TileMode.repeated,
                  )
                : LinearGradient(colors: [
            (primaryColor ?? style.colors.secondaryColor),

        (secondaryColor ?? style.colors.secondaryColor)

        ], )),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPercentage)
              Expanded(
                child: CustomPaint(
                  foregroundPainter: CircularPainter(
                    width: 2.5,
                    completeColor:
                        (primaryColor ?? style.colors.selectedColor),
                    completePercent: double.tryParse(count ?? 0),
                    lineColor: themeData.primaryColor,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    margin: const EdgeInsets.all(14.0),
                    alignment: Alignment.center,
                    child: Text('$count %',
                        textAlign: TextAlign.center,
                        style: style.bodyBold
                            .copyWith(color: isSelected ? Colors.white : null)),
                  ),
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(24),
                    border: Border.fromBorderSide(
                        BaseBorderSide(color: Colors.white)),
                    color: !isSelected ? null : Colors.grey.withOpacity(.35),
                    gradient: !isSelected
                        ? LinearGradient(
                            colors: [
                              (primaryColor ?? ThemeProvider.of(context).primaryColor)
                                  .withOpacity(.6),
                              (secondaryColor ?? ThemeProvider.of(context).primaryColor)
                                  .withOpacity(.6),
                            ],
                            tileMode: TileMode.repeated,
                          )
                        : null),
                child: Text('$count',
                    textAlign: TextAlign.center,
                    style: style.bodyBold.copyWith(color: Colors.white)),
              ),
            SizedBox(height: 4),
            Text(primaryTitle,
                textAlign: TextAlign.center,
                style: style.bodyBold
                    .copyWith(color: isSelected ? Colors.white : null)),
          ],
        ),
      ),
    );
  }
}

class CircularPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  CircularPainter({
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

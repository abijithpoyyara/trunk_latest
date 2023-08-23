import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/utility.dart';

class TotalTile extends StatelessWidget {
  final Widget title;
  final IconData icon;
  final double value;

  TotalTile({
    @required this.title,
    @required this.icon,
    double value,
  }) : this.value = value ?? 0;

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    List<Color> _colors = [BaseColors.of(context).white,ThemeProvider.of(context).scaffoldBackgroundColor];
    List<double> _stops = [0.0, 0.9,];
    return Material(
        color: themeData.scaffoldBackgroundColor,
       elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color:themeData.primaryColorDark)),
        child:
    Container(
    decoration: BoxDecoration(
    borderRadius:BorderRadius.circular(18) ,
    gradient: LinearGradient(colors: _colors, stops: _stops)),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color:themeData.primaryColorDark,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18)),
                  ),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 24),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      title,
                      SizedBox(height: 2),
                      Text('${BaseNumberFormat(number: value).formatCurrency()}',
                          style: style.subhead1Bold.copyWith(
                              color: value > 0 ? Colors.green : Colors.red))
                    ]))
              ]),
        ));
  }
}

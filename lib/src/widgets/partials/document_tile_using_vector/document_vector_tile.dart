import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';


class VectorDocumentTypeTile extends StatelessWidget {
  const VectorDocumentTypeTile(
      {this.vector,
        this.leading,
        this.color,
        this.title,
        this.subTitle,
        this.onPressed,
        this.selected = false,
        this.trailing});

  final bool selected;
  final String vector;
  final Widget leading;
  final Color color;
  final String title;
  final String trailing;
  final String subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color tempColor = color ?? ThemeProvider.of(context).primaryColorDark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeProvider.of(context).scaffoldBackgroundColor,
      ),
      child: MaterialButton(
        // padding: const EdgeInsets.only(left: 20.0),
          splashColor: tempColor.withOpacity(.25),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(8),
            // margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: ThemeProvider.of(context).primaryColor))),
            child: Row(children: <Widget>[
              _CircleIcon(
               vector: vector,
                  color: tempColor,
                  small: !selected,
                  leading: leading),
              Expanded(
                  child: _TextTile(
                      title: title, subTitle: subTitle, small: !selected)),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _TextTile(title: trailing, small: true),
                )
            ]),
          ),
          onPressed: onPressed),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final Widget leading;
  final String vector;
  final Color color;
  final bool small;

  const _CircleIcon({
    this.vector,
    this.color,
    this.small: false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            child: CircleAvatar(
                backgroundColor: color ?? ThemeProvider.of(context).primaryColorDark,
                radius: small == true ? 14.0 : 20.0,
                child:vector!=null? SvgPicture.asset(vector)

              /*  icon != null
                    ? Icon(icon,
                    size: small == true ? 14.0 : 20.0, color: Colors.white)*/
                    : DefaultTextStyle(
                  child: leading,
                  style: BaseTheme.of(context).subhead1Bold.copyWith(
                      fontSize: small == true ? 14.0 : 20.0,
                      color: Colors.white),
                )),
            padding: EdgeInsets.only(right: small == true ? 8.0 : 10.0)));
  }
}

class _TextTile extends StatelessWidget {
  const _TextTile({
    this.title,
    this.subTitle,
    this.small: false,
  });

  final String title;
  final String subTitle;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$title",
          style: TextStyle(
            color: BaseColors.of(context).white,
            fontSize: small == true ? 15.0 : 16.0,
          ),
        ),
        subTitle != null
            ? Text(
          subTitle,
          style: BaseTheme.of(context).small,
        )
            : const SizedBox(),
      ],
    );
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentTypeTile extends StatelessWidget {
  const DocumentTypeTile(
      {this.icon,
      this.leading,
      this.color,
      this.title,
      this.subTitle,
      this.onPressed,
      this.selected = false,
      this.vector,
      this.isVector = false,
      this.trailing});

  final bool selected;
  final IconData icon;
  final Widget leading;
  final Color color;
  final String title;
  final String trailing;
  final String subTitle;
  final VoidCallback onPressed;
  final String vector;
  final bool isVector;

  @override
  Widget build(BuildContext context) {
    Color tempColor =
        color ?? ThemeProvider.of(context).primaryColorDark.withOpacity(.6);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeProvider.of(context).scaffoldBackgroundColor,
      ),
      child: MaterialButton(
          splashColor: tempColor.withOpacity(.25),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: ThemeProvider.of(context).primaryColor))),
            child: Row(children: <Widget>[
              _CircleIcon(
                  isVector: !isVector,
                  vector: vector ?? BaseVectors.themeSettings,
                  icon: icon,
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
  final IconData icon;
  final Color color;
  final bool small;
  final String vector;
  final bool isVector;
  _CircleIcon({
    this.icon,
    this.color,
    this.small: false,
    this.leading,
    this.vector,
    this.isVector = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            child: CircleAvatar(
                backgroundColor:
                    color ?? ThemeProvider.of(context).primaryColorDark,
                radius: small == true ? 14.0 : 20.0,
                child: isVector == true && icon == null
                    ? DefaultTextStyle(
                        child: leading ?? Text(""),
                        style: BaseTheme.of(context).subhead1Bold.copyWith(
                            fontSize: small == true ? 14.0 : 20.0,
                            color: Colors.white),
                      )
                    : isVector == false
                        ? SvgPicture.asset(vector)
                        : Icon(icon,
                            size: small == true ? 14.0 : 20.0,
                            color: Colors.white)),
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

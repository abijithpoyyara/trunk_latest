import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class TMListTile extends StatelessWidget {
  const TMListTile({
    Key key,
    this.icon,
    this.color,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _CircleIcon(icon: icon, color: color, small: true),
        _TextTile(title: title, small: true),
      ],
    );
  }
}

class TMGridTile extends StatelessWidget {
  const TMGridTile({
    this.icon,
    this.color,
    this.title,
    this.subTitle,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subTitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: color.withOpacity(.25),
      child: Row(
        children: <Widget>[
         // _CircleIcon(icon: icon, color: color),
          Expanded(child: _TextTile(title: title, subTitle: subTitle)),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class DocumentTypeTile extends StatelessWidget {
  const DocumentTypeTile(
      {this.icon,
      this.color,
      this.title,
      this.subTitle,
      this.onPressed,
      this.selected = false});

  final bool selected;
  final IconData icon;
  final Color color;
  final String title;
  final String subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.only(left: 20.0),
      splashColor: color.withOpacity(.25),
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _TextTile(title: title, subTitle: subTitle, small: !selected),
          _CircleIcon(
            icon: icon,
            color: color,
            small: !selected,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    this.icon,
    this.color,
    this.small: false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      child: CircleAvatar(
          backgroundColor: color,
          radius: small == true ? 14.0 : 20.0,
          child: Icon(
            icon,
            size: small == true ? 14.0 : 20.0,
            color: Colors.white,
          )),
      padding: EdgeInsets.only(right: small == true ? 8.0 : 10.0),
    ));
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
    BaseTheme style = BaseTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: style.body.copyWith(color: Colors.white,
            fontSize: small == true ? 15.0 : 16.0,
          ),
          maxLines: 2,
          softWrap: true,
        ),
        subTitle != null
            ? Text(
                subTitle,
                overflow: TextOverflow.fade,
                style: style.small,
              )
            : const SizedBox(),
      ],
    );
  }
}

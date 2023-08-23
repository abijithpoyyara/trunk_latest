import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';
class TittleBar extends StatelessWidget {
  final String tittle;
  const TittleBar({this.tittle,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width*1.0,
      height:MediaQuery.of(context).size.width*.10,
      color:BaseColors.of(context).hintColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Icon(Icons.keyboard_arrow_left,
        color: BaseColors.of(context).blackColor,),
        Text(tittle ??""
        ,style: TextStyle(color: BaseColors.of(context).blackColor,
              fontSize: 16,
              height: 1.1,
              fontWeight: FontWeight.w500),),
      ],),
    );
  }
}
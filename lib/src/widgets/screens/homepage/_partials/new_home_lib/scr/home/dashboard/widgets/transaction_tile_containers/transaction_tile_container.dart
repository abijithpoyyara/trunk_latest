import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';
// import 'package:cybertrade_app/scr/home/dashboard/home_head_widget.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/home_head_widget.dart';
class TransactionTileContainer extends StatefulWidget {
  final TransactionTileGridModel tileData;
  const TransactionTileContainer({ this.tileData, Key key}) : super(key: key);

  @override
  State<TransactionTileContainer> createState() => _TransactionTileContainerState();
}

class _TransactionTileContainerState extends State<TransactionTileContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height*.60,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: BaseColors.of(context).commonWhiteColor,
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.tileData.imagrUrl,
            // height: 60,
            // width: 60,
          ),
          const SizedBox(height: 2.0),
          Text(
           widget.tileData.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 2.1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

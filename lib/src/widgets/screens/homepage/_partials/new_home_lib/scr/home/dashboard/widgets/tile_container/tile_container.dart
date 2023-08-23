// import 'package:cybertrade_app/scr/home/dashboard/home_head_widget.dart';
// import 'package:cybertrade_app/scr/home/dashboard/widgets/optioncontainer/option_container.dart';
// import 'package:cybertrade_app/util/colors.dart';
import 'package:flutter/material.dart';

import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/optioncontainer/option_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';
class TileContainer extends StatefulWidget {
  final TileGridModel reportTiledata;
  const TileContainer({ this.reportTiledata, Key key}) : super(key: key);

  @override
  State<TileContainer> createState() => _TileContainerState();
}

class _TileContainerState extends State<TileContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(

            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: homeContainerWhiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.reportTiledata.pendingCount >= 100
                          ? "99+ pending"
                          : "${widget.reportTiledata.pendingCount} pending",
                      style: const TextStyle(
                        fontFamily: 'poppins',
                        color: homePendingTextColor,
                        fontSize: 10,
                        height: 1.25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Image.asset(
                    widget.reportTiledata.imagrUrl,
                    height: 60,
                    width: 60,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.reportTiledata.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: baseBlck,
                      fontSize: 14,
                      height: .85,
                      fontWeight: FontWeight.w400,
                    ),

                  ),
                ),

              ],
            ),
          ),
          Positioned(
            right: 10, // Move the circle partially outside
            top: 3, // Move the circle partially outside
            child: Container(
              alignment: Alignment.center,
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: homeUnreadCountColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.reportTiledata.pendingCount >= 100
                    ? "99+"
                    : "${widget.reportTiledata.pendingCount}",
                style: const TextStyle(
                  color: homeHeadTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

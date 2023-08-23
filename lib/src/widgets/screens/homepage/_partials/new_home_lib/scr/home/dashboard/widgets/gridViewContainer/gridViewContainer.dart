import 'package:flutter/material.dart';
import 'package:redstars/src/utils/app_functions.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/optioncontainer/option_container.dart';

import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/tile_container/tile_container.dart';

import '../../../home_screen.dart';

class GridViewContainerhorizontal extends StatefulWidget {
  final List<TileGridModel> gridList;
  const GridViewContainerhorizontal({this.gridList,Key key}) : super(key: key);

  @override
  _GridViewContainerhorizontalState createState() => _GridViewContainerhorizontalState();
}

class _GridViewContainerhorizontalState extends State<GridViewContainerhorizontal> {
  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 1.0;

    if (isPortraitMode()) {
      return
        horizontalGridContainer(MediaQuery.of(context).size.height * .38,MediaQuery.of(context).size.width * 1.0,2);

    }
    else {
      return
        horizontalGridContainer(MediaQuery.of(context).size.height * .35,MediaQuery.of(context).size.width * 1.0,1);

    }

  }

  Widget horizontalGridContainer(double sizedBoxHeight,double width,int crossCount)=>
      SizedBox(
        height:sizedBoxHeight,
        width:width,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            childAspectRatio: 1.0,
          ), itemBuilder:  (context, index){
          return TileContainer(reportTiledata: widget.gridList[index],
          );},
          itemCount: widget.gridList.length,
          shrinkWrap: true,
        ),
      );
}



class GridViewContainerVertical extends StatelessWidget {
  final List<TileGridModel> gridList;

  const GridViewContainerVertical({this.gridList,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 1.0;

    if (isPortraitMode()) {
      return verticalGridContainer(containerWidth,3);

    }


          //   SizedBox(
          //
          //   width: containerWidth,
          //   child: GridView.builder(
          //     scrollDirection: Axis.vertical,
          //     physics: const BouncingScrollPhysics(),
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       childAspectRatio: 1.0,
          //     ), itemBuilder:  (context, index){
          //     return TileContainer(reportTiledata: gridList[index],
          //     );},
          //     itemCount: gridList.length,
          //     shrinkWrap: true,
          //   ),
          // );
         else {
      return verticalGridContainer(containerWidth,6);
          // return SizedBox(
          //
          //   width: containerWidth,
          //   child: GridView.builder(
          //     scrollDirection: Axis.vertical,
          //     physics: const BouncingScrollPhysics(),
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 6,
          //       childAspectRatio: 1.0,
          //     ), itemBuilder:  (context, index){
          //     return TileContainer(reportTiledata: gridList[index],
          //     );},
          //     itemCount: gridList.length,
          //     shrinkWrap: true,
          //   ),
          // );
        }
      }

  Widget verticalGridContainer(double containerWidth,int crossCount)=>
      SizedBox(

        width: containerWidth,
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            childAspectRatio: 1.0,
          ), itemBuilder:  (context, index){
          return TileContainer(reportTiledata: gridList[index],
          );},
          itemCount: gridList.length,
          shrinkWrap: true,
        ),
      );
}

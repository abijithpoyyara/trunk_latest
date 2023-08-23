// import 'package:cybertrade_app/scr/home/dashboard/widgets/optioncontainer/option_container.dart';
// import 'package:cybertrade_app/scr/home/dashboard/widgets/tile_container/tile_container.dart';
// import 'package:cybertrade_app/scr/home/demo.dart';
// import 'package:cybertrade_app/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/gridViewContainer/gridViewContainer.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/optioncontainer/option_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/tile_container/tile_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/demo.dart';
class BranchContainer extends StatelessWidget {
 final bool moreStatus ;
   BranchContainer({this.moreStatus,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 1.0;


    return  !moreStatus ? GridViewContainerhorizontal(gridList:branchGridtlist ,)
        :  GridViewContainerVertical(gridList:branchGridtlist ,);
  }
}

final List<TileGridModel> branchGridtlist = [
  TileGridModel(
      id: 0,
      imagrUrl: "images/iconA.png",
      title: "Adama",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),
  TileGridModel(
      id: 0,
      imagrUrl: "images/iconH.png",
      title: "Hawasa",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconB.png",
      title: "Bishefto",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconM.png",
      title: "Mekele",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconRB.png",
      title: "Bahadir",
      reportpage: const Demo1(),
      pendingCount: 102,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconD.png",
      title: "Diredawa",
      reportpage: const Demo1(),
      pendingCount: 0,
      unreadCount: 0
      ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconM.png",
      title: "Mekele",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconRB.png",
      title: "Bahadir",
      reportpage: const Demo1(),
      pendingCount: 102,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconD.png",
      title: "Diredawa",
      reportpage: const Demo1(),
      pendingCount: 0,
      unreadCount: 0
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconM.png",
      title: "Mekele",
      reportpage: const Demo1(),
      pendingCount: 90,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconRB.png",
      title: "Bahadir",
      reportpage: const Demo1(),
      pendingCount: 102,
      unreadCount: 30
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/iconD.png",
      title: "Diredawa",
      reportpage: const Demo1(),
      pendingCount: 0,
      unreadCount: 0
  ),
];
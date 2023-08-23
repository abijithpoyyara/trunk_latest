// import 'package:cybertrade_app/scr/home/dashboard/widgets/tile_container/tile_container.dart';
// import 'package:cybertrade_app/scr/home/demo.dart';
// import 'package:cybertrade_app/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/utils/app_functions.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/gridViewContainer/gridViewContainer.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/tile_container/tile_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/demo.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';

import '../../../home_screen.dart';
class OptionContainer extends StatefulWidget {
  bool moreStatus ;
   OptionContainer({this.moreStatus,Key key}) : super(key: key);

  @override
  _OptionContainerState createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  bool blockedTransactionMoreStatus = false;
  bool unconfirmedTransactinMoreStatus = false;


  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 1.0;



    return  Column(
      children: [

        // Container(
        //   height: 200,
        //   width: 200,
        //   color: isPortraitMode()?Colors.green:Colors.red,),
        if (!widget.moreStatus)
          GridViewContainerhorizontal(gridList:optionGridtlist ,),
        if (widget.moreStatus)
          GridViewContainerVertical(gridList:optionGridtlist ,),
        Container(

            child:
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Blocked Transactions ",
                        style: TextStyle(
                            color: baseBlck,
                            fontSize: 14,
                            height: 2.1,
                            fontWeight: FontWeight.w500),
                      ), GestureDetector(
                        onTap: () {
                          setState(() {
                            blockedTransactionMoreStatus = !blockedTransactionMoreStatus; // Toggle the value
                          });
                        },
                        child: const Text(
                          "More ",
                          style: TextStyle(
                            color: basegreenColor,
                            fontSize: 14,
                            height: 2.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),]),
              if(!blockedTransactionMoreStatus)
                GridViewContainerhorizontal(gridList:optionGridtlist ,),
                if(blockedTransactionMoreStatus)
                  GridViewContainerVertical(gridList:optionGridtlist ,)
              ],
            )

        ),
        Container(
          // height:MediaQuery.of(context).size.height * 0.35 ,color:homeBgColor,
          child:                      Column(
            children: [
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Unconfirmed Transactions ",
                      style: TextStyle(
                          color: baseBlck,
                          fontSize: 14,
                          height: 2.1,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          unconfirmedTransactinMoreStatus = !unconfirmedTransactinMoreStatus; // Toggle the value
                        });
                      },
                      child: const Text(
                        "More ",
                        style: TextStyle(
                          color: basegreenColor,
                          fontSize: 14,
                          height: 2.1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),]),
             if(!unconfirmedTransactinMoreStatus)
               GridViewContainerhorizontal(gridList:optionGridtlist ,),
              if(unconfirmedTransactinMoreStatus)
                GridViewContainerVertical(gridList:optionGridtlist ,),
            ],
          )
          ,
        )
      ],
    );
  }
}
class TileGridModel {
  int id;
  String imagrUrl;
  String title;
  Widget reportpage;
  int pendingCount;
  int unreadCount;
  TileGridModel(
      {this.id,
         this.imagrUrl,
         this.reportpage,
         this.title,
         this.pendingCount,
         this.unreadCount
      });
}


final List<TileGridModel> optionGridtlist = [
  TileGridModel(
      id: 0,
      imagrUrl: "images/generl.png",
      title: "General voucher",
      reportpage: const Demo1(),
      pendingCount: 105,
      unreadCount: 25
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/payment.png",
      title: "Payment voucher",
      reportpage: const Demo1(),
      pendingCount: 25,
      unreadCount: 38
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/generl.png",
      title: "Sales Invoice",
      reportpage: const Demo1(),
      pendingCount: 58,
      unreadCount: 30
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/generl.png",
      title: "Payments Request",
      reportpage: const Demo1(),
      pendingCount: 0,
      unreadCount: 0
  ),TileGridModel(
      id: 0,
      imagrUrl: "images/general.png",
      title: "Transaction Unblock Reqest Approval",
      reportpage: const Demo1(),
      pendingCount: 12,
      unreadCount:92
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/payment.png",
      title: "Recent 1",
      reportpage: const Demo1(),
      pendingCount: 28,
      unreadCount: 42
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/generl.png",
      title: "Recent 2",
      reportpage: const Demo1(),
      pendingCount: 68,
      unreadCount: 20
  ),TileGridModel(
      id: 2,
      imagrUrl: "images/generl.png",
      title: "Recent 3",
      reportpage: const Demo1(),
      pendingCount: 102,
      unreadCount: 35
  ),];

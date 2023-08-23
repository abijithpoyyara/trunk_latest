import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/branch_container/brach_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/optioncontainer/option_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/toggle_button/home_toggle_button.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/toggle_button/home_toggle_button_controller.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/widgets/transaction_tile_containers/transaction_tile_container.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/demo.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';

import 'widgets/home_head_dropdown.dart';

class HomeHeadWidget extends StatefulWidget {
  const HomeHeadWidget({key});

  @override
  _HomeHeadWidgetState createState() => _HomeHeadWidgetState();
}

class _HomeHeadWidgetState extends State<HomeHeadWidget> {
  bool isToggled = false;

  // Default value

  int _selectedButton = 1; // Default selected button
  void updateSelectedButton(int buttonIndex) {
    setState(() {
      _selectedButton = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 1.0;

    return OrientationBuilder(
        key: UniqueKey(),
        builder: (context, orientation) {
      print("Current Orientation: $orientation");
      if (orientation == Orientation.portrait) {
        return Container(
          color:  BaseColors.of(context).backgroundWhiteColor,
          child: Column(
            children: [
              Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: containerWidth,
                    height: MediaQuery.of(context).size.height * .28,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/HomeHeadBg.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: headWidgets(MediaQuery.of(context).size.height*.025)
                  ),
              approvalsContainersWidget(MediaQuery.of(context).size.width * .60,MediaQuery.of(context).size.height*.15),
            ],
          ),
        );
      }
      else {
        return Container(
          color:  BaseColors.of(context).backgroundWhiteColor,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: containerWidth,
                  height: MediaQuery.of(context).size.width * .25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/HomeHeadBg.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: headWidgets(MediaQuery.of(context).size.height * .060)
              ),
              approvalsContainersWidget(MediaQuery.of(context).size.height * .55,MediaQuery.of(context).size.height*.35,),
            ],
          ),
        );
      }
    });




  }

  Widget approvalsContainersWidget(double containerHeigther,double transactionGridHeight)=>
      Expanded(
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      color:  BaseColors.of(context).backgroundWhiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_selectedButton == 1)
              Container(
                width: MediaQuery.of(context).size.width*1,
                child: OptionContainer(moreStatus: isToggled),
              )
            else
              Container(
                width: MediaQuery.of(context).size.width*1,
                child: BranchContainer(moreStatus: isToggled),
              ),

            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width*1,
              height:containerHeigther,
              color: homeContainerWhiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Transactions ",
                    style: TextStyle(
                      color: baseBlck,
                      fontSize: 14,
                      height: 2.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width*1,
                    height: transactionGridHeight,
                    color: BaseColors.of(context).kBackgroundBaseColor,
                    // color: homeContainerWhiteColor,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.07,
                      ),
                      itemBuilder: (context, index) {
                        return TransactionTileContainer(
                          tileData: trasactionGridtlist[index],
                        );
                      },
                      itemCount: trasactionGridtlist.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
  Widget headWidgets(double height)=>
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Image.asset(
                  'images/drawerIcon.png',
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'images/profileIcon.png',
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Redstars Mob Trading',
                  style: TextStyle(
                    color: homeHeadTextColor,
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            CustomDropdown(optionList: branchlist),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: MediaQuery.of(context).size.width*1,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:  BaseColors.of(context).backgroundWhiteColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Approvals ",
                    style: TextStyle(
                      color: baseBlck,
                      fontSize: 14,
                      height: 2.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                          height:height,
                          width: MediaQuery.of(context).size.width*.25,
                          child: ContainerSelector(
                              onButtonSelected:
                              updateSelectedButton)),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isToggled =
                            !isToggled; // Toggle the value
                          });
                        },
                        child:  Text(
                          "More ",
                          style: TextStyle(
                            color: BaseColors.of(context).greenColor,
                            fontSize: 14,
                            height: 2.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );


}


class TransactionTileGridModel {
  int id;
  String imagrUrl;
  String title;
  Widget reportpage;

  TransactionTileGridModel({
    this.id,
    this.imagrUrl,
    this.reportpage,
    this.title,
  });
}

List<String> branchlist = [
  'Redstars Mob Trading',
  'Branch 1',
  'Branch 2',
  'Branch 3',
  'Branch 4',
  'Branch 5',
  'Branch 6',
  'Branch 7',
  'Branch 8',
  'Branch 9',
  'Branch 10',
  'Branch 11',
  'Branch 12',
  'Branch 13',
  'Branch 14',
  'Branch 15',
  'Branch 16',
  'Branch 17',
  'Branch 18',
  'Branch 19',
  'Branch 20',
  'Branch 21',
  'Branch 22',
  'Branch 23',
  'Branch 24'
];
final List<TransactionTileGridModel> trasactionGridtlist = [
  TransactionTileGridModel(
    id: 0,
    imagrUrl: "images/grantBacklogs.png",
    title: "Blockages ",
    reportpage: const Demo1(),
  ),
  TransactionTileGridModel(
    id: 1,
    imagrUrl: "images/grantBacklogs.png",
    title: "Grant Backlogs  ",
    reportpage: const Demo2(),
  ),
  TransactionTileGridModel(
    id: 0,
    imagrUrl: "images/unblockRequest.png",
    title: "Unblock Request",
    reportpage: const Demo2(),
  ),
];

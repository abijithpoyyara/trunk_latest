import 'package:base/res/values/base_colors.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/settings/widgets/containerCard.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/settings/widgets/themeBar.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/settings/widgets/tittleBar.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:BaseColors.of(context).commonWhiteColor,

      body: Column(
      children: [
        ThemeBar(),
        TittleBar(tittle: "Settings",),
        Container(
          width: MediaQuery.of(context).size.width*1.0,
          height: 500,
          child: ListView.builder(
            itemCount: containerData.length,
            itemBuilder: (context, index) {
              return ContainerCard(
                image: containerData[index].image,
                title: containerData[index].title,
                subtitle: containerData[index].subtitle,
                icon: containerData[index].icon,
              );
            },
          ),
        )
      ],
    ),
      // appBar: BaseAppBar(title: Text( "Settings")),
    );
  }
}
class ContainerModel {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;

  ContainerModel({ this.image,  this.title,  this.subtitle,  this.icon});
}
final List<ContainerModel> containerData = [
  ContainerModel(
    image: 'images/notificationIcon.png',
    title: 'Notifications',
    subtitle: 'Alert,notifications',
    icon: Icons.keyboard_arrow_right,
  ),
  ContainerModel(
    image: 'images/appearanceIcon.png',
    title: 'Appearance',
    subtitle: 'Update App Theme mode',
    icon: Icons.keyboard_arrow_right,
  ),
  ContainerModel(
    image: 'images/languageIcon.png',
    title: 'App Language',
    subtitle: 'English (phone’s language)',

  ),

  // Add more container data here...
];
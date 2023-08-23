import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/home/home_viewmodel.dart';

class HeaderWidget extends StatelessWidget {
  final HomeViewModel viewModel;

  const HeaderWidget({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 20.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        // border: const Border(
        //   bottom: const BaseBorderSide(),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         SvgPicture.asset(AppVectors.logo),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

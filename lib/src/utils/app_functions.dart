import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/home_screen.dart';

bool isPortraitMode(){
  if((MediaQuery.of(oriantionKey.currentContext).orientation)==Orientation.portrait){
    return true;
  }
  return false;
}
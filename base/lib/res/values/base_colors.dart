import 'dart:math';

import 'package:flutter/material.dart' show Colors, MaterialColor;
import 'package:flutter/widgets.dart';

const _iceBlue = 0xFFe5f0ff;
const _lightBlueGrey = 0xFFa0b2cc;

const _baseBlue = 0xFFDF7D3E;
const _baseColor = 0xFFedf0f4;

const Color _selectedColor = const Color(0xFF954E2C);
const Color _accent = const Color(_baseColor);
// const Color _primary = const Color(_baseBlue);
// const Color _secondary = const Color(0xFFFA8F4B);
// const Color _secondaryDark = const Color(0xFF96562D);
const Color border_color = const Color(_iceBlue);
const Color error_border_color = const Color(0xFF7a0060);
// const Color _light_grey = const Color(0xFFedf0f4);

const Color _danger = const Color(0xFFEB5757);
const Color _info = const Color(0xFF2D9CDB);
const Color _warning = const Color(0xFFF1B61E);
const Color _gold = const Color(0xFFD58929);
// const Color _green = const Color(0xFF00C853);

const Color _chartColor3 = const Color(0xFFedf0f4);
const Color _chartColor1 = const Color(0xFF83cfff);
const Color _chartColor2 = const Color(0xFF2d99ff);
////////////////////////////////////////////////////////
const Color _grey = const Color(0xFF575757);
const Color _green = const Color(0xFF26B476);

const Color _light_grey = const Color(0xFFF1F1F1);
const Color _baseBlack = Color(0xff000000);

const Color _whiteColor = Color(0xffffffff);

const Color _bacgroundGreyColor = Color(0xffF4F4F4);

const Color bottumNavigationBarColor = Color(0xffFDF7F5);
const Color homePendingTextColor = Color(0xff0475B2);
const Color _primary = Color(0xffFF7715);
const Color _secondaryDark = Color(0xff145372);
const Color _secondary = Color(0xff1782B6);

const MaterialColor _chartColors = MaterialColor(0xFF83cfff, <int, Color>{
  1: _chartColor1,
  2: _chartColor2,
  3: _chartColor3,
});

class BaseColors extends InheritedWidget {
  BaseColors({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child) {}

  factory BaseColors.of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: BaseColors);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  Widget build(BuildContext context) {
    return BaseColors(
      child: child,
    );
  }

  Color get selectedColor => _selectedColor;
  Color get unselectedColor => _accent;

  Color get dividerColor => border_color;

  Color get kTextBaseColor => _accent;

  Color get kTitleBaseColor => kTextBaseColor;

  Color get kBackgroundBaseColor => Colors.white;

  Color get kAppBarBackgroundColor => Colors.white;

  Color get primaryColor => _primary;
  Color get secondaryDark => _secondaryDark;
  Color get secondaryColor => _secondary;
  Color get accentColor => _accent;

  Color get borderColor => border_color;

  Color get borderSideErrorColor => error_border_color;

  Color get hintColor => _light_grey;

  Color get textGreyColor => _grey;

  Color get commonWhiteColor => _whiteColor;

  Color get backgroundWhiteColor =>_bacgroundGreyColor;

  Color get dangerColor => _danger;

  Color get infoColor => _info;

  Color get warningColor => _warning;

  Color get goldColor => _gold;

  Color get greenColor => _green;

  Color get blackColor => _baseBlack;

  MaterialColor get chartColors => _chartColors;

  MaterialColor get dark => MaterialColor(0xFF444444, const <int, Color>{
        50: const Color(0xFFfafafa),
        100: const Color(0xFFf5f5f5),
        200: const Color(0xFFefefef),
        300: const Color(0xFFe2e2e2),
        400: const Color(0xFFbfbfbf),
        500: const Color(0xFFa0a0a0),
        600: const Color(0xFF777777),
        700: const Color(0xFF636363),
        800: const Color(0xFF444444),
        900: const Color(0xFF232323),
      });

  MaterialColor get white => MaterialColor(
        0xFFFFFFFF,
        const <int, Color>{
          50: const Color(0xFFFFFFFF),
          100: const Color(0xFFfafafa),
          200: const Color(0xFFf5f5f5),
          300: const Color(0xFFf0f0f0),
          400: const Color(0xFFdedede),
          500: const Color(0xFFc2c2c2),
          600: const Color(0xFF979797),
          700: const Color(0xFF818181),
          800: const Color(0xFF606060),
          900: const Color(0xFF3c3c3c),
        },
      );
}

class RandomColorPicker {
  List<int> colors;

  RandomColorPicker() {
    colors = List();
    print("color length :${Colors.primaries.length}");
  }

  MaterialColor getRandomColor({bool getUniqueColor = false}) {
    int random;
//    do {
    random = getRandom();
//    } while (colors.contains(random));
    return Colors.primaries[random];
  }

  int getRandom() {
    return Random().nextInt(Colors.primaries.length);
  }
}

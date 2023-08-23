import 'package:flutter/widgets.dart';

mixin BaseKeyboardProvider {
  BuildContext get context;

  void closeKeyboard() => FocusScope.of(context).requestFocus(
        FocusNode(),
      );
}

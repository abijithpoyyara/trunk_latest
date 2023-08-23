import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final int initValue;

  const InputDialog({Key key, this.title, this.initValue}) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  int value;

  GlobalKey<FormFieldState> _inputKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).subhead1Bold;
    BaseTheme theme=BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    TextEditingController _controller =
        TextEditingController(text: "${widget.initValue}");

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          color:themeData.primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 24.0),
              Text(
                '${widget.title}   ',
              ),
              const SizedBox(height: 14.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Expanded(
                        child: TextFormField(
                            key: _inputKey,
                            controller: _controller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(),
                            validator: (val) =>
                                val.isEmpty ? "Enter value" : null,
                            onSaved: (val) => value = int.parse(val ?? 0)))
                  ])),
              const SizedBox(height: 22.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    color: themeData.primaryColor,
                    onPressed: () {
                      FormFieldState _field = _inputKey.currentState;
                      if (_field.validate()) _field.save();
                      Navigator.pop(context, value ?? 0);
                    },
                    child: Text(
                      'OK',
                    ),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
              const SizedBox(height: 22.0),
            ],
          ),
        ),
      ),
    );
  }
}

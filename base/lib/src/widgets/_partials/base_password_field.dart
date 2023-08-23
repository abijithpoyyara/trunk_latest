import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasePasswordField extends StatefulWidget {
  const BasePasswordField(
      {this.initialValue,
      this.fieldKey,
      this.style,
      this.onSaved,
      this.onChanged,
      this.validator,
      this.enabled = true,
      this.onFieldSubmitted,
      this.controller,
      this.scrollPadding = const EdgeInsets.only(bottom: 48.0),
      this.decoration = const InputDecoration(),
      this.textInputAction,
        this.cursorColor,
      this.focusNode})
      : assert(decoration != null),
        assert(scrollPadding != null);

  final Key fieldKey;
  final bool enabled;
  final String initialValue;
  final TextStyle style;
  final InputDecoration decoration;
  final EdgeInsets scrollPadding;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Color cursorColor;

  @override
  _BasePasswordFieldState createState() => _BasePasswordFieldState();
}

class _BasePasswordFieldState extends State<BasePasswordField> {
  bool _obscureText = true;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(
          text: widget.initialValue,
        );

    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: widget.cursorColor,
        controller: _controller,
        key: widget.fieldKey,
        obscureText: _obscureText,
        onSaved: widget.onSaved,
        style: widget.style,
        enabled: widget.enabled,
        scrollPadding: widget.scrollPadding,
        textCapitalization: TextCapitalization.none,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        decoration: widget.decoration.copyWith(
            suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: BaseColors.of(context).white))));
  }
}

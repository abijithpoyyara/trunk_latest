import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';


class Login extends StatelessWidget {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  Login({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final BaseLoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    final theme = BaseTheme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final headerHeight = height * 0.41;
    final controlsHeight = height * 0.49;
    final formFieldHeight = height * 0.073;
    final formPadding = width * 0.16;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              height: headerHeight,
              child: Stack(children: <Widget>[
//                Positioned(
//                    top: 0,
//                    bottom: headerHeight * 0.25,
//                    left: 0,
//                    right: 0,
//                    child: SvgPicture.asset(
//                      AppVectors.header_wave,
//                      fit: BoxFit.fill,
//                      height: height * 0.11,
//                      width: width,
//                    )),
                Positioned(
                    top: 0,
                    bottom: headerHeight * 0.25,
                    left: width * 0.25,
                    right: width * 0.25,
                    child: Image(
                        image: BaseImages.myacsysLogoWithTitle,
                        fit: BoxFit.scaleDown,
                        height: headerHeight * 0.11,
                        width: width * 0.49))
              ])),
          SizedBox(height: height * 0.02),
          Text("Login",
              textAlign: TextAlign.center, style: theme.display4.copyWith()),
          Expanded(
              child: Container(
            width: width,
            height: controlsHeight,
            child: Form(
                key: _loginFormKey,
                child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: formPadding),
                    child: _LoginForm(
                      formKey: _loginFormKey,
                      viewModel: viewModel,
                      formFieldHeight: formFieldHeight,
                    ))),
          )),
          Text('MyAcsys  ${Settings.getVersion()}',
              style: theme.small.copyWith(fontStyle: FontStyle.normal),
              textAlign: TextAlign.center)
        ]);
  }
}

class _LoginForm extends StatefulWidget {
  final double formFieldHeight;
  final BaseLoginViewModel viewModel;

  final GlobalKey<FormState> formKey;

  const _LoginForm(
      {Key key, this.formFieldHeight, this.viewModel, this.formKey})
      : super(key: key);

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  LoginModel loginUser = LoginModel();

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    BaseColors colors = BaseColors.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _InputControl(
              formFieldHeight: widget.formFieldHeight,
              initialValue: widget.viewModel.clientId,
              hint: 'Client ID',
              onSaved: (val) => loginUser.clientId = val,
              validation: "Client id is Mandatory"),
          SizedBox(height: 15),
          _InputControl(
              formFieldHeight: widget.formFieldHeight,
              initialValue: widget.viewModel.userName,
              hint: 'Username',
              onSaved: (val) => loginUser.userName = val,
              validation: "User Name is Mandatory"),
          SizedBox(height: 15),
          Container(
              height: widget.formFieldHeight,
              color: Colors.white,
              child: BasePasswordField(
                  initialValue: widget.viewModel.password,
                  style: theme.body2.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                      hintStyle: theme.body2
                          .copyWith(fontSize: 18, color: colors.hintColor),
                      hintText: "Password"),
                  onSaved: (val) => loginUser.password = val,
                  validator: (val) =>
                      val.isEmpty ? "password is Mandatory" : null,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) => _save(loginUser))),
          SizedBox(height: widget.formFieldHeight),
          MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 47),
              color: themeData.primaryColor,
              child: Text('Sign In'),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              onPressed: () => _save(loginUser))
        ]);
  }

  _save(LoginModel loginUser) {
    final FormState form = widget.formKey.currentState;

    if (form.validate()) {
      form.save();
      widget.viewModel
          .login(loginUser);
    }
  }
}

class _InputControl extends StatelessWidget {
  final double formFieldHeight;
  final String initialValue;
  final String hint;
  final String validation;
  final bool password;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final Function(String) onSaved;

  const _InputControl(
      {Key key,
      @required this.formFieldHeight,
      @required this.initialValue,
      @required this.hint,
      @required this.onSaved,
      @required this.validation,
      this.password = false,
      this.textInputAction,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return Container(
        height: formFieldHeight,
        color: Colors.white,
        child: TextFormField(
          initialValue: initialValue,
          obscureText: password,
          style: theme.body2.copyWith(fontSize: 18),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: colors.white.withOpacity(0.70))),
              disabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: colors.white.withOpacity(0.70))),
              hintStyle:
                  theme.body2.copyWith(fontSize: 18, color: colors.white),
              hintText: hint),
          onSaved: (val) => onSaved(val),
          validator: (val) => val.trim().isEmpty ? "$validation" : null,
          onFieldSubmitted: (val) => onFieldSubmitted(val.trim()),
        ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 1.33);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height / 2);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

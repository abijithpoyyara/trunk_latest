import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/login/login_viewmodel.dart';
import '../../../../../utility.dart';

bool locationFlag = false;
ClientLevelDetails defaultLocation;
final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

class Login extends StatelessWidget {
  Login({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final LoginViewModel viewModel;
//  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    bool isExpanded = viewModel?.isExpanded ?? false;

    final theme = BaseTheme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final headerHeight =  height * 0.14;
    final controlsHeight = height * 0.02;
    final formFieldHeight = height * 0.10;
    final formPadding = width * 0.16;
    return AnimatedContainer(
      color: ThemeProvider.of(context).primaryColor,
      height:  height,
      duration: kThemeAnimationDuration,
      width: width,
      child: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: height,
          width: width,
          color: ThemeProvider.of(context).primaryColor,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned(
                child: SvgPicture.asset(
                  AppVectors.background,
                  color: ThemeProvider.of(context).scaffoldBackgroundColor,
                  height: height,
                  width: width,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                  top: 0,
                  bottom:  height * .56,
                  left: width * 0.04,
                  right: width * 0.4,
                  child: Image(
                      image: AppImages.logo,
                      fit: BoxFit.scaleDown,
                      height: headerHeight * 0.09,
                      width: width * 0.49)),
              viewModel?.loadingStatus == LoadingStatus.loading
                  ? Center(child: BaseLoadingView())
                  : Align(
                      alignment: Alignment.center,
                      child: Form(
                          key: loginFormKey,
                          child: ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * .04),
                              children: <Widget>[
                               SizedBox(
                                        height: height * .073,
                                      ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical : height * .04,
                                      horizontal: 0),
                                  child: Text("Sign in to continue",
                                      style: theme.subhead1Semi.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                ),
                                _LoginForm(
                                    formKey: loginFormKey,
                                    viewModel: viewModel,
                                    formFieldHeight: formFieldHeight),
                              ])),
                    ),
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * .05,
                            horizontal: width * .08),
                        child: Opacity(
                          opacity: 0.80,
                          child: Text(
                              '${BaseStrings.instance.appName.toUpperCase()} ${Settings.getVersion()}',
                              style: theme.smallMedium.copyWith(
                                  fontStyle: FontStyle.normal,
                                  color: theme.colors.white.withOpacity(0.70)),
                              textAlign: TextAlign.center),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final double formFieldHeight;
  final LoginViewModel viewModel;

  final GlobalKey<FormState> formKey;

  const _LoginForm(
      {Key key, this.formFieldHeight, this.viewModel, this.formKey})
      : super(key: key);

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  GlobalKey<__BusinessLevelsState> _businessLevelKey = GlobalKey();
  LoginModel loginUser = LoginModel();
  LiveClientDetails _selectedLiveCompany;
  TextEditingController _clientIdController;
  TextEditingController _liveCompanyController;

  List<LoginModel> savedCompanyList = [];
  LoginModel userWithCompanyDetails = LoginModel();
  String pass;
  String username;
  String paswrd;
  String clientid;

  @override
  void initState() {
    super.initState();
    locationFlag = false;
    _selectedLiveCompany = widget.viewModel.selectedLiveCompany;
    _clientIdController =
        TextEditingController(text: '${_selectedLiveCompany?.client_id ?? ""}');
  }

  @override
  void dispose() async{
    print("App minimised");
    _clientIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isExpanded = widget.viewModel.isExpanded;
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 0,
      color: themeData.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: !isExpanded,
//            maintainState: true,
            child: Container(
              height: widget.formFieldHeight,
              color: themeData.scaffoldBackgroundColor,
              child: BaseDropDownField<LiveClientDetails>(
                iconEnableColor: Colors.white,
                iconDisabledColor: BaseColors.of(context).primaryColor,
                contentPadding:
                    EdgeInsets.fromLTRB(0, height * .003, 0, height * .005),
                isExpanded: false,
                hint: "",
                label: "Company",
                labelStyle: theme.smallMedium.copyWith(
                    fontSize: 16, color: colors.white.withOpacity(0.70)),
                // initialValue: _selectedLiveCompany,
                items: widget.viewModel.clientCompanyDetails,
                builder: (val) => Text("${val.clientname}"),
                onChanged: (val) => setState(() {
                  print("selectedCompany${_selectedLiveCompany}");
                  return _selectedLiveCompany = val;
                }),
                onSaved: (val) {
                  print("selectedCompany${loginUser.liveClientDetails}");
                  return loginUser.liveClientDetails =
                      _selectedLiveCompany ?? val;
                },
              ),
            ),
          ),
          Visibility(
            visible: false,
            maintainState: true,
            child: _InputControl(
                controller: TextEditingController(
                    text: '${_selectedLiveCompany?.client_id ?? ""}'),
                // initialValue:isExpanded?widget.viewModel.clientId:'RWV',
                displayTitle: "Client ID",
                formFieldHeight: widget.formFieldHeight,
                onSaved: (val) {
                  setState(() {
                    clientid = val;
                    print("Client id${loginUser.clientId}");
                    return loginUser.clientId = val;
                  });
                },
                isEnabled: !isExpanded,
                // readonly: true,
                validation: "Client id is Mandatory"),
          ),
          _InputControl(
              displayTitle: 'Username',
              formFieldHeight: widget.formFieldHeight,
              initialValue: widget.viewModel.userName,
              // hint: 'Username',
              isEnabled: !isExpanded,
              onSaved: (val) => loginUser.userName = val,
              validation: "User Name is Mandatory"),
          Container(
              height: widget.formFieldHeight,
              color: themeData.scaffoldBackgroundColor,
              child: BasePasswordField(
                cursorColor: colors.white,
                initialValue: widget.viewModel.password,
                enabled: !isExpanded,
                style: theme.smallMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, height * .003, 0, 0),
                  disabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: colors.white.withOpacity(0.70))),
                  labelText: 'Password',
                  labelStyle: theme.smallMedium.copyWith(
                      fontSize: 16, color: colors.white.withOpacity(0.70)),
                  hintStyle:
                      theme.body2.copyWith(fontSize: 18, color: colors.white),
                  // hintText: "Password"
                ),
                onSaved: (val) => loginUser.password = val,
                validator: (val) =>
                    val.isEmpty ? "password is Mandatory" : null,
                textInputAction: TextInputAction.done,
//                  onFieldSubmitted: (term) => _save(loginUser)
              )),
          isExpanded
              ? SizedBox(
                  height: 0,
                )
              : SizedBox(height: MediaQuery.of(context).size.height * .001),
          Visibility(
            visible: !isExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
//                MaterialButton(
//                    padding: EdgeInsets.symmetric(
//                        vertical: isExpanded ? 0 : 15, horizontal: 47),
//                    color: themeData.primaryColorDark,
//                    child: Text('Save'),
//                    textColor: Colors.white,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(12)),
//                    onPressed: () {
//                      _showMore(loginUser);
//                      // _save(loginUser, widget.viewModel); //RD2199-22
//                    }),
                MaterialButton(
                    padding: EdgeInsets.symmetric(
                        vertical: isExpanded ? 0 : 15, horizontal: 47),
                    color: themeData.primaryColorDark,
                    child: Text('Log In'), //RD2199-22
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () async {
                      _showMore(loginUser);
                      if(loginUser.userName !="" && loginUser.password !="")
                        widget.viewModel.resetScreenState(ScreenState.Branch);

                    }),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
//          if (isExpanded)
//            _BusinessLevels(
//              formFieldHeight: widget.formFieldHeight,
//              viewModel: widget.viewModel,
//              key: _businessLevelKey,
//            )
//          else
//            InkWell(
//                onTap: () => _showMore(loginUser),
//                child: Text("",
//                    style: theme.button.copyWith(color: colors.white))),
          SizedBox(height: MediaQuery.of(context).size.height * .03),
//          Visibility(
//            visible: isExpanded,
//            child: MaterialButton(
//                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 47),
//                color: themeData.primaryColorDark,
//                child: Text('Save'),
//                textColor: Colors.white,
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(12)),
//                onPressed: () {
//                  print(widget.viewModel.selectedLocation.name);
//                  print(loginUser.location?.name);
//                  print(userWithCompanyDetails.location?.name);
//                  if (locationFlag == false &&
//                          widget.viewModel.selectedLocation != defaultLocation
//                      // && (loginUser123.location != null)
//                      ) {
//                    showDialog(
//                        context: context,
//                        builder: (context) {
//                          return AlertDialog(
//                            backgroundColor: themeData.scaffoldBackgroundColor,
//                            title: Text("Select Location"),
//                            actions: [
//                              BaseRaisedButton(
//                                  child: Text("OK"),
//                                  onPressed: () {
//                                    Navigator.pop(context);
//                                  })
//                            ],
//                          );
//                        });
//                  } else {
//                    _save(loginUser, widget.viewModel); //RD2199-22
//                  }
//                }),
//          ),
        ],
      ),
    );
  }

  _save(LoginModel loginUser, LoginViewModel viewmodel) async {
    // widget.viewModel.getBusinessDetailss(loginUser); //RD2199-22
    final FormState form = widget.formKey.currentState;
    final __BusinessLevelsState levelsState = _businessLevelKey.currentState;
    if (form.validate()) {
      form.save();
      final String SharedCompanyString =
          await BasePrefs.getString('CompanyList');
      if (widget.viewModel.isExpanded) {
        print("MSSSSS");
        print(viewmodel.locations.userId);
        // viewmodel.saveCredentials(loginUser.merge(levelsState.onSubmit()));
        userWithCompanyDetails = LoginModel(
                clientId: loginUser.clientId,
                userName: loginUser.userName,
                password: loginUser.password,
          liveClientDetails:
              loginUser?.liveClientDetails ?? viewmodel.selectedLiveCompany,
                userId: viewmodel.locations.userId.toString(),
                branch: loginUser.branch,
                location: loginUser.location,
                company: loginUser.company,
        ).merge(levelsState.onSubmit());
        print("MSSSSS");
        print(viewmodel.locations.userId);
      } else {
        print("Enters");
        print(viewmodel.locations.userId);
        userWithCompanyDetails = LoginModel(
            clientId: loginUser.clientId,
            userName: loginUser.userName,
            password: loginUser.password,
            userId: viewmodel.locations.userId.toString(),
            branch: null,
            location: null,
            company: null,
            liveClientDetails: loginUser.liveClientDetails);
        /* RD2199-22 ends */
      }
      savedCompanyList = [];
      if (SharedCompanyString.isNotEmpty && SharedCompanyString != "[]") {
        final List<LoginModel> sharedPrefCompanyList =
            LoginModel.decode(SharedCompanyString);
        print(sharedPrefCompanyList.length);

        List SharedClientList = [];
        bool duplicateCompanyFlag = false;
        if (sharedPrefCompanyList.length > 0) {
          sharedPrefCompanyList.forEach((element) {
            SharedClientList.add(element.clientId);
            SharedClientList.add(element.company.name);
            SharedClientList.add(element.branch.name); //RD2199-22

            if (element.company.name == userWithCompanyDetails?.company?.name &&
                element.branch.name == userWithCompanyDetails?.branch?.name) {
              if (element.clientId == userWithCompanyDetails.clientId) {
                duplicateCompanyFlag = true;
              }
            }
            /* RD2199-22 starts */
          });
          // if (SharedClientList.contains(userWithCompanyDetails?.branch?.name) ||
          //     SharedClientList.contains(userWithCompanyDetails.company.name))
          if (duplicateCompanyFlag == true) {
            print("true");
            savedCompanyList = sharedPrefCompanyList;
            // savedCompanyList.add(loginUser123);
          } else {
            print("false");
            savedCompanyList = sharedPrefCompanyList;
            savedCompanyList.add(userWithCompanyDetails);
            // addToCompanyListFlag = false;
          }
        }
      } else {
        savedCompanyList.add(userWithCompanyDetails);
        // addToCompanyListFlag = false;
      }

      /* RD2199-22 ends */
      final String encodedData = LoginModel.encode(savedCompanyList);
      BasePrefs.setString('CompanyList', encodedData);
      widget.viewModel.resetIsExpanded();
    }
  }

  _showMore(LoginModel loginUser) {
    final FormState form = widget.formKey.currentState;
    if (form.validate()) {
      form.save();
      widget.viewModel.moreDetails(LoginModel(
          clientId: loginUser.clientId,
          userName: loginUser.userName,
          password: loginUser.password,
        liveClientDetails: loginUser.liveClientDetails,
        userId: ((widget.viewModel?.locations?.userId).toString()) ??
            (loginUser.userId).toString(),
          branch: loginUser.branch,
          location: loginUser.location,
          company: loginUser.company,
      ));
    }
  }
}

class _InputControl extends StatelessWidget {
  final double formFieldHeight;
  final String initialValue;
  final String hint;
  final String validation;
  final bool password;
  final bool isEnabled;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final Function(String) onSaved;
  final String displayTitle;
  final bool readonly;
  final TextEditingController controller;

  const _InputControl({
    Key key,
    @required this.formFieldHeight,
    @required this.initialValue,
    @required this.hint,
    @required this.onSaved,
    @required this.validation,
    this.controller,
    this.password = false,
    this.isEnabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.displayTitle,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          height: formFieldHeight,
          margin: EdgeInsets.only(top: height * .003, bottom: height * .003),
          color: themeData.scaffoldBackgroundColor,
          child: TextFormField(
            controller: controller,
            cursorColor: colors.white,
            initialValue: initialValue,
            obscureText: password,
            enabled: isEnabled,
            readOnly: readonly,
            style: theme.smallMedium.copyWith(
                fontSize: 16, color: colors.white, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.white)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.white)),
                contentPadding:
                    EdgeInsets.fromLTRB(0, height * .003, 0, height * .004),
                labelText: displayTitle,
                labelStyle: theme.smallMedium.copyWith(
                    fontSize: 16, color: colors.white.withOpacity(0.70)),
                hintStyle:
                    theme.body2.copyWith(fontSize: 18, color: colors.white),
                hintText: hint),
            onSaved: (val) => onSaved(val),
            validator: (val) {
              return val.trim().isEmpty ? "$validation" : null;
            },
            onFieldSubmitted: (val) => onFieldSubmitted(val?.trim()),
          )),
    );
  }
}

class _DropDownControl extends StatelessWidget {
  final double formFieldHeight;
  final ClientLevelDetails initialValue;
  final String hint;
  final String validation;
  final List<ClientLevelDetails> list;
  final String label;
  final bool isEnabled;
  final TextInputAction textInputAction;
  final Function(ClientLevelDetails) onFieldSubmitted;
  final Function(ClientLevelDetails) onSaved;
  final Function(ClientLevelDetails) onChanged;

  const _DropDownControl(
      {Key key,
      @required this.formFieldHeight,
      @required this.initialValue,
      @required this.hint,
      @required this.onSaved,
      @required this.validation,
      this.label,
      this.isEnabled = true,
      this.textInputAction,
      this.onFieldSubmitted,
      @required this.list,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: height * .073,
        //formFieldHeight,
        color: themeData.scaffoldBackgroundColor,
        child: BaseDropDownField<ClientLevelDetails>(
            style: theme.smallMedium.copyWith(
                fontSize: 16, fontWeight: FontWeight.w400, color: colors.white),
            contentPadding:
                EdgeInsets.fromLTRB(0, height * .003, 0, height * .004),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.white.withOpacity(0.70))),
            iconEnableColor: isEnabled
                ? themeData.scaffoldBackgroundColor
                : themeData.primaryColor,
            labelStyle: theme.smallMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.white.withOpacity(0.70)),
            label: label,
            initialValue: initialValue,
            onSaved: (val) => onSaved(val),
            onChanged: onChanged,
            items: <ClientLevelDetails>[...list],
            builder: (val) => Text("${val.name}")));
  }
}

class _BusinessLevels extends StatefulWidget {
  final LoginViewModel viewModel;
  final double formFieldHeight;

  const _BusinessLevels({
    Key key,
    this.viewModel,
    this.formFieldHeight,
  }) : super(key: key);

  @override
  __BusinessLevelsState createState() => __BusinessLevelsState();
}

class __BusinessLevelsState extends State<_BusinessLevels> {
  LoginModel loginUser = LoginModel();
  ClientLevelDetails selectedBranch;
  ClientLevelDetails selectedCompany;
  ClientLevelDetails selectedLocation;
  LiveClientDetails selectedLiveCompany;
  TextEditingController clientIdController;

  LoginModel onSubmit() => loginUser;

  ClientLevelDetails company;
  ClientLevelDetails branch;
  ClientLevelDetails location;

  @override
  void initState() {
    selectedBranch = widget.viewModel.selectedBranch;
    selectedCompany = widget.viewModel.selectedCompany;
    selectedLocation = widget.viewModel.selectedLocation;
    locationFlag = false;
    //selectedLiveCompany = widget?.viewModel?.selectedLiveCompany;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ClientLevelDetails> branches = widget.viewModel.branches?.levels
        ?.where((val) => val.parentLevelDataId == selectedCompany.id)
        ?.toList();

    ClientLevelDetails _selectedBranch = selectedBranch ??
        branches?.firstWhere((lvl) => lvl.isDefault,
            orElse: () => branches.first);

    List<ClientLevelDetails> locations = widget.viewModel.locations?.levels
        ?.where((val) => val.parentLevelDataId == _selectedBranch.id)
        ?.toList();

    ClientLevelDetails _selectedLocation = selectedLocation ??
        locations?.firstWhere((lvl) => lvl.isDefault,
            orElse: () => locations.first);
    defaultLocation = _selectedLocation;

    return Column(children: <Widget>[
      _DropDownControl(
          formFieldHeight: widget.formFieldHeight,
          initialValue: selectedCompany,
          list: widget.viewModel.companies?.levels ?? <ClientLevelDetails>[],
          hint: "",
          label: "Company",
          onChanged: (val) => setState(() => {
                selectedCompany = val,
                selectedBranch = null,
              }),
          onSaved: (val) => loginUser.company = val,
          validation: "Select company"),
      SizedBox(height: 15),
      _DropDownControl(
          formFieldHeight: widget.formFieldHeight,
          initialValue: _selectedBranch,
          list: branches ?? <ClientLevelDetails>[],
          onChanged: (val) {
            setState(() => {
                  selectedBranch = val,
                  selectedLocation = null,
                });
          },
          label: 'Branch',
          hint: '',
          onSaved: (val) => loginUser.branch = val,
          validation: "Select branch"),
      SizedBox(height: 15),
      _DropDownControl(
          formFieldHeight: widget.formFieldHeight,
          initialValue: _selectedLocation,
          list: locations ?? <ClientLevelDetails>[],
          onChanged: (val) {
            locationFlag = true;
            setState(() => selectedLocation = val);
          },
          label: 'Location',
          hint: '',
          onSaved: (val) => loginUser.location = val,
          validation: "Select location"),
    ]);
  }
}

class LoginModelList {
  final List<LoginModel> loginModel;

  LoginModelList(this.loginModel);

  LoginModelList.fromJson(Map<String, dynamic> json)
      : loginModel = json['loginModel'] != null
            ? List<LoginModel>.from(json['loginModel'])
            : null;

  Map<String, dynamic> toJson() => {
        'doughnuts': loginModel,
      };
}

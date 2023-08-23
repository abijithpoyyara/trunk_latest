import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/model/back_date_sub_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/back_date_entry_model.dart';

class SetBranchOptions<T extends BackDateEntryModel> extends StatefulWidget {
  final BackDatedEntryViewModel viewModel;
  final Function(BackDateEntryModel backDateEntryModel, int index) onNewItem;
  final T selected;
  final int index;
  final List<AddUserList> finalItems;

  const SetBranchOptions(
      {Key key,
      this.viewModel,
      this.onNewItem,
      this.selected,
      this.index,
      this.finalItems})
      : super(key: key);

  @override
  _SetBranchOptionsState createState() => _SetBranchOptionsState();
}

class _SetBranchOptionsState extends State<SetBranchOptions> {
  bool select = false;
  BackDateEntrySubModel entrymodel;
  AddOptionList optionName;
  AddBranchList branchName;

  List<AddUserList> users = [];

  GlobalKey<FormState> _backDatedFormKey = GlobalKey<FormState>();
  final TextEditingController itemGradeRateController =
      TextEditingController(text: "");
  List<dynamic> setDefault = [];

  get dropList => null;

  get list => null;
  double qty;
  SanctionedOptionsModel sanctionedModel;
  List<String> optionNameList = [];
  List branchNameList = [];
  List listOfUsers = [];
  int selectedBranchId;
  String selectedBranch;
  int selectedOptionId;
  List<AddUserList> selectedActionWhom = [];
  List<AddUserList> selectedActionWhom1 = [];
  List<AddUserList> selectedUsersForSanction = [];
  List<String> userListFinal = [];
  String selectedOption = "";
  bool hasDuplicate = false;
  var node;
  var jsRespns;
  var itemGrp;

  bool isOptnChanged = false;
  bool isBranchChanged = false;
  bool isPressed;

  @override
  void initState() {
    isPressed = false;

    entrymodel = widget.viewModel.model ?? BackDateEntrySubModel();
    optionName = widget.selected?.optionName;
    branchName = widget.selected?.branchName;

    users = (widget.selected?.userList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, BackDatedEntryViewModel>(
        init: (store, context) {
          entrymodel = widget.viewModel.model ?? BackDateEntrySubModel();
          optionName = widget.selected?.optionName;
          branchName = widget.selected?.branchName;

          users = (widget.selected?.userList);
        },
        converter: (store) => BackDatedEntryViewModel.fromStore(store),
        builder: (context, viewModel) {
          var userList = viewModel?.userList?.addUserList
              ?.map((grp) => MultiSelectItem<AddUserList>(grp, grp.name))
              ?.toList();

          return AnimatedPadding(
            padding: EdgeInsets.only(top: 25),
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new Container(
                color: ThemeProvider.of(context).scaffoldBackgroundColor,
                height: height * .96,
                width: width,
                //alignment: Alignment.bottomCenter,
                child: Form(
                  key: _backDatedFormKey,
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: themeData.primaryColor,
                          child: Row(children: [
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: width * .03,
                            ),
                            Text("Add New Options",
                                textAlign: TextAlign.center,
                                style: theme.subhead1Bold.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<AddOptionList>(
                            itemAsString: (AddOptionList u) =>
                                u?.optionname ?? "",
                            selectedItem: optionName,
                            clearButtonBuilder: (context) {
                              return;
                            },
                            mode: Mode.DIALOG,
                            label: 'Options',
                            items: widget.viewModel.optionList.addOptionList,
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(),
                            popupItemBuilder: _customPopupItemBuilderExample,
                            dropdownSearchDecoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: themeData.accentColor)),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                              ),
                              fillColor: Colors.orange,
                              labelStyle: BaseTheme.of(context).body2,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              suffixStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            popupBackgroundColor: themeData.primaryColor,
                            showClearButton: false,
                            onChanged: (selectedItem) {
                              setState(() {
                                optionName = selectedItem;
                                branchName = AddBranchList();
                                viewModel.userList?.addUserList?.clear();
                                widget.selected?.userList?.clear();
                                users?.clear();
                              });
                            },
                            dropdownButtonBuilder: (context) {
                              return Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              );
                            },
                            onSaved: (selectedItem) {
                              optionName = selectedItem;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<AddBranchList>(
                            itemAsString: (AddBranchList u) => u?.name ?? "",
                            selectedItem: branchName,
                            // clearButtonBuilder: (context) {
                            //   return;
                            // },
                            mode: Mode.DIALOG,
                            label: 'Branches',
                            items: widget.viewModel?.branchList?.addBranchList,
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(),
                            validator: (AddBranchList value) =>
                                value.name == null
                                    ? 'Please select a branch'
                                    : null,
                            dropdownSearchDecoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: themeData.accentColor)),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                              ),
                              fillColor: Colors.orange,
                              labelText: "Account Name",
                              labelStyle: BaseTheme.of(context).body2,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              suffixStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            popupBackgroundColor: themeData.primaryColor,
                            showClearButton: false,
                            onChanged: (selectedItem) {
                              branchName = selectedItem;

                              setState(() {
                                viewModel.userList?.addUserList?.clear();
                                widget.selected?.userList?.clear();
                                users?.clear();
                                viewModel.getUserList(
                                    branchName.id, optionName.id);
                              });

                              // fetchUserList1(branchName.id, optionName.id);
                            },
                            dropdownButtonBuilder: (context) {
                              return Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              );
                            },

                            onSaved: (selectedItem) {
                              branchName = selectedItem;
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return Container(
                            margin: EdgeInsets.only(right: 5, left: 2),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            padding:
                                EdgeInsets.only(right: width / 9.8, top: 5),
                            child: MultiSelectDialogField<AddUserList>(
                              confirmText: Text(
                                "OK",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    color: themeData.primaryColorDark),
                              ),
                              cancelText: Text(
                                "CANCEL",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    color: themeData.primaryColorDark),
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.transparent))),
                              itemsTextStyle:
                                  TextStyle(color: themeData.accentColor),
                              selectedItemsTextStyle:
                                  TextStyle(color: themeData.accentColor),
                              checkColor: themeData.accentColor,
                              backgroundColor:
                                  themeData.scaffoldBackgroundColor,
                              searchable: true,
                              barrierColor: themeData.scaffoldBackgroundColor,
                              initialValue: users ?? [],
                              items: branchName?.name == ""
                                  ? []
                                  // : widget.selected != null
                                  //     ? _userItem
                                  : userList ?? [],
                              title: Text(
                                "User List",
                                style: TextStyle(fontSize: 12),
                              ),
                              selectedColor: themeData.primaryColorDark,
                              buttonIcon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: themeData.accentColor,
                              ),
                              buttonText: Text(
                                "Users",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onSelectionChanged: (data) {
                                users = data;
                              },
                              onConfirm: (data) {
                                users = data;
                              },
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return "Please select user";
                                }
                                return null;
                              },
                            ),
                          );
                        }),
                        SizedBox(
                          height: 55,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .07,
                          margin: EdgeInsets.only(
                              right: width * .06, left: width * .06),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width,
                          child: BaseRaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                ThemeProvider.of(context).primaryColorDark,
                            onPressed: () {
                              if (widget.selected == null) {
                                if (_backDatedFormKey.currentState.validate()) {
                                  _backDatedFormKey.currentState.save();
                                  widget.viewModel.onModelSave(entrymodel);

                                  widget.onNewItem(
                                      BackDateEntryModel(
                                          optionName: optionName,
                                          branchName: branchName,
                                          userList: users,
                                          isNewItem: true),
                                      null);
                                  Navigator.pop(context);
                                }
                              } else {
                                if (_backDatedFormKey.currentState.validate()) {
                                  _backDatedFormKey.currentState.save();
                                  widget.viewModel.onModelSave(entrymodel);

                                  widget.onNewItem(
                                      BackDateEntryModel(
                                          optionName: optionName,
                                          branchName: branchName,
                                          userList: users,
                                          isNewItem: false),
                                      widget.index);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: widget.selected == null
                                ? Text("ADD")
                                : Text("UPDATE"),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, AddOptionList item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.optionname ?? ''),
        subtitle: Text(
          item.optioncode ?? '',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
        ),
      ),
    );
  }

  Widget _customDropDownExampleMultiSelection(
      BuildContext context, List<AddUserList> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                  // this does not work - throws 404 error
                  // backgroundImage: NetworkImage(item.avatar ?? ''),
                  ),
              title: Text(e?.name ?? ''),
              subtitle: Text(
                e?.code.toString() ?? '',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customPopupItemBuilderExample1(
      BuildContext context, dynamic item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name ?? ""),
        subtitle: Text(
          item.code ?? '',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
        ),
      ),
    );
  }

  // Future fetchUserList1(int branchId, int optionId) async {
  //   print("working");
  //   final headers = {
  //     HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
  //     HttpHeaders.acceptCharsetHeader: "UTF-8",
  //     HttpHeaders.cookieHeader:
  //         await BasePrefs.getString(BaseConstants.COOKIE_KEY)
  //   };
  //   String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
  //   int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
  //   String ssnId = await BasePrefs.getString(SSNIDN_KEY);
  //   String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
  //   print('$jSessionId::::::::::: $ssnId');
  //   var body = {
  //     "url": "/security/controller/cmn/getdropdownlist",
  //     "jsonArr": '[{\"flag\":\"ALL\",\"start\":\"0\",\"limit\":\"1000\",\"value\":\"0\",\"colName\":\"name\",'
  //         '\"params\":[{\"column\":\"BranchId\",\"value\":\"$branchId\"},{\"column\":\"OptionId\",\"value\":\"$optionId\"}],'
  //         '\"dropDownParams\":[{\"list\":\"LOCATION_MULTI_SEL\",\"key\":\"resultObject\",'
  //         '\"procName\":\"BackDatedEntryListproc\",'
  //         '\"actionFlag\":\"LIST\",\"subActionFlag\":\"USER\",'
  //         '}]}]',
  //     'ssnidn': '$ssnId'
  //   };
  //   print(body);
  //   String url = Connections().generateUri() + 'getdata';
  //   var response =
  //       await http.post(Uri.parse(url), headers: headers, body: body);
  //   if (response.body.contains("No Error")) {
  //     print("response ----- ${response.body}");
  //     var jsonResponse = json.decode(response.body);
  //     print("yolo");
  //     node = jsonResponse;
  //     jsRespns = jsonResponse;
  //     var result = node['resultObject'];
  //     var jsResult = jsonEncode(result);
  //     log(jsResult);
  //     Iterable k = json.decode(jsResult);
  //     ds = k != null
  //         ? List<AddUserList>.of(k.map((model) => AddUserList.fromJson(model)))
  //         : null;
  //     if (mounted)
  //       setState(() {
  //         // widget.viewModel.userList.addUserList = ds;
  //         // ds.forEach((element) {
  //         //   users.add(element);
  //         // });
  //       });
  //     print(itemGrp);
  //     print(node);
  //     return jsRespns;
  //   } else if (response.body.isEmpty) {
  //     showLoaderDialog(context);
  //   }
  // }

  showLoaderDialog(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    AlertDialog alert = AlertDialog(
      backgroundColor: themeData.scaffoldBackgroundColor,
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                ThemeProvider.of(context).primaryColor),
          ),
          SizedBox(
            width: 25,
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ListBackDatedPermissionVIew<T extends BackDateEntryModel>
    extends StatelessWidget {
  final T backDatedModel;
  final int index;
  final ValueSetter<T> onClick;
  final BackDatedEntryViewModel viewModel;
  final List<BackDateEntrySubModel> itemGradeRateModelListData;
  final bool isClicked;

  ListBackDatedPermissionVIew(
      {Key key,
      this.backDatedModel,
      this.onClick,
      this.viewModel,
      this.index,
      this.itemGradeRateModelListData,
      this.isClicked = false})
      : super(key: key);
  List<dynamic> filteredUsers = [];

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: themeData.primaryColor,
            // border: Border(bottom: BaseBorderSide())
          ),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            onPressed: () => onClick(backDatedModel),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Option :",
                            style: theme.smallHint,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(backDatedModel?.optionName?.optionname ?? "",
                              style: theme.subhead1),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Branch:",
                            style: theme.smallHint,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(backDatedModel?.branchName?.name ?? "",
                              style: theme.subhead1),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 12.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        2.0,
                        0.0,
                        8.0,
                        0.0,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ListTileTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsets.fromLTRB(
                            15.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          dense: true,
                          horizontalTitleGap: 0.0,
                          minLeadingWidth: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: ExpansionTile(
                                backgroundColor: themeData.primaryColor,
                                collapsedBackgroundColor:
                                    themeData.primaryColor,
                                maintainState: true,
                                trailing: Icon(
                                  Icons.expand_more,
                                  size: 36,
                                ),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        elevation: 0,
                                        color:
                                            themeData.scaffoldBackgroundColor,
                                        child: ListTileTheme(
                                          child: ListTile(
                                            tileColor: themeData.primaryColor,
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  children: List.generate(
                                                      backDatedModel?.userList
                                                          ?.length, (ind) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          4.0, 0.0, 0.0, 0.0),
                                                      child: Chip(
                                                        elevation: 0,
                                                        backgroundColor: themeData
                                                            .primaryColorDark,
                                                        label: Text(
                                                          // filteredUsers[ind]
                                                          //         .name ??
                                                          backDatedModel
                                                                  ?.userList[
                                                                      ind]
                                                                  ?.name ??
                                                              "- -",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                                title: Text(
                                  "User List :",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

showSelectedGradeInformation(
    BuildContext context,
    ItemGradeRateViewModel viewModel,
    GradeLookupItem selectedGrade,
    ItemLookupItem selectedItem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Information")),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          content: Container(
              height: height * .25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.announcement,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: Text(
                              "Grade ${selectedGrade.name}  is already selected for \n ${selectedItem.description}",
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: themeData.primaryColorDark,
                          color: _colors.white.withOpacity(.70),
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )));
    },
  );
}

showRateGraterThanZeroInformation(BuildContext context,
    ItemGradeRateViewModel viewModel, ItemLookupItem selectedItem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Information")),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          content: Container(
              height: height * .25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.announcement,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: Text(
                              "Please enter rate for ${selectedItem.description}",
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: themeData.primaryColorDark,
                          color: _colors.white.withOpacity(.70),
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )));
    },
  );
}

// class MultiSelectDialog extends StatelessWidget {
//   /// List to display the answer.
//   final List<AddUserList> multiUsers;
//
//   /// Widget to display the question.
//   final Widget question;
//
//   /// List to hold the selected answer
//   /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
//   final List<AddUserList> selectedItems;
//
//   /// Map that holds selected option with a boolean value
//   /// i.e. { 'a' : false}.
//   static Map<String, bool> mappedItem;
//
//   MultiSelectDialog({this.multiUsers, this.question, this.selectedItems});
//
//   /// Function that converts the list answer to a map.
//   ///
//   ///
//
//   Map<String, bool> initMap() {
//     return mappedItem = Map.fromIterable(multiUsers,
//         key: (k) => k,
//         value: (v) {
//           if (v != true && v != false)
//             return false;
//           else
//             return v as bool;
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (mappedItem == null) {
//       initMap();
//     }
//     return SimpleDialog(
//       title: question,
//       children: [
//         ...mappedItem.keys.map((dynamic key) {
//           return StatefulBuilder(
//             builder: (_, StateSetter setState) => CheckboxListTile(
//                 title: Text(
//                   key.toString(),
//                   style: TextStyle(color: Colors.black),
//                 ), // Displays the option
//                 value: mappedItem[key], // Displays checked or unchecked value
//                 controlAffinity: ListTileControlAffinity.platform,
//                 onChanged: (value) => setState(() => mappedItem[key] = value)),
//           );
//         }).toList(),
//         Align(
//             alignment: Alignment.center,
//             child: ElevatedButton(
//                 style: ButtonStyle(visualDensity: VisualDensity.comfortable),
//                 child: Text('Submit'),
//                 onPressed: () {
//                   // Clear the list
//                   selectedItems.clear();
//
//                   // Traverse each map entry
//                   mappedItem.forEach((key, value) {
//                     if (value == true) {
//                       selectedItems.add(key as AddUserList);
//                     }
//                   });
//
//                   // Close the Dialog & return selectedItems
//                   Navigator.pop(context, selectedItems);
//                 }))
//       ],
//     );
//   }
// }

class ItemSelectorDialog extends StatefulWidget {
  final Function itemsFunction;
  final List<dynamic> initiallySelected;

  ItemSelectorDialog(
      {@required this.itemsFunction, @required this.initiallySelected});

  @override
  _ItemSelectorDialogState createState() => _ItemSelectorDialogState();
}

class _ItemSelectorDialogState extends State<ItemSelectorDialog> {
  List<dynamic> items;
  List<dynamic> selectedItems;

  @override
  void initState() {
    super.initState();
    items = widget.itemsFunction();
    selectedItems = List.from(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select items'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            bool isSelected = selectedItems.contains(item);
            return CheckboxListTile(
              title: Text(item.toString()),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value != null && value) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(selectedItems),
        ),
      ],
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<AddUserList> options;

  MultiSelectDialog({@required this.options});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<AddUserList> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions =
        widget.options.where((option) => option.isSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    return AlertDialog(
      backgroundColor: themeData.primaryColor,
      title: Text('Select Options'),
      contentPadding: EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.options.map((option) {
            return CheckboxListTile(
              title: Text(option.name),
              value: _selectedOptions.contains(option),
              onChanged: (bool value) {
                setState(() {
                  if (value == true) {
                    _selectedOptions.add(option);
                  } else {
                    _selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop([]);
          },
        ),
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop(_selectedOptions);
          },
        ),
      ],
    );
  }
}

class GridItem extends StatefulWidget {
  final Key key;
  final AddUserList item;
  final ValueChanged<bool> isSelected;

  GridItem({this.item, this.isSelected, this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.isSelected(isSelected);
          });
        },
        // child: Stack(
        //   children: <Widget>[
        //     Text(widget.item.name),
        //     isSelected
        //         ? Align(
        //             alignment: Alignment.bottomRight,
        //             child: Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Icon(
        //                 Icons.check_circle,
        //                 color: Colors.blue,
        //               ),
        //             ),
        //           )
        //         : Container()
        //   ],
        // ),
        child: ListTile(
          title: Text(widget.item?.name ?? ""),
          trailing: isSelected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        ));
  }
}

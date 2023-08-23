import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';

import '../../../../../utility.dart';

var node2;
var jsRespns2;
int selectedBranchId2;

class EditOptionDialog extends StatefulWidget {
  final BackDatedEntryViewModel viewModel;

  const EditOptionDialog({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _EditOptionDialogState createState() => _EditOptionDialogState();
}

class _EditOptionDialogState extends State<EditOptionDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  SanctionedOptionsModel sanctionedModel;
  List<String> optionNameList = [];
  List branchNameList = [];
  List listOfUsers = [];
  int selectedBranchId;
  String selectedBranch;
  int selectedOptionId;
  List<dynamic> selectedActionWhom = [];
  List<String> userListFinal = [];
  String selectedOption = "";
  bool hasDuplicate = false;
  var node;
  var jsRespns;
  var itemGrp;
  List<AddUserList> ds = [];
  // Future subOptionNotificationCountCall() async {
  //   print("working");
  //   final headers = {
  //     HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
  //     HttpHeaders.acceptCharsetHeader: "UTF-8",
  //     HttpHeaders.cookieHeader:
  //     await BasePrefs.getString(BaseConstants.COOKIE_KEY)
  //   };
  //   String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
  //   int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
  //   String ssnId = await BasePrefs.getString(SSNIDN_KEY);
  //   String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
  //   print('$jSessionId::::::::::: $ssnId');
  //   var body = {
  //     "url": "/security/controller/cmn/getdropdownlist",
  //     "jsonArr":
  //     '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",\"key\":\"resultObject\",'
  //         '\"procName\":\"MobileNotificationProc\",'
  //         '\"actionFlag\":\"NOTIFICATION_COUNT\",\"subActionFlag\":\"\",'
  //         '\"xmlStr\":\"<List Flag = \\\"TRANS_OPTION_WISE\\\" /><User Clientid = \\\"$clientId\\\" '
  //         'UserId = \\\"$userId\\\"/>\"'
  //         '}]}]',
  //     'ssnidn': '$ssnId'
  //   };
  //   print(body);
  //   String url = Connections().generateUri() + 'getdata';
  //   var response =
  //   await http.post(Uri.parse(url), headers: headers, body: body);
  //   print("response ----- ${response.body}");
  //   var jsonResponse = json.decode(response.body);
  //   print("yolo");
  //   node2 = jsonResponse;
  //   jsRespns2 = jsonResponse;
  //
  //   return jsRespns2;
  // }

  @override
  Widget build(BuildContext context) {
    final _itemGrp =
    ds?.map((grp) => MultiSelectItem<AddUserList>(grp, grp.name))?.toList();
    final userList = widget?.viewModel?.userList?.addUserList
        ?.map((grp) => MultiSelectItem<AddUserList>(grp, grp.name))
        ?.toList();
    bool isAcctCleared = false;
    ThemeData themeData = ThemeProvider.of(context);

    // widget.viewModel.optionList.addOptionList.forEach((element) {
    //   optionNameList.add(element.optionname);
    // });

    List<String> optionNameList2 = List.generate(
        widget.viewModel.optionList.addOptionList.length,
            (index) =>
        widget.viewModel.optionList.addOptionList[index].optionname)
        .toSet()
        .toList();
    widget.viewModel.branchList.addBranchList.forEach((element) {
      branchNameList.add(element.name);
    });
    return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Material(
              color: themeData.primaryColor,
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Add Option ", style: BaseTheme.of(context).title),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              clearButtonBuilder: (context) {
                                return;
                              },
                              mode: Mode.DIALOG,
                              label: 'Options',
                              items: optionNameList2,
                              showSearchBox: true,
                              // selectedItem: isAcctCleared == true ? "" : "hi",
                              searchFieldProps: TextFieldProps(),
                              popupItemBuilder: _customPopupItemBuilderExample,
                              dropdownSearchDecoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: themeData.accentColor)),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  // child: IconButton(
                                  //   iconSize: 20,
                                  //   icon: Icon(
                                  //     Icons.clear,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       isAcctCleared = true;
                                  //     });
                                  //   },
                                  // ),
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
                                widget.viewModel.setOptionName(selectedItem);
                                selectedOption = selectedItem;
                                selectedOptionId = widget
                                    .viewModel.optionList.addOptionList
                                    .firstWhere((element) =>
                                element.optionname == selectedItem)
                                    .id;
                                print(selectedOptionId);
                                setState(() {
                                  if (selectedBranchId != null) {
                                    fetchUserList(
                                        selectedBranchId, selectedOptionId);
                                    print("mee");
                                    print(widget
                                        .viewModel?.userList?.addUserList?.length);
                                    widget.viewModel.getUserList(
                                        selectedBranchId, selectedOptionId);
                                    print("mee");
                                    print(widget
                                        .viewModel?.userList?.addUserList?.length);
                                  }
                                });
                              },
                              dropdownButtonBuilder: (context) {
                                return Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                );
                              },
                              onSaved: (selectedItem) {
                                selectedOption = selectedItem;
                                widget.viewModel.setOptionName(selectedItem);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch(
                              // clearButtonBuilder: (context) {
                              //   return;
                              // },
                              mode: Mode.DIALOG,
                              label: 'Branches',
                              items: branchNameList,
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(),
                              dropdownSearchDecoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: themeData.accentColor)),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  // child: IconButton(
                                  //   iconSize: 20,
                                  //   icon: Icon(
                                  //     Icons.clear,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       isAcctCleared = true;
                                  //       // widget.viewModel.setBranchName("");
                                  //     });
                                  //   },
                                  // ),
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


                                if (selectedOption == "") {
                                  widget.viewModel.setBranchName("");
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor:
                                          themeData.scaffoldBackgroundColor,
                                          title: Text("Please Select A Option"),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                BaseRaisedButton(
                                                    child: Row(
                                                      children: [
                                                        Text("OK"),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                }
                                else {

                                  selectedBranch = selectedItem;
                                  widget.viewModel.setBranchName(selectedItem);
                                  selectedBranchId = widget
                                      .viewModel.branchList.addBranchList
                                      .firstWhere(
                                          (element) => element.name == selectedItem)
                                      .id;
                                  selectedBranchId2 = widget
                                      .viewModel.branchList.addBranchList
                                      .firstWhere(
                                          (element) => element.name == selectedItem)
                                      .id;

                                  setState(() {
                                    fetchUserList(
                                        selectedBranchId, selectedOptionId);
                                    print("mee");
                                    print(widget
                                        .viewModel?.userList?.addUserList?.length);

                                    widget.viewModel.getUserList(
                                        selectedBranchId, selectedOptionId);
                                    print("mee");
                                    print(widget
                                        .viewModel?.userList?.addUserList?.length);
                                  });

                                  // widget.viewModel.getUserList(selectedBranchId, selectedOptionId);
                                  // itemGrp = widget.viewModel.userList.addUserList
                                  //     .map((grp) => MultiSelectItem<AddUserList>(
                                  //     grp, grp.name))
                                  //     .toList();
                                }
                              },
                              dropdownButtonBuilder: (context) {
                                return Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                );
                              },
                              onSaved: (selectedItem) {
                                widget.viewModel.setBranchName(selectedItem);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2, bottom: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Users"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: MultiSelectDialogField(
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
                              itemsTextStyle:
                              TextStyle(color: themeData.accentColor),
                              selectedItemsTextStyle:
                              TextStyle(color: themeData.accentColor),
                              checkColor: themeData.accentColor,
                              backgroundColor: themeData.scaffoldBackgroundColor,
                              searchable: true,
                              barrierColor: themeData.primaryColorDark,
                              initialValue: selectedActionWhom,
                              items: _itemGrp ?? [],
                              title: Text(
                                "User List",
                                style: TextStyle(fontSize: 12),
                              ),
                              selectedColor: themeData.primaryColorDark,
                              decoration: BoxDecoration(
                                color: themeData.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                  color: themeData.primaryColor,
                                  width: 2,
                                ),
                              ),
                              buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                              buttonText: Text(
                                "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onSelectionChanged: (data) {
                                selectedActionWhom = data;
                                print("selectedActionWhom {selectedActionWhom}");
                                selectedActionWhom.forEach((element) {
                                  userListFinal.add(element.name);
                                });
                                widget.viewModel.setUserList(data);
                              },
                              onConfirm: (data) {
                                selectedActionWhom = data;
                                print(selectedActionWhom);
                                widget.viewModel.setUserList(selectedActionWhom);
                              },
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return "Please select atleast one Name";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildFilterButton(
                              widget.viewModel.selectedBranchName,
                              widget.viewModel.selectedOptionName,
                              widget.viewModel.selectedUsers),
                        ],
                      )))),
        ));
  }

  Widget _buildFilterButton(
      String branch, String option, List<dynamic> userList) {
    ThemeData themedata = ThemeProvider.of(context);
    List<String> userFinalList;
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          _submitForm();
          // userList.forEach((element) {
          //   userFinalList.add(element.name);
          // });
          if (userList.isNotEmpty || userList != null) {
            // widget.viewModel.sanctionedList.add(SanctionedOptionsModel(
            //   userList: userList ?? widget.viewModel.selectedUsers,
            //   branchName: branch,
            //   optionName: option,
            // ));
            widget.viewModel.dtlModel.viewList.forEach((element) {
              if(element.optionname == selectedOption
                  && element.branchname == selectedBranch) {
                return hasDuplicate = true;
              }
              else {
                if(hasDuplicate == true){
                  return hasDuplicate = true;
                }
                else{
                  return hasDuplicate = false;
                }
              }
            });
            if(!hasDuplicate){
              widget.viewModel.dtlModel.viewList.add(BackDateEntryDetailList(
                branchname: selectedBranch,
                optionname: selectedOption,
                userList: selectedActionWhom,
              ));
            }
            else {
              return showAlertSameBranchOption(context);
            }

            widget.viewModel.sanctionedList.forEach((element) {
              if (element.userList.isEmpty || element.userList == null) {
                widget.viewModel.sanctionedList.remove(element);
              }
            });
          }
        },
        child: Text(
          'Add to List',
          style: BaseTheme.of(context).bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        color: themedata.primaryColorDark,
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      Navigator.pop(context /*, model*/);
    }
  }

  showAlertSameBranchOption(BuildContext context) {
    final _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        backgroundColor: themeData.scaffoldBackgroundColor,
        title: Center(child: Text("Alert")),
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
                            "This Option and Branch Are Already Selected",
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
                        },
                      ),
                    ),
                  ],
                )
              ],
            )));
  }


  Widget _customPopupItemBuilderExample(
      BuildContext context, String item, bool isSelected) {
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
        title: Text(item ?? ''),
        subtitle: Text(
          widget.viewModel.optionList.addOptionList
              .firstWhere((element) => element.optionname == item)
              .optioncode ??
              '',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
        ),
      ),
    );
  }

  Future fetchUserList(int branchId, int optionId) async {
    print("working");
    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
      HttpHeaders.cookieHeader:
      await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    var body = {
      "url": "/security/controller/cmn/getdropdownlist",
      "jsonArr": '[{\"flag\":\"ALL\",\"start\":\"0\",\"limit\":\"1000\",\"value\":\"0\",\"colName\":\"name\",'
          '\"params\":[{\"column\":\"BranchId\",\"value\":\"$branchId\"},{\"column\":\"OptionId\",\"value\":\"$optionId\"}],'
          '\"dropDownParams\":[{\"list\":\"LOCATION_MULTI_SEL\",\"key\":\"resultObject\",'
          '\"procName\":\"BackDatedEntryListproc\",'
          '\"actionFlag\":\"LIST\",\"subActionFlag\":\"USER\",'
          '}]}]',
      'ssnidn': '$ssnId'
    };
    print(body);
    String url = Connections().generateUri() + 'getdata';
    var response =
    await http.post(Uri.parse(url), headers: headers, body: body);
    print("response ----- ${response.body}");
    var jsonResponse = json.decode(response.body);
    print("yolo");
    node = jsonResponse;
    jsRespns = jsonResponse;
    var result = node['resultObject'];
    var jsResult = jsonEncode(result);
    log(jsResult);
    Iterable k = json.decode(jsResult);
    ds = k != null
        ? List<AddUserList>.of(k.map((model) => AddUserList.fromJson(model)))
        : null;
    print(ds.length);
    setState(() {
      // widget.viewModel.userList.addUserList = ds;
    });
    print(itemGrp);
    print(node);
    return jsRespns;
  }
}

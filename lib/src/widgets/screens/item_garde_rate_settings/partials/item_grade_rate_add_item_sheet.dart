import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/grading_lookup_field.dart';
import 'package:redstars/src/widgets/partials/lookup/item_lookup_field.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';
import 'package:redstars/utility.dart';

class SetGradeRateView<T extends ItemRateGradeModel> extends StatefulWidget {
  final ItemGradeRateViewModel viewModel;
  final Function(ItemRateGradeModel itemGradeRateListModel) onNewItem;
  final T selected;

  const SetGradeRateView({
    Key key,
    this.viewModel,
    this.onNewItem,
    this.selected,
  }) : super(key: key);

  @override
  _SetGradeRateViewState createState() => _SetGradeRateViewState();
}

class _SetGradeRateViewState extends State<SetGradeRateView> {
  double rate;
  ItemLookupItem selectedItem;
  GradeLookupItem grade;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController itemGradeRateController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    rate = widget?.selected?.rate ?? 0;
    selectedItem = widget?.selected?.item;
    grade = widget?.selected?.grade;
  }

  double qty;

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new Container(
          color: ThemeProvider.of(context).scaffoldBackgroundColor,
          height: height * .96,
          width: width,
          //alignment: Alignment.bottomCenter,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //SizedBox(height: height * .06),
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
                      Text("Add New Item Grade Rate",
                          textAlign: TextAlign.center,
                          style: theme.subhead1Bold.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ]),
                  ),

                  _buildItemField(),
                  Container(
                    padding: EdgeInsets.only(left: 8, top: 3, bottom: 3),
                    child: BaseDialogField<GradeLookupItem>(
                      // isChangeHeight: false,
                      vector: AppVectors.transaction,
                      hint: "Tap select data",
                      displayTitle: "Grades",
                      // icon: icon ?? Icons.dashboard,
                      list: widget.viewModel.gradeLists,
                      initialValue: grade,
                      isEnabled: true,
                      listBuilder: (val, pos) => DocumentTypeTile(
                        selected: true,
                        subTitle: val.code,
                        //isVector: true,,
                        // vector: vector,
                        icon: Icons.list,
                        title: val.name,
                        vector: AppVectors.transaction,
                        onPressed: () => Navigator.pop(context, val),
                      ),
                      fieldBuilder: (selected) => Text(
                        selected?.name ?? "",
                        style: BaseTheme.of(context).textfield,
                        textAlign: TextAlign.start,
                      ),
                      onBeforeChanged: (value) {
                        bool flag = false;
                        bool isValid = true;
                        if (widget.viewModel.itemGradeRateListData != null) {
                          widget.viewModel.itemGradeRateListData
                              ?.forEach((element) {
                            if (element.grade.id == value.id &&
                                element.item.code == selectedItem.code) {
                              showSelectedGradeInformation(context,
                                  widget.viewModel, value, selectedItem);
                              isValid = false;
                              // setState(() {});
                            }
                          });
                          return isValid;
                        }
                        return isValid;
                      },
                      onChanged: (value) {
                        grade = value;
                        setState(() {
                          itemGradeRateController.clear();
                        });
                      },
                      onSaved: (value) {
                        grade = value;
                      },
                      validator: (val) =>
                          (val == null) ? "Please select grade" : null,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: BaseTextField(
                      // isVector: true,
                      displayTitle: "Rate",
                      controller: itemGradeRateController,
                      icon: Icons.account_balance_wallet_rounded,
                      //vector: AppVectors.direct,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,5}'))
                      ],
                      // initialValue: "",
                      isNumberField: true,
                      onTap: () {
                        itemGradeRateController.clear();
                      },
                      onChanged: (val) {
                        qty = double.parse(val);
                        print("enter value $val");
                        rate = qty;

                        print("enter value${rate}");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter rate";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        qty = double.parse(val);
                        rate = qty;
                      },
                    ),
                  ),

                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    margin:
                        EdgeInsets.only(right: width * .06, left: width * .06),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width,
                    child: BaseRaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor:
                          ThemeProvider.of(context).primaryColorDark,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (rate > 0) {
                            widget.onNewItem(ItemRateGradeModel(
                                item: selectedItem, rate: rate, grade: grade));
                            Navigator.pop(context);
                          } else {
                            showRateGraterThanZeroInformation(
                                context, widget.viewModel, selectedItem);
                            itemGradeRateController.clear();
                          }
                        }
                      },
                      child: Text("ADD"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      // margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 2, left: 5),
            child: Icon(
              Icons.location_on_outlined,
              color: themeData.accentColor,
            ),
          ),
          Expanded(
            child: ItemLookupTextField(
              isVector: true,
              vector: AppVectors.itemBox,
              displayTitle: "Items",
              hint: "Select Item",
              initialValue: selectedItem,
              onChanged: (val) {
                //setState(() {
                selectedItem = val;
                //  });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildgradeField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      // margin: EdgeInsets.only(right: width * 0.043, left: width * 0.043),
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on_outlined,
            color: themeData.accentColor,
          ),
          Expanded(
              child: GradingLookupTextField(
            isVector: true,
            displayTitle: "Grades",
            hint: "Select Grade",
            initialValue: grade,
            onChanged: (val) {
              //setState(() {
              grade = val;
              //  });
            },
            onSaved: (val) {
              grade = val;
            },
            flag: 1,
          )),
        ],
      ),
    );
  }
}

class ListItemGradeRateView<T extends ItemRateGradeModel>
    extends StatelessWidget {
  final T itemGradeRateModel;
  final ValueSetter<T> onClick;
  final ItemGradeRateViewModel viewModel;
  final List<ItemGradeRateSubModel> itemGradeRateModelListData;

  ListItemGradeRateView(
      {Key key,
      this.itemGradeRateModel,
      this.onClick,
      this.viewModel,
      this.itemGradeRateModelListData})
      : super(key: key);

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
            onPressed: () => onClick(itemGradeRateModel),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Name :",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(itemGradeRateModel?.item?.description ?? "",
                            style: theme.subhead1),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Grade:",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(itemGradeRateModel?.grade?.name ?? "",
                            style: theme.subhead1),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Code :",
                          style: theme.smallHint,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(itemGradeRateModel?.item?.code ?? "",
                            style: theme.subhead1),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rate:",
                          style: theme.smallHint,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                            BaseNumberFormat(number: itemGradeRateModel.rate)
                                .formatRate(),
                            style: theme.subhead1),
                      ],
                    ),
                  ],
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

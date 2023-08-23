import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';

class FiltersScreen extends StatefulWidget {
  final SalesEnquiryMisViewModel viewModel;

  const FiltersScreen({Key key, this.viewModel}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  BCCModel reportType;
  bool isAllBranch;
  BranchModel selectedBranch;

  @override
  void initState() {
    super.initState();
    reportType = widget.viewModel.selectedReport;
    isAllBranch = widget.viewModel.isAllBranch;
    selectedBranch = widget.viewModel.selectedBranch;
  }

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      child: Scaffold(
        appBar: BaseAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                textAlign: TextAlign.center,
                style: theme.title.copyWith(),
              ),
              Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.close),
                      ))),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: themeData.primaryColor,
              padding: const EdgeInsets.only(left: 8.0,bottom: 3),
              child: BaseDialogField<BCCModel>(
                isVector: true,
                initialValue: widget.viewModel.selectedReport,
                list: widget.viewModel.reportType,
                displayTitle: "Report Type",
                icon: Icons.receipt_outlined,
                listBuilder: (data, pos) {
                  return DocumentTypeTile(
                      icon: Icons.receipt_outlined,
                      title: "${data.description}",
                      // subTitle: "Tap to select report type",
                      selected: data.id == reportType.id,
                      isVector: true,
                      onPressed: () => Navigator.pop(context, data));
                },
                fieldBuilder: (selected) => Text(
                  "${selected.description}",
                  style: theme.subhead2,
                ),
                onChanged: (selected) => setState(() => reportType = selected),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Branches",
                      style: theme.title.copyWith(),
                    ),
                  ),
                  CupertinoSwitch(
                    value: isAllBranch,
                    onChanged: (val) => setState(() => isAllBranch = val),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: kThemeAnimationDuration,
                child: (!isAllBranch)
                    ? ListView.builder(
                        itemCount: widget.viewModel.branches?.length ?? 0,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(12),
                        itemBuilder: (con, pos) {
                          var branch = widget.viewModel.branches[pos];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              onTap: () =>
                                  setState(() => selectedBranch = branch),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "${branch.name}",
                                        // style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      activeColor: Colors.grey.withOpacity(0.6),
                                      onChanged: (bool value) {
                                        if (value)
                                          setState(
                                              () => selectedBranch = branch);
                                        else
                                          setState(() => selectedBranch = null);
                                      },
                                      value: selectedBranch?.id == branch.id,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox.expand(),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: themeData.primaryColorDark,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (!isAllBranch) isAllBranch = selectedBranch == null;
                      widget.viewModel.onChangeFilters(
                        reportType,
                        isAllBranch,
                        selectedBranch,
                      );
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAppPosition(int index) {}
}

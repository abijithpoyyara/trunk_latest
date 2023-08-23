import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:redstars/src/services/model/response/lookups/analysis_code_user_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/analysis_code_user_lookup_repository.dart';
import 'package:redstars/utility.dart';

Future<AnalysisCodeModelItem> analysisCodeUserDialog({
  String title,
  @required BuildContext context,
  @required String procName,
  @required String actionFlag}) =>
    showDialog<AnalysisCodeModelItem>(
      context: context,
      builder: (_) => AnalysisCodeLookupBody(
        title:title, procName:procName, actionFlag:actionFlag
      )
);

class AnalysisCodeLookupBody extends BaseLookupBody {
  final String title;
  final String procName;
  final String actionFlag;

  AnalysisCodeLookupBody({this.title, this.actionFlag, this.procName});

 @override
 _AnalysisCodeLookupBodyState createState() => _AnalysisCodeLookupBodyState();
}

class _AnalysisCodeLookupBodyState extends BaseLookupBodyState<AnalysisCodeLookupBody, AnalysisCodeModelItem>{

  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await AnalysisCodeLookupRepository().fetchData(
        procedure: widget.procName,
        actionFlag: widget.actionFlag,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start ?? 0,
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems,
            searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords));
  }

  @override
  Widget buildListItem(AnalysisCodeModelItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.itemBox,
            title: document.name,
            color: ThemeProvider.of(context).primaryColorDark,
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}
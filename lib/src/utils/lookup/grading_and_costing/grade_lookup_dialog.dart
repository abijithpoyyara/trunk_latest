import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/grading_and_costing/grade_lookup_repository.dart';

Future<GradeLookupItem> gradeLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<GradeLookupItem>(
      context: context,
      builder: (_) => GradeLookupBody(title: title, flag: flag),
    );

class GradeLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  GradeLookupBody({this.title, this.flag});

  @override
  _GradeLookupBodyState createState() => _GradeLookupBodyState();
}

class _GradeLookupBodyState
    extends BaseLookupBodyState<GradeLookupBody, GradeLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await GradeLookupRepository().fetchData(
        flag: widget.flag,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start ?? 0,
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems, searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords));
  }

  @override
  Widget buildListItem(GradeLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            //icon: Icons.info_outline,
            vector: AppVectors.requestFrom,
            title: BaseStringCase(document.name).titleCase,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

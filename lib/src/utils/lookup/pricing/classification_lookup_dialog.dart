import 'package:base/res/values/base_colors.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/pricing/classification_lookup_repository.dart';

Future<ItemGroupLookupItem> classificationLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<ItemGroupLookupItem>(
      context: context,
      builder: (_) => ClassificationLookupBody(title: title, flag: flag),
    );

class ClassificationLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  ClassificationLookupBody({this.title, this.flag});

  @override
  _ClassificationLookupBodyState createState() =>
      _ClassificationLookupBodyState();
}

class _ClassificationLookupBodyState
    extends BaseLookupBodyState<ClassificationLookupBody, ItemGroupLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await ClassificationLookUpRepository().fetchData(
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
  Widget buildListItem(ItemGroupLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.info,
            icon: Icons.info_outline,
            title: document.description,
            color: BaseColors.of(context).selectedColor.withOpacity(.6),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

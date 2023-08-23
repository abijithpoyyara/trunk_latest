import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/item_lookup_repository.dart';

Future<ItemLookupItem> itemLookupDialog(
        {String title,
        @required BuildContext context,
        @required String procName,
        @required String actionFlag}) =>
    showDialog<ItemLookupItem>(
      context: context,
      builder: (_) => ItemLookupBody(
          title: title, procName: procName, actionFlag: actionFlag),
    );

class ItemLookupBody extends BaseLookupBody {
  final String title;
  final String procName;
  final String actionFlag;

  ItemLookupBody({this.title, this.procName, this.actionFlag});

  @override
  _ItemLookupBodyState createState() => _ItemLookupBodyState();
}

class _ItemLookupBodyState
    extends BaseLookupBodyState<ItemLookupBody, ItemLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await ItemLookupRepository().fetchData(
        procedure: widget.procName,
        actionFlag: widget.actionFlag,
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
  Widget buildListItem(ItemLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.itemBox,
            title: document.description,
            color: ThemeProvider.of(context).primaryColorDark,
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

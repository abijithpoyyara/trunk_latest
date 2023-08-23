import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/trans_type_lookup_repository.dart';

Future<TransTypeLookupItem> transTypeLookupDialog(
        {String title,
        @required BuildContext context,
        @required String flag}) =>
    showDialog<TransTypeLookupItem>(
      context: context,
      builder: (_) => TransTypeLookupBody(title: title, flag: flag),
    );

class TransTypeLookupBody extends BaseLookupBody {
  final String title;
  final String flag;

  TransTypeLookupBody({this.title, this.flag});

  @override
  _TransTypeLookupBodyState createState() => _TransTypeLookupBodyState();
}

class _TransTypeLookupBodyState
    extends BaseLookupBodyState<TransTypeLookupBody, TransTypeLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await TransTypeLookupRepository().fetchData(
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
  Widget buildListItem(TransTypeLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.transaction,
            icon: Icons.info_outline,
            title: document.purchaseorderno,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.suppliername,
            onPressed: () => Navigator.pop(context, document)));
  }
}

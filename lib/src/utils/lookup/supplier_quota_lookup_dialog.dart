import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/services/repository/lookup/supplier_quota_lookup_repository.dart';
import 'package:redstars/src/utils/lookup/po_ack_supplier_lookup_dialog.dart';

import '../../../utility.dart';

Future<SupplierQuotaItem> supplierQuotaDialog(
    {String title,
      @required BuildContext context,
      @required String procName,
      @required String actionFlag}) =>
    showDialog<SupplierQuotaItem>(
      context: context,
      builder: (_) => SupplierLookupBody(
          title: title, procName: procName, actionFlag: actionFlag),
    );

class SupplierLookupBody extends BaseLookupBody {
  final String title;
  final String procName;
  final String actionFlag;

  SupplierLookupBody({this.title, this.procName, this.actionFlag});

  @override
  _SupplierLookupBodyState createState() => _SupplierLookupBodyState();
}

class _SupplierLookupBodyState
    extends BaseLookupBodyState<SupplierLookupBody, SupplierQuotaItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await SupplierQuotaItemLookupRepository().fetchData(
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
  Widget buildListItem(SupplierQuotaItem document) {
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
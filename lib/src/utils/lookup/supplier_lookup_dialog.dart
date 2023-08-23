import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/supplier_lookup_repository.dart';

Future<SupplierLookupItem> supplierLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<SupplierLookupItem>(
      context: context,
      builder: (_) => SupplierLookupBody(title: title, flag: flag),
    );

class SupplierLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  SupplierLookupBody({this.title, this.flag});

  @override
  _SupplierLookupBodyState createState() => _SupplierLookupBodyState();
}

class _SupplierLookupBodyState
    extends BaseLookupBodyState<SupplierLookupBody, SupplierLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await SupplierLookupRepository().fetchData(
        flag: widget.flag,
        eor_Id: initLoad ?? true ? null : eor_id,
        sor_Id: initLoad ?? true ? null : sor_id,
        totalRecords: initLoad ?? true ? null : totalRecords,
        start: searchQuery.isEmpty ? start : 0,
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems, searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords));
  }

  @override
  Widget buildListItem(SupplierLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            isVector: true,
            icon: Icons.info_outline,
            vector: AppVectors.addnew,
            title: BaseStringCase(document.name).titleCase,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

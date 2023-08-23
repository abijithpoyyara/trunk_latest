import 'package:flutter/material.dart';
import 'package:base/utility.dart';
import 'package:base/resources.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/services/repository/lookup/po_ack_supplier_lookup_repository.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';
import 'package:base/widgets.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';

Future<POAckSupplierLookupItem> poAckSupplierLookupDialog(
    {String title, @required BuildContext context}) =>
    showDialog<POAckSupplierLookupItem>(
      context: context,
      builder: (_) => SupplierLookupBody(title: title),
    );

class SupplierLookupBody extends BaseLookupBody {
  final String title;

  SupplierLookupBody({this.title});

  @override
  _SupplierLookupBodyState createState() => _SupplierLookupBodyState();
}

class _SupplierLookupBodyState
    extends BaseLookupBodyState<SupplierLookupBody, POAckSupplierLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await POAckSupplierLookupRepository().fetchData(
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems, searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords)
    );
  }

  @override
  Widget buildListItem(POAckSupplierLookupItem document) {
    return Container(
        child: DocumentTypeTile(
          //icon: Icons.info_outline,
            vector: AppVectors.requestFrom,
            title: BaseStringCase(document.name).titleCase,
            color:ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}



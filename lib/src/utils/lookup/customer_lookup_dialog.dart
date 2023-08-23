import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/customer_repository.dart';

Future<Customer> customerLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<Customer>(
      context: context,
      builder: (_) => CustomerLookupBody(title: title, flag: flag),
    );

class CustomerLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  CustomerLookupBody({this.title, this.flag});

  @override
  _CustomerLookupBodyState createState() => _CustomerLookupBodyState();
}

class _CustomerLookupBodyState
    extends BaseLookupBodyState<CustomerLookupBody, Customer> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await CustomerLookupRepository().fetchData(
        // flag: widget.flag,
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
  Widget buildListItem(Customer document) {
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

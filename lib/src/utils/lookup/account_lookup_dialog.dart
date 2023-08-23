import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/account_lookup_repository.dart';

Future<AccountLookupItem> accountLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<AccountLookupItem>(
      context: context,
      builder: (_) => AccountLookupBody(title: title, flag: flag),
    );

class AccountLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  AccountLookupBody({this.title, this.flag});

  @override
  _AccountLookupBodyState createState() => _AccountLookupBodyState();
}

class _AccountLookupBodyState
    extends BaseLookupBodyState<AccountLookupBody, AccountLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await AccountLookupRepository().fetchData(
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
  Widget buildListItem(AccountLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.info,
            icon: Icons.info_outline,
            title: document.description,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

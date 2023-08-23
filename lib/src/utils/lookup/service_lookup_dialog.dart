import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/service_lookup_repository.dart';

Future<ServiceLookupItem> serviceLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<ServiceLookupItem>(
      context: context,
      builder: (_) => ServiceLookupBody(title: title, flag: flag),
    );

class ServiceLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  ServiceLookupBody({this.title, this.flag});

  @override
  _ServiceLookupBodyState createState() => _ServiceLookupBodyState();
}

class _ServiceLookupBodyState
    extends BaseLookupBodyState<ServiceLookupBody, ServiceLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await ServiceLookupRepository().fetchData(
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
  Widget buildListItem(ServiceLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            vector: AppVectors.requestFrom,
            title: document.name,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle: document.code,
            onPressed: () => Navigator.pop(context, document)));
  }
}

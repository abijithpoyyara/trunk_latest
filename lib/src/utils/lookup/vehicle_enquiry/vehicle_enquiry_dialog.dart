import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';
import 'package:redstars/src/services/repository/lookup/vehicle_enquiry_lookup_repository.dart';

Future<VehicleFilterDetailListLookupItem> vehicleEnquiryLookupDialog(
        {String title, @required BuildContext context, @required int flag}) =>
    showDialog<VehicleFilterDetailListLookupItem>(
      context: context,
      builder: (_) => VehicleEnquiryLookupBody(title: title, flag: flag),
    );

class VehicleEnquiryLookupBody extends BaseLookupBody {
  final String title;
  final int flag;

  VehicleEnquiryLookupBody({this.title, this.flag});

  @override
  _VehicleEnquiryLookupBodyState createState() =>
      _VehicleEnquiryLookupBodyState();
}

class _VehicleEnquiryLookupBodyState extends BaseLookupBodyState<
    VehicleEnquiryLookupBody, VehicleFilterDetailListLookupItem> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await VehicleEnquiryLookupRepository().fetchData(
        flag: widget.flag,
        eor_Id: initLoad ?? true ? null : eor_id,
        sor_Id: initLoad ?? true ? null : sor_id,
        totalRecords: initLoad ?? true ? null : totalRecords,
        start: searchQuery.isEmpty ? start : 0,
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) {
          if (mounted)
            onRequestSuccess(lookupModel.lookupItems, searchQuery,
                sorId: lookupModel.SOR_Id,
                eorId: lookupModel.EOR_Id,
                totalRecords: lookupModel.totalRecords);
        });
  }

  @override
  Widget buildListItem(VehicleFilterDetailListLookupItem document) {
    return Container(
        child: DocumentTypeTile(
            isVector: false,
            icon: Icons.agriculture_outlined,
            vector: AppVectors.addnew,
            title: document.chassisno,
            color: ThemeProvider.of(context).primaryColorDark.withOpacity(.70),
            selected: true,
            subTitle:
                (document?.engineno ?? "") + "\n" + (document?.modelname ?? ""),
            onPressed: () => Navigator.pop(context, document)));
  }
}

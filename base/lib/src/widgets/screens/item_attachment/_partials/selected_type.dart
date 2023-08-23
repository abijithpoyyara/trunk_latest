import 'package:base/resources.dart';
import 'package:base/src/redux/viewmodels/scan_viewmodel.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

class DocumentType extends StatelessWidget {
  DocumentType({
    Key key,
    @required this.height,
    this.viewModel,
  }) : super(key: key);

  final double height;
  final ScanViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);

    return Container(
        height: height,
        decoration: BoxDecoration(border: Border(bottom: BaseBorderSide())),
//        child: DocumentTypeTile(
//            color: colors.accentColor,
//            icon: viewModel.selectedType != null
//                ? Icons.description
//                : Icons.insert_drive_file,
//            title: viewModel.selectedType != null
//                ? viewModel.selectedType.documentName
//                : "Document Type",
//            subTitle: viewModel.selectedType != null
//                ? viewModel.selectedType.documentName
//                : "Tap to select document type",
//            selected: true,
//            onPressed: () => viewModel.onDocumentTypeClick())
    );
  }
}

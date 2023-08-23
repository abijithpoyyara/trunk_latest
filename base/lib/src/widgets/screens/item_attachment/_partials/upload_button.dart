import 'package:base/resources.dart';
import 'package:base/src/redux/viewmodels/scan_viewmodel.dart';
import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key key,
    @required this.height,
    @required this.viewModel,
  }) : super(key: key);

  final double height;
  final ScanViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        child: MaterialButton(
            onPressed: () {},
            child: Text('Save & Upload'),
            shape: ContinuousRectangleBorder(),
            color: BaseColors.of(context).primaryColor,
            textColor: Colors.white));
  }
}

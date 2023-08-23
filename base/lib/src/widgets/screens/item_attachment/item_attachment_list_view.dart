import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/src/redux/actions/scan_actions.dart';
import 'package:base/src/redux/viewmodels/scan_viewmodel.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'item_attachment_view.dart';

const double _kUploadButtonHeight = 50.0;
const double _kDocumentTypeHeight = 65.0;

class ItemAttachmentView<T extends BaseAppState, U extends ScanViewModel>
    extends StatelessWidget {
  final String title;
  final Function(ItemAttachmentModel) onItemAdded;

  const ItemAttachmentView({Key key, this.title, this.onItemAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<T, ScanViewModel>(
        init: (store, context) => store.dispatch(fetchScannerConfigs()),
        appBar: BaseAppBar(title: Text(title ?? "Document Attachment")),
        builder: (con, viewModel) {
          bool isEmpty = viewModel.scannedDocuments?.isNotEmpty ?? false;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (isEmpty)
                Container(
                  color: themeData.scaffoldBackgroundColor,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: viewModel.scannedDocuments?.length ?? 0,
                      itemBuilder: (context, position) {
                        ItemAttachmentModel attachment =
                            viewModel.scannedDocuments[position];
                        return DocumentTypeTile(
                            leading: Text(
                              '${position + 1}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            title: '${attachment.docNo}',
                            onPressed: () {
//                                viewModel.onAttachmentEdit(attachment);
                              Navigator.push(
                                  context,
                                  BaseNavigate.fadeIn(
                                      DocumentScanner<T, ScanViewModel>(
                                          title: viewModel
                                              .selectedOption.mappingname,
                                          selectedItem: attachment)));
                            },
                            subTitle: '${attachment.documentType.documentName}',
                            isVector: true,
                            selected: true,
                            trailing:
                                '${BaseDates(attachment.docDate).format}');
                      }),
                )
              else
                _EmptyView(),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                      backgroundColor: ThemeProvider.of(context).accentColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            BaseNavigate.fadeIn(
                              DocumentScanner<T, ScanViewModel>(
                                title: viewModel.selectedOption?.mappingname ??
                                    "Document Scanner",
                              ),
                            ));
                      },
                      autofocus: true,
                      child: Icon(
                        Icons.add,
                        color: ThemeProvider.of(context).primaryColorDark,
                      )))
            ],
          );
        },
        onDidChange: (ScanViewModel viewModel, context) {},
        converter: (store) => ScanViewModel.fromStore(store));
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SvgPicture.asset(BaseVectors.attachmentEmpty),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}

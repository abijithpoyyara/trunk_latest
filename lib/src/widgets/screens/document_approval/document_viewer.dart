import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/document_viewer_viewmodel.dart';
import 'package:redux/src/store.dart';

class DocumentViewer extends StatelessWidget
    with BaseViewMixin<AppState, DocumentApprViewerViewModel> {
  final String transactionNo;
  final DocumentApprViewerViewModel viewModel;

  const DocumentViewer({Key key, this.transactionNo, this.viewModel})
      : super(key: key);
  @override
  BaseAppBar appBarBuilder(
    String title,
    BuildContext context,
  ) {
    return BaseAppBar(
      title: Text("$transactionNo"),
      actions: [
        // if (webViewKey != null)
        //   IconButton(
        //       onPressed: () {
        //         webViewKey.currentState?.reloadWebView();
        //       },
        //       icon: Icon(Icons.refresh))
      ],
    );
    // super.appBarBuilder(, context,);
  }

  @override
  void init(Store<AppState> store, BuildContext context) {
    store.dispatch(InitFilePathAction(
        hasTokenCallback: (path) =>
            store.dispatch(SetFilePathAction(filePath: path))));

    super.init(store, context);
  }

  @override
  Widget childBuilder(
      BuildContext context, DocumentApprViewerViewModel viewModel) {
    return DocumentViewerList(
      transactionNo: transactionNo,
      filePath: viewModel.filePath,
      documents: viewModel.attachments
          .map((attachments) => DocumentViewerModel(
              title: attachments.documentName,
              files: attachments.files
                  .map((file) => FileDetails(
                      originalfilename: file.originalName,
                      filename: file.physicalName,
                      fileextension: file.physicalName.split(".").last))
                  .toList()))
          .toList(),
    );
  }

  @override
  DocumentApprViewerViewModel converter(Store store) =>
      DocumentApprViewerViewModel.fromStore(store);
}

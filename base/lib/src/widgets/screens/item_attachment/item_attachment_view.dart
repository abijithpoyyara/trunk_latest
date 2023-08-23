import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/src/redux/viewmodels/scan_viewmodel.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/utils/base_child_dialog.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:base/src/widgets/screens/item_attachment/_partials/selected_type.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '_partials/scanned_images.dart';
import '_views/document_type_dialog.dart';

class DocumentScanner<T extends BaseAppState, U extends ScanViewModel>
    extends StatelessWidget {
  final String title;
  final ItemAttachmentModel selectedItem;
  final Function(ItemAttachmentModel) onAdded;
  final ScanViewModel viewModel;

  const DocumentScanner(
      {Key key, this.title, this.selectedItem, this.onAdded, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<T, U>(
        builder: (con, viewModel) {
          return ItemAttachmentBody(
              viewModel: viewModel,
              title: title,
              selectedItem: selectedItem,
              onAdded: (model) {
                viewModel.onAddNewAttachment(model);
                Navigator.pop(context);
              });
        },
        onDidChange: (ScanViewModel viewModel, context) {},
        converter: (store) => ScanViewModel.fromStore(store));
  }
}

class ItemAttachmentBody extends StatefulWidget {
  final ScanViewModel viewModel;
  final Function(ItemAttachmentModel) onAdded;
  final ItemAttachmentModel selectedItem;
  final String title;

  const ItemAttachmentBody({
    Key key,
    this.viewModel,
    this.onAdded,
    this.selectedItem,
    this.title,
  }) : super(key: key);

  @override
  _ItemAttachmentBodyState createState() => _ItemAttachmentBodyState();
}

class _ItemAttachmentBodyState extends State<ItemAttachmentBody> {
  GlobalKey<_DocumentTypeViewState> _docTypeKey = GlobalKey();
  GlobalKey<DocumentItemsGridState> _gridKey = GlobalKey();
  GlobalKey<__EntryFormState> _formKey = GlobalKey();
  List<String> attachments;
  ItemAttachmentModel selected;

  @override
  void initState() {
    super.initState();
    if (widget.selectedItem != null) {
      attachments = widget.selectedItem.scannedDocuments;
      selected = widget.selectedItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Scaffold(
      appBar: BaseAppBar(
        title: Text(widget.title ?? "Document Attachment"),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                onAddNewDoc();
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.viewModel.documentTypes.isNotEmpty)
            _DocumentTypeView(
              selectedModel: selected,
              key: _docTypeKey,
              documentTypes: widget.viewModel.documentTypes,
              createdList: widget.viewModel.scannedDocuments,
            ),
          _EntryForm(
            key: _formKey,
            docNo: selected?.docNo,
            date: selected?.docDate,
          ),
          Expanded(
            child: Container(
                color: themeData.primaryColor,
                child: SingleChildScrollView(
                    child: DocumentItemsGrid(
                  key: _gridKey,
                  scannedDocuments: attachments,
                ))),
          ),
        ],
      ),
    );
  }

  onAddNewDoc() {
    List<String> attachments = _gridKey.currentState.scannedDocuments;
    ItemAttachmentModel model = _docTypeKey.currentState.onSubmit();
    ItemAttachmentModel model2 = _formKey.currentState.onSave();

    if (model2 != null) {
      model.docNo = model2.docNo;
      model.docDate = model2.docDate;
      model.scannedDocuments = attachments;
      widget.onAdded(model);
    }
//
  }
}

class _DocumentTypeView extends StatefulWidget {
  final List<DocumentTypes> documentTypes;
  final List<ItemAttachmentModel> createdList;
  final ItemAttachmentModel selectedModel;

  const _DocumentTypeView(
      {Key key, this.documentTypes, this.createdList, this.selectedModel})
      : super(key: key);

  @override
  _DocumentTypeViewState createState() => _DocumentTypeViewState();
}

class _DocumentTypeViewState extends State<_DocumentTypeView> {
  DocumentTypes selectedDocType;
  DocumentTypes selectedMainDocType;
  List<ItemAttachmentModel> createdDocList;
  ItemAttachmentModel mainDoc;

  @override
  void initState() {
    super.initState();
    selectedDocType = widget.selectedModel?.documentType ??
        widget.documentTypes?.firstWhere((type) => !type.isLeaf,
            orElse: () => widget.documentTypes?.first);

    mainDoc = widget.selectedModel?.mainDoc;
    selectedMainDocType = widget.selectedModel?.mainDocType ??
        (selectedDocType.isLeaf
            ? widget.documentTypes?.firstWhere(
                (e) => e.id == selectedDocType.parentDocumentId,
                orElse: () => null)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: themeData.scaffoldBackgroundColor,
      child: Container(
          margin: EdgeInsets.only(left: width * .08, right: width * .05),
          decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              border: Border(
                  bottom:
                      BorderSide(color: theme.colors.white.withOpacity(.70)))),
          child: IntrinsicHeight(
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: buildTile("Document Name", selectedDocType?.documentName,
                    () {
              baseShowChildDialog<DocumentType>(
                  context: context,
                  child: DocumentTypeList(
                    documentTypes: widget.documentTypes,
                    onPressed: (type) {
                      var mainDocType = type.parentDocumentId != null
                          ? widget.documentTypes?.firstWhere(
                              (e) => e.documentId == type.parentDocumentId,
                              orElse: () => null)
                          : null;
                      setState(() {
                        selectedDocType = type;
                        selectedMainDocType = mainDocType;
                      });
                    },
                  ));
            })),
            if (selectedMainDocType != null)
              Expanded(
                  child: AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      duration: kThemeAnimationDuration,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(selectedMainDocType.documentName,
                                style: theme.body),
                            SizedBox(height: 4),
                            BaseDropDownField<ItemAttachmentModel>(
                                onChanged: (model) {
                                  setState(() {
                                    mainDoc = model;
                                  });
                                },
                                initialValue: mainDoc,
                                hint: "Main doc No",
                                items: widget.createdList
                                    .where((item) =>
                                        item.documentType.id ==
                                        selectedMainDocType.id)
                                    .toList(),
                                builder: (model) {
                                  return Text(model.docNo);
                                })
                          ])))
          ]))),
    );
  }

  Widget buildTile(String title, String subTitle, VoidCallback onPressed) {
    BaseTheme theme = BaseTheme.of(context);
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      duration: kThemeAnimationDuration,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: theme.body),
            Padding(
              padding: const EdgeInsets.only(left: 1.0, top: 6),
              child: Text(
                subTitle,
                style: theme.subhead1Bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ItemAttachmentModel onSubmit() {
    ItemAttachmentModel model = ItemAttachmentModel(
        mainDocType: selectedMainDocType,
        documentType: selectedDocType,
        mainDoc: mainDoc);
    return model;
  }
}

class _EntryForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String docNo;
  final DateTime date;

  const _EntryForm({
    Key key,
    this.docNo,
    this.date,
    this.formKey,
  }) : super(key: key);

  @override
  __EntryFormState createState() => __EntryFormState();
}

class __EntryFormState extends State<_EntryForm> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String docNo;
  DateTime date;

  @override
  void initState() {
    super.initState();
    docNo = widget.docNo ?? "";
    date = widget.date ?? DateTime.now();
  }

  ItemAttachmentModel onSave() {
    FormState state = _key.currentState;
    if (state.validate()) {
      state.save();
      return ItemAttachmentModel(docDate: date, docNo: docNo);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(bottom: width * .06, right: 15),
      //margin: EdgeInsets.only(right: 8),
      color: themeData.scaffoldBackgroundColor,
      child: Form(
        key: _key,
        child: Row(
          children: <Widget>[
            Expanded(
              child: BaseTextField(
                isVector: true,
                displayTitle: "Doc No",
                validator: (val) =>
                    val?.isEmpty ?? true ? "Please enter Doc No" : null,
                initialValue: docNo,
                onSaved: (val) => setState(() => docNo = val),
              ),
            ),
            Expanded(
              child: BaseDatePicker(
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: theme.colors.white.withOpacity(.70),
                ),
                isVector: true,
                displayTitle: "Doc Date",
                validator: (val) => val == null ? "Select Doc Date" : null,
                initialValue: date,
                onSaved: (val) => setState(() => date = val),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

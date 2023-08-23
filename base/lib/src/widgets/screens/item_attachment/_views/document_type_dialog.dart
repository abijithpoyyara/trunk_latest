import 'package:base/resources.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

const double _kListTitleHeight = 55.0;

class DocumentTypeList extends StatelessWidget {
  const DocumentTypeList(
      {Key key,
      @required this.documentTypes,
      this.selectedType,
      this.onPressed})
      : super(key: key);
  final List<DocumentTypes> documentTypes;
  final DocumentTypes selectedType;
  final Function(DocumentTypes selectedDocumentType) onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = BaseTheme.of(context).title;
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        alignment: FractionalOffset.bottomRight,
       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Material(
            color: themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: _kListTitleHeight,
                      decoration: BoxDecoration(color: themeData.primaryColor),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                                flex: 7,
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text('Document Types ',
                                        style: textTheme,
                                        textAlign: TextAlign.start))),
                            Flexible(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(Icons.close),
                                    color: colors.white,
                                    iconSize: 22,
                                    onPressed: () => Navigator.pop(context)))
                          ])),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: documentTypes.length,
                          itemBuilder: (context, index) => _ListItem(
                              document: documentTypes[index],
                              selected: selectedType,
                              onPressed: (type) => onPressed(type))))
                ])));
  }
}

class _ListItem extends StatelessWidget {
  final DocumentTypes document;
  final Function(DocumentTypes) onPressed;
  final DocumentTypes selected;

  const _ListItem({Key key, this.document, this.selected, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(color: themeData.scaffoldBackgroundColor,
        child: DecoratedBox(
            decoration: BoxDecoration(color: themeData.scaffoldBackgroundColor,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: DocumentTypeTile(
                  vector:BaseVectors.documentType,
                    icon: Icons.description,
                    title: document.documentName,
                    color: themeData.primaryColorDark.withOpacity(.60),
                    subTitle: document.parentDoc,
                    selected: true || (selected?.id == document.id),
                    onPressed: () {
                      onPressed(document);
                      Navigator.of(context).pop();
                    }))));
  }
}

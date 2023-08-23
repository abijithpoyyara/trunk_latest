import 'package:base/res/values.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';

const double _kListTitleHeight = 55.0;

class DocumentTypeList extends StatelessWidget {
  const DocumentTypeList({
    Key key,
    @required this.documentTypes,
    this.selectedType,
  }) : super(key: key);
  final List<SupplierLookupItem> documentTypes;
  final SupplierLookupItem selectedType;

  @override
  Widget build(BuildContext context) {
    final textTheme = BaseTheme.of(context).title;

    return Container(
        alignment: FractionalOffset.bottomRight,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: _kListTitleHeight,
                      decoration: BoxDecoration(
                          color: BaseColors.of(context).greenColor),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                                flex: 7,
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text('Supplier ',
                                        style: textTheme,
                                        textAlign: TextAlign.start))),
                            Flexible(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(Icons.close),
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
                              onPressed: (type) =>
                                  Navigator.pop(context, type))))
                ])));
  }
}

class _ListItem extends StatelessWidget {
  final SupplierLookupItem document;
  final Function(SupplierLookupItem) onPressed;
  final SupplierLookupItem selected;

  const _ListItem({Key key, this.document, this.selected, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DecoratedBox(
            decoration: BoxDecoration(border: Border(bottom: BaseBorderSide())),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: DocumentTypeTile(
                    //icon: IconData(document.icon ?? 0xe24d,
                    // fontFamily: 'MaterialIcons'),
                    title: document.description,
                    // color: document.color != null
                    //     ? Color(document.color)
                    //     : kHintColor,
                    subTitle: document.code,
                    selected: (selected?.id == document.id),
                    onPressed: () => onPressed(document)))));
  }
}

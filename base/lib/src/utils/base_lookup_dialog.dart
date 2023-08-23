import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

Future<LookupItems> baseLookupDialog(
        {String title,
        @required BuildContext context,
        @required String procName,
        @required String actionFlag}) =>
    showDialog<LookupItems>(
      context: context,
      builder: (_) => BaseLookupBody(
          title: title, procName: procName, actionFlag: actionFlag),
    );

class BaseLookupBody extends StatefulWidget {
  final String title;
  final String procName;
  final String actionFlag;

  const BaseLookupBody(
      {Key key,
      this.title = "Lookup",
      @required this.procName,
      @required this.actionFlag})
      : super(key: key);

  @override
  BaseLookupBodyState createState() => BaseLookupBodyState();
}

class BaseLookupBodyState<T extends BaseLookupBody, U extends LookupItems>
    extends State<T> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController editingController = TextEditingController();
  int sor_id, eor_id, totalRecords = 1, start;
  List<U> lookupList;
  String searchQuery;
  bool _isSearchShowing = true;
  bool _isLoading;
  int limit = 10;

  @override
  void initState() {
    lookupList = List();
    start = 0;
    _loadItems(initLoad: true);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoading) _loadItems(searchTxt: searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      color: BaseColors.of(context).secondaryDark,
      child: Padding(
          padding: const EdgeInsets.all(2),
          child: Material(
              color: BaseColors.of(context).secondaryDark,
              borderRadius: BorderRadius.circular(5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _isSearchShowing
                        ? buildSearchWidget()
                        : buildTitleWidget(context),
                    Expanded(child: _buildList(lookupList))
                  ]))),
    ));
  }

  Widget buildSearchWidget() {
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: BaseColors.of(context).secondaryColor,
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
          autofocus: true,
          cursorColor: themeData.accentColor,
          textInputAction: TextInputAction.search,
          controller: editingController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          onSubmitted: (value) {
            lookupList.clear();
            _loadItems(searchTxt: value, initLoad: true);
            _isLoading = true;
          },
          decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              labelText: widget.title,
              labelStyle: TextStyle(color: themeData.accentColor),
              hintText: "Search",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => {
                        lookupList.clear(),
                        setState(() => _isSearchShowing = false),
                        _loadItems(initLoad: true)
                      }),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))))),
    );
  }

  Widget buildTitleWidget(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).title;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: BaseColors.of(context).primaryColor,
        ),
        child: Row(children: <Widget>[
          Expanded(
              flex: 5,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(widget.title, style: textTitleTheme))),
          IconButton(
              icon: Icon(
                Icons.search,
                color: BaseColors.of(context).white,
              ),
              iconSize: 22,
              onPressed: () => setState(() => _isSearchShowing = true)),
          IconButton(
              icon: Icon(
                Icons.close,
                color: BaseColors.of(context).white,
              ),
              iconSize: 22,
              onPressed: () => Navigator.pop(context))
        ]));
  }

  Widget _buildList(List<U> lookupItems) {
    return lookupItems.length > 0
        ? ListView.builder(
            shrinkWrap: false,
            controller: _scrollController,
            itemCount:
                _isLoading ? lookupItems.length + 1 ?? 0 : lookupItems.length,
            itemBuilder: (context, index) =>
                (_isLoading && index == lookupItems.length)
                    ? Padding(
                        padding: EdgeInsets.all(8), child: BaseLoadingSpinner())
                    : buildListItem(lookupItems[index]))
        : Center(child: Text("No List to Show"));
  }

  Widget buildListItem(U document) {
    return Container(
        child: DecoratedBox(
            decoration: BoxDecoration(),
            child: Padding(
                padding: EdgeInsets.zero,
                child: DocumentTypeTile(
                    vector: BaseVectors.themeSettings,
                    icon: Icons.wysiwyg,
                    title: document.description,
                    color: BaseColors.of(context).selectedColor,
                    selected: true,
                    subTitle: document.code,
                    onPressed: () => Navigator.pop(context, document)))));
  }

  _loadItems({bool initLoad = false, String searchTxt = ""}) async {
    setState(() {
      searchQuery = searchTxt;
      _isLoading = true;
      start = initLoad ? 0 : start ?? 0;
    });
    await fetchData(initLoad: initLoad, searchQuery: searchQuery);
  }

  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await LookupRepository().fetchData(
        procedure: widget.procName,
        actionFlag: widget.actionFlag,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start,
        searchQuery: searchQuery,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems, searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords,
            limit: limit));
  }

  void onRequestSuccess(
    List<U> lookupItems,
    String searchQuery, {
    int sorId,
    int eorId,
    int totalRecords,
    int limit,
  }) {
    setState(() {
      _isLoading = false;
      if (searchQuery.isEmpty)
        lookupList = lookupItems;
      else
        lookupList.addAll(lookupItems);
      sor_id = sorId;
      eor_id = eorId;
      totalRecords = totalRecords;
      start += 10;
    });
  }
}

Future<T> genericLookupDialog<T>(
        {String title,
        @required BuildContext context,
        String url,
        @required Widget Function(T) listBuilder,
        List<Map<String, dynamic>> jssArr}) =>
    showDialog<T>(
      context: context,
      builder: (_) => GenericLookupBody(
          title: title, jssArr: jssArr, url: url, listBuilder: listBuilder),
    );

class GenericLookupBody<T extends LookupItems> extends BaseLookupBody {
  final String title;
  final List<Map<String, dynamic>> jssArr;
  final String url;
  final Widget Function(T) listBuilder;

  GenericLookupBody({
    @required this.listBuilder,
    this.title,
    this.url,
    this.jssArr,
  });

  @override
  _GenericLookupBodyState createState() => _GenericLookupBodyState();
}

class _GenericLookupBodyState<T extends LookupItems>
    extends BaseLookupBodyState<GenericLookupBody<T>, T> {
  @override
  Future fetchData({bool initLoad = false, String searchQuery = ""}) async {
    await GenericLookupRepository().fetchLookupData(
        url: widget.url,
        jssArr: widget.jssArr,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: searchQuery.isEmpty ? start : 0,
        onRequestFailure: (error) => {},
        onRequestSuccess: (lookupModel) => onRequestSuccess(
            lookupModel.lookupItems, searchQuery,
            sorId: lookupModel.SOR_Id,
            eorId: lookupModel.EOR_Id,
            totalRecords: lookupModel.totalRecords));
  }

  @override
  Widget buildListItem(T document) {
    return Container(
        child: DecoratedBox(
            decoration:
                const BoxDecoration(border: const Border(bottom: BorderSide())),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: widget.listBuilder(document))));
  }
}

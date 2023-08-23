import 'dart:ui';

import 'package:base/redux.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item_list_view.dart';

import 'grade_document.dart';

class DocumentSearchScreen extends StatelessWidget {
  final String title;

  const DocumentSearchScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, GradingCostingViewModel>(
        converter: (store) => GradingCostingViewModel.fromStore(store),
        init: (store, context) {
          store.dispatch(InitFilePathAction(
              hasTokenCallback: (path) =>
                  store.dispatch(SetFilePathAction(filePath: path))));
          store.dispatch(fetchDocumentTypes());
          // store.dispatch(fetchDocumentsSearchKeywords());
        },
        appBar: BaseAppBar(
          title: Text(title ?? "Document Search"),
          elevation: 0.5,
        ),
        builder: (context, viewModel) =>
            DocumentSearchBody(viewModel: viewModel),
        onDispose: (store) {
          store.dispatch(OnClearAction("DocumentSearch"));
        });
  }
}

class DocumentSearchBody extends StatefulWidget {
  final GradingCostingViewModel viewModel;

  const DocumentSearchBody({Key key, this.viewModel}) : super(key: key);

  @override
  _DocumentSearchBodyState createState() => _DocumentSearchBodyState();
}

class _DocumentSearchBodyState extends State<DocumentSearchBody>
    with TickerProviderStateMixin {
  AnimationController animationController;
  ScrollController _scrollController;
  bool _showScrollTop;

  @override
  void initState() {
    super.initState();
    _showScrollTop = false;
    _scrollController = ScrollController();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _scrollController.addListener(() {});
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels !=
                    scrollNotification.metrics.minScrollExtent) {
              setState(() => _showScrollTop = true);
            } else if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.minScrollExtent)
              setState(() => _showScrollTop = false);

            return null;
          },
          child: RefreshIndicator(
            onRefresh: () {
              // widget.viewModel.refreshData();
              return Future.delayed(Duration(seconds: 30));
            },
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                      return Container(
                          color: BaseColors.of(context).secondaryColor,
                          child: Column(children: <Widget>[
                            _SearchWidget(
                              searchQuery: widget.viewModel.searchQuery,
                              onQuery: (searchQuery) {
                                // widget.viewModel.refreshData(
                                //   from: widget.viewModel.fromDate,
                                //   to: widget.viewModel.toDate,
                                //   searchKey: searchQuery,
                                //   selectedDocumentType:
                                //   widget.viewModel.selectedDocumentType,
                                // );
                              },
                            ),
                            _FilterWidget(
                                startDate: widget.viewModel.fromDate,
                                endDate: widget.viewModel.toDate,
                                // documentTypes: widget.viewModel.documentTypes,
                                // selectedType:
                                // widget.viewModel.selectedDocumentType,
                                onFilter: (from, to, type) {
                                  // widget.viewModel.refreshData(
                                  //   from: from,
                                  //   to: to,
                                  //   searchKey: widget.viewModel.searchQuery,
                                  //   selectedDocumentType: type,
                                  // );
                                })
                          ]));
                    }, childCount: 1)),
                    SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: BasePersistentHeaderDelegate(
                            minExtent: 52,
                            maxExtent: 52,
                            builder: (context, isAtTop) =>
                                getFilterWidget(isAtTop)))
                  ];
                },
                body: Container(
                  color: Colors.green,
                )
                // Container(
                //     margin: EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(22),
                //             bottomRight: Radius.circular(22))),
                //     child: (widget.viewModel.documents?.isNotEmpty ?? false)
                //         ? CupertinoScrollbar(
                //             child: ListView.builder(
                //                 itemCount:
                //                     widget.viewModel.documents?.length ?? 0,
                //                 padding: const EdgeInsets.only(top: 8),
                //                 scrollDirection: Axis.vertical,
                //                 itemBuilder: (BuildContext context, int index) {
                //                   final document =
                //                       widget.viewModel.documents[index];
                //                   final int count = 5 > 10 ? 10 : 5;
                //                   final Animation<double> animation =
                //                       Tween<double>(begin: 0.0, end: 1.0)
                //                           .animate(CurvedAnimation(
                //                               parent: animationController,
                //                               curve: Interval(
                //                                   (1 / count) * index, 1.0,
                //                                   curve:
                //                                       Curves.fastOutSlowIn)));
                //                   animationController.forward();
                //                   return DocumentListView(
                //                       onShare: () {
                //                         widget.viewModel.downloadFiles(
                //                             document.filelist
                //                                 .map((file) =>
                //                                     widget.viewModel.filePath +
                //                                     file.filename)
                //                                 .toList(),
                //                             document.docno);
                //                       },
                //                       onTap: () {
                //                         BaseNavigate(
                //                             context,
                //                             DocumentSearchDetails(
                //                                 selectedItem: document));
                //                       },
                //                       filePath: widget.viewModel.filePath,
                //                       document: document,
                //                       animation: animation,
                //                       animationController: animationController);
                //                 }))
                //         : Builder(
                //             builder: (BuildContext context) => ListView(
                //                 padding: EdgeInsets.only(
                //                     top:
                //                         MediaQuery.of(context).size.height / 5),
                //                 children: <Widget>[
                //                   Icon(Icons.file_copy_outlined,
                //                       color: kHintColor.withOpacity(.5),
                //                       size: 64),
                //                   SizedBox(height: 14),
                //                   Padding(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 35),
                //                       child: Text(
                //                           "Search for ${widget.viewModel.searchKeywords} ...",
                //                           style: AppTheme.of(context)
                //                               .body2MediumHint,
                //                           softWrap: true,
                //                           textAlign: TextAlign.center))
                //                 ]),
                //           ))
                ),
          ),
        ),
        // Positioned(
        //     right: 15,
        //     bottom: 15,
        //     child: AnimatedOpacity(
        //         opacity: _showScrollTop ? 1 : 0,
        //         duration: kThemeAnimationDuration,
        //         child: FloatingActionButton(
        //             heroTag: "Scroll_to_top",
        //             backgroundColor: kPrimaryColor,
        //             onPressed: () {
        //               setState(() {
        //                 _showScrollTop = false;
        //               });
        //               _scrollController.animateTo(0,
        //                   duration: Duration(milliseconds: 300),
        //                   curve: Curves.bounceInOut);
        //             },
        //             child: Icon(Icons.arrow_upward_rounded),
        //             tooltip: "Scroll to top")))
      ],
    );
  }

  Widget getFilterWidget(bool isExpanded) {
    return Builder(builder: (BuildContext context) {
      BaseTheme style = BaseTheme.of(context);

      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: BaseColors.of(context).white,
          child: RichText(
              text: TextSpan(
                  text: "Showing results from ",
                  style: style.bodyHint,
                  children: [
                TextSpan(
                    text: BaseDates(widget.viewModel.fromDate, month: 'MMM')
                        .format,
                    style: style.body2Medium.copyWith(color: Colors.green)),
                TextSpan(text: " to ", style: style.bodyHint),
                TextSpan(
                    text:
                        BaseDates(widget.viewModel.toDate, month: 'MMM').format,
                    style: style.body2Medium.copyWith(color: Colors.green))
              ])));
      // : Container();
    });
  }
}

class _SearchWidget extends StatefulWidget {
  final String searchQuery;
  final ValueSetter<String> onQuery;

  const _SearchWidget({Key key, this.searchQuery, this.onQuery})
      : super(key: key);

  @override
  __SearchWidgetState createState() => __SearchWidgetState();
}

class __SearchWidgetState extends State<_SearchWidget> {
  bool isSearchEmpty;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery);
    isSearchEmpty = widget.searchQuery?.trim()?.isEmpty ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      BaseTheme theme = BaseTheme.of(context);
      return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: Container(
                        decoration: BoxDecoration(
                            color: theme.colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(38.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: theme.colors.white, blurRadius: 8.0)
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 22),
                            child: TextFormField(
                                controller: _textController,
                                onFieldSubmitted: widget.onQuery,
                                onChanged: (val) {
                                  setState(() => isSearchEmpty = val.isEmpty);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Tap to search',
                                    hintStyle: theme.body2MediumHint.copyWith(
                                        fontWeight: FontWeight.normal))))))),
            Container(
                decoration: BoxDecoration(
                    color: theme.colors.secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: theme.colors.secondaryColor.withOpacity(0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.onQuery(_textController.text.toString());
                          _textController.clear();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: AnimatedSwitcher(
                              duration: Duration(seconds: 5),
                              child: Icon(
                                // icon: AnimatedIcons.search_ellipsis,
                                isSearchEmpty
                                    ? Icons.search_outlined
                                    : Icons.search_outlined,
                                // progress: controller,
                                size: 20,
                                color: theme.colors.white,
                              ),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            )))))
          ]));
    });
  }
}

class _FilterWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime startDate, DateTime endDate, SupplierLookupItem type)
      onFilter;
  final SupplierLookupItem selectedType;
  final List<SupplierLookupItem> documentTypes;

  const _FilterWidget({
    Key key,
    @required this.startDate,
    @required this.endDate,
    this.onFilter,
    this.selectedType,
    this.documentTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      BaseTheme theme = BaseTheme.of(context);
      return Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 16),
          child: IntrinsicHeight(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            showDateFilterDialog(
                              context,
                              fromDate: startDate,
                              toDate: endDate,
                              //   onSubmit: (from, to) =>
                              // onFilter(from, to, selectedType),
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Choose Date',
                                        style: theme.subhead1Semi.copyWith(
                                            color:
                                                BaseColors.of(context).white)),
                                    const SizedBox(height: 8),
                                    Text(
                                        '${BaseDates(startDate, dd: "dd", month: "MMM", year: 'yy').format} - ${BaseDates(endDate, dd: "dd", month: "MMM", year: 'yy').format}',
                                        style: theme.body2Medium)
                                  ])))),
                  Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                          width: 1,
                          height: 42,
                          color: BaseColors.of(context).greenColor)),
                  Expanded(
                      child: InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            displayDocumentTypeDialog(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Supplier',
                                        style: theme.subhead1Semi.copyWith(
                                            color:
                                                BaseColors.of(context).white)),
                                    const SizedBox(height: 8),
                                    if (selectedType != null)
                                      DocumentTypeWidget(
                                        docName: selectedType.description,
                                        // icon:Icons.list,
                                        color: Colors.green,
                                      )
                                    else
                                      Text('Tap to select ',
                                          style: theme.body2MediumHint)
                                  ]))))
                ]),
          ));
    });
  }

  displayDocumentTypeDialog(BuildContext context) async {
    final documentType = await baseShowChildDialog<SupplierLookupItem>(
        context: context,
        barrierDismissible: true,
        child: DocumentTypeList(
          documentTypes: documentTypes,
          selectedType: selectedType,
        ));
    if (documentType != null) {
      onFilter(startDate, endDate, documentType);
    }
  }
}

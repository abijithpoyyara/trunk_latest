import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/po_khat/po_khat_viewmodel.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/repository/po_khat/po_khat_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/po_khat/po_khat_filter_screen.dart';
import 'package:redstars/src/widgets/screens/po_khat/po_khat_view_list_screen.dart';

import '../../../../utility.dart';

class KhatListScreen extends StatefulWidget {
  final PokhatViewModel pokhatViewModel;

  const KhatListScreen({Key key, this.pokhatViewModel}) : super(key: key);
  @override
  _KhatListScreenState createState() => _KhatListScreenState();
}

class _KhatListScreenState extends State<KhatListScreen> {
  ScrollController _scrollController;

  bool _isLoading;
  bool _isLoadingLess;
  int start = 0;
  int limit;
  List<POKhatPendingListModelList> pokhatPendingList;
  List<POKhatPendingListModelList> pokhatPendingList2;
  @override
  void initState() {
    super.initState();
    widget.pokhatViewModel.onCallSuppliers;
    pokhatPendingList = [];
    pokhatPendingList2 = [];
    start = 0;
    _isLoading = false;
    limit = 10;
    _loadItems(initLoad: true);
    _scrollController = ScrollController(
      initialScrollOffset: widget.pokhatViewModel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _scrollController.addListener(() {
      if (_scrollController?.position.pixels ==
          _scrollController?.position.maxScrollExtent) {
        if (!_isLoading) _loadItems();
      }
    });
  }

  _loadItems({bool initLoad = false}) async {
    print("initload called");
    setState(() {
      _isLoading = true;
      if (initLoad) start = 0;
    });
    await POKhatRepository().getPoKhatPendingList(
        optionId: widget.pokhatViewModel.optionId,
        pokhatFilter: FilterModel(
          fromDate: widget.pokhatViewModel.filterModel.fromDate,
          toDate: widget.pokhatViewModel.filterModel.toDate,
          loc: widget.pokhatViewModel.filterModel.loc,
          suppliers: widget.pokhatViewModel.filterModel.suppliers,
          reqNo: widget.pokhatViewModel.filterModel.reqNo,
        ),
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                pokhatPendingList = [];
                _isLoading = false;
                start = null;
              })
            },
        onRequestSuccess: (result) => setState(() {
              _isLoading = false;
              if (initLoad) {
                print("initLoad called");
                print("purchase----${pokhatPendingList.length}");
                pokhatPendingList2 = result.pokhatPendingList;
                pokhatPendingList = result.pokhatPendingList;
              } else {
                print("secd called");
                pokhatPendingList.addAll(result.pokhatPendingList);
                print("purchase----${result}");
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BaseView<AppState, PokhatViewModel>(
      converter: (store) => PokhatViewModel.fromStore(store),
      builder: (context, viewmodel) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Date filter",
              child: Icon(
                Icons.filter_list,
                color: themeData.primaryColorDark,
              ),
              onPressed: () {
                showDialog(
                  context,
                  widget.pokhatViewModel.filterModel,
                  widget.pokhatViewModel,
                );
              },
            ),
            appBar: BaseAppBar(
              title: Text("PO khat"),
            ),
            body: pokhatPendingList != null && pokhatPendingList.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _isLoading
                        ? pokhatPendingList.length + 1 ?? 0
                        : pokhatPendingList.length,
                    itemBuilder: (BuildContext context, int pos) =>
                        (_isLoading == true && pos == pokhatPendingList.length)
                            ? Padding(
                                padding: EdgeInsets.all(8),
                                child: BaseLoadingSpinner())
                            : GestureDetector(
                                onTap: () {
                                  viewmodel
                                      .onDetailCall(pokhatPendingList[pos]);

                                  BaseNavigate(
                                      context,
                                      POKhatViewListScreen(
                                        pokhatItem: pokhatPendingList[pos],
                                        apprvlStatus:
                                            pokhatPendingList[pos].apprvlstatus,
                                        purchaseorderno: pokhatPendingList[pos]
                                            .purchaseorderno,
                                      ));

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             POKhatViewListScreen(
                                  //               pokhatItem:
                                  //                   pokhatPendingList[pos],
                                  //               apprvlStatus:
                                  //                   pokhatPendingList[pos]
                                  //                       .apprvlstatus,
                                  //               purchaseorderno:
                                  //                   pokhatPendingList[pos]
                                  //                       .purchaseorderno,
                                  //             )));
//                                          .then((value) => viewmodel.clearresult());

                                  // KhatHeaderScreen(
                                  //   viewModel: widget.pokhatViewModel,
                                  //   apprvalStats:
                                  //       pokhatPendingList[pos].apprvlstatus,
                                  //)
//                                      );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(9),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      height: height * .15,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: themeData.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    pokhatPendingList[pos]
                                                            ?.purchaseorderno ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                Text(
                                                  pokhatPendingList[pos]
                                                          ?.purchaseorderdate ??
                                                      "",
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    pokhatPendingList[pos]
                                                            ?.supplier ??
                                                        "",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // if (!_isLoading)
                                    Positioned(
                                        right: width * .02,
                                        child: CircleAvatar(
                                            backgroundColor: pokhatPendingList[
                                                            pos]
                                                        ?.apprvlstatus ==
                                                    "Pending"
                                                ? Colors.yellow
                                                : pokhatPendingList[pos]
                                                            ?.apprvlstatus ==
                                                        "Rejected"
                                                    ? Colors.red
                                                    : pokhatPendingList[pos]
                                                                ?.apprvlstatus ==
                                                            "N/A"
                                                        ? Colors.transparent
                                                        : Colors.green,
                                            radius: 10,
                                            child: pokhatPendingList[pos]
                                                        ?.apprvlstatus ==
                                                    "Pending"
                                                ? Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.black,
                                                    size: 12,
                                                  )
                                                : pokhatPendingList[pos]
                                                            ?.apprvlstatus ==
                                                        "Rejected"
                                                    ? Icon(
                                                        Icons.clear,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )
                                                    : pokhatPendingList[pos]
                                                                ?.apprvlstatus ==
                                                            "N/A"
                                                        ? Icon(
                                                            Icons.check,
                                                            color: Colors
                                                                .transparent,
                                                            size: 12,
                                                          )
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 12,
                                                          ))),
                                  ],
                                ),
                              ))
                : Center(
                    child: Text("No list to show"),
                  ));
      },
      onDispose: (store) => store.dispatch(OnClearAction()),
    );
  }

  showDialog(
    BuildContext context,
    FilterModel model,
    PokhatViewModel viewModel,
  ) async {
    start = 0;

    FilterModel resultSet = await appShowChildDialog(
        context: context,
        child: POkhatFilterScreen(
          viewModel: viewModel,
          khatFilterModel: viewModel.filterModel,
        ));
    pokhatPendingList = [];
    viewModel.onUserFilterApply(resultSet, start, pokhatPendingList);
    viewModel.onCallSuppliers();
  }
}

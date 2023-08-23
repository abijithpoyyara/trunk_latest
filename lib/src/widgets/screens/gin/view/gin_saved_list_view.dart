import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_list_data.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/repository/gin/gin_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';
import 'package:redstars/src/widgets/screens/gin/view/gin_filter_dialog.dart';

import '../../../../../utility.dart';
import '../gin_detail_screen.dart';

class GINSavedViewListPage extends StatefulWidget {
  final GINViewModel viewmodel;

  const GINSavedViewListPage({
    Key key,
    this.viewmodel,
  }) : super(key: key);

  @override
  _GINSavedViewListPageState createState() => _GINSavedViewListPageState();
}

class _GINSavedViewListPageState extends State<GINSavedViewListPage> {
  int sor_id, eor_id, totalRecords = 1, limit, start;

  ScrollController _controller;
  bool _isLoading;

  List<GINViewListDataList> ginSavedDataList;
  List<GINViewListDataList> ginList;
  String st;
  // @override
  // void initState() {
  //   super.initState();
  //   ginSavedDataList = [];
  //   start = 0;
  //   _loadItems(initLoad: true);
  //   //  initLoad = false;
  //   _controller = ScrollController(
  //     initialScrollOffset: widget.viewmodel.scrollPosition ?? 0,
  //     keepScrollOffset: true,
  //   );
  //
  //   _isLoading = false;
  //   _controller.addListener(() {
  //     if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //       if (!_isLoading) _loadItems();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    ginSavedDataList = [];
    ginList = [];
    start = 0;
    _isLoading = false;
    limit = 10;
    _loadItems(initLoad: true);
    _controller = ScrollController(
      initialScrollOffset: widget.viewmodel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _controller.addListener(() {
      if (_controller?.position.pixels ==
          _controller?.position.maxScrollExtent) {
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
    await GINRepository().getGINSavedListView(
        ginFilter: widget.viewmodel.ginDtlFilter,
        optionId: widget.viewmodel.optionId,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
              setState(() {
                ginSavedDataList = [];
                _isLoading = false;
                eor_id = null;
                sor_id = null;
                totalRecords = null;
                start = null;
              })
            },
        onRequestSuccess: (result) => setState(() {
              _isLoading = false;
              if (initLoad) {
                print("initLoad called");
                print("purchase----${ginSavedDataList.length}");
                ginList = result.ginSavedViewList;
                ginSavedDataList = result.ginSavedViewList;
              } else {
                print("secd called");
                ginSavedDataList.addAll(result.ginSavedViewList);
                print("purchase----${result.ginSavedViewList}");
                // eor_id = result.SOR_Id;
                // sor_id = result.EOR_Id;
                // totalRecords = result.totalRecords;
                start += limit;
              }
            }));
  }
  // _loadItems({bool initLoad = false, String searchQuery = ""}) async {
  //   setState(() {
  //     _isLoading = true;
  //     if (initLoad) start = 0;
  //     start += 10;
  //   });
  //   var _scrollPosition = _controller.position.pixels;
  //   widget.viewmodel.onLoadMore(
  //       widget.viewmodel.model, start, _scrollPosition, ginSavedDataList);
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, GINViewModel>(
        // init: (store, context) {

        // final state = store.state.requisitionState.purchaseRequisitionState;
        // // store.dispatch(fetchUomData());
        // store.dispatch(fetchginSavedViewListData(
        //   start: 0,
        //   filterModel: PVFilterModel(
        //       fromDate: state.filterModel.fromDate,
        //       toDate: state.filterModel.toDate,
        //       reqNo: ""),
        // ));
        // },
        // onDidChange: (viewModel, context) {
        //   if (viewModel.detailPurchaseModelData != null) Navigator.pop(context);
        // },
        converter: (store) => GINViewModel.fromStore(store),
        builder: (context, viewModel) {
          loadingWidget() {
            if (ginSavedDataList.isNotEmpty) {
              return BaseLoadingView(
                message: "Loading",
              );
            } else if (ginSavedDataList.isEmpty && ginSavedDataList == null) {
              return Text("No Data to Show");
            }
          }

          print("total records---- ${ginSavedDataList.length}");
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
                    viewModel.ginDtlFilter,
                    viewModel,
                    viewModel.scrollPosition,
                  );
                },
              ),
              appBar: BaseAppBar(
                title: Text("GIN - Khat"),
              ),
              body: ginSavedDataList != null && ginSavedDataList.isNotEmpty
                  ? ListView.builder(
                      itemCount: ginSavedDataList.length,
                      controller: _controller,
                      itemBuilder: (context, int index) {
                        color() {
                          if (ginSavedDataList[index].status == "Approved") {
                            return Colors.green;
                          } else if (ginSavedDataList[index].status ==
                              "Rejected") {
                            return Colors.red;
                          } else if (ginSavedDataList[index].status ==
                              "Pending") {
                            return Colors.yellow;
                          }
                        }

                        icon() {
                          if (ginSavedDataList[index].status == "Approved") {
                            return Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 12,
                            );
                          } else if (ginSavedDataList[index].status ==
                              "Rejected") {
                            return Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 12,
                            );
                          } else if (ginSavedDataList[index].status ==
                              "Pending") {
                            return Icon(
                              Icons.warning_amber,
                              color: Colors.black,
                              size: 12,
                            );
                          }
                        }

                        var selectedIndexData = ginSavedDataList[index];
                        return GestureDetector(
                          onTap: () {
                            viewModel.onSavedViewListTap(viewModel.ginDtlFilter,
                                ginSavedDataList[index]);
                            BaseNavigate(
                                context,
                                GINDetailScreen(
                                  order: PoModel(
                                      transactionNo:
                                          selectedIndexData.supllierinvno,
                                      transactionDate:
                                          selectedIndexData.grndate),
                                  selecedIndexStatus: selectedIndexData.status,
                                  viewModel: viewModel,
                                ));
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(9),
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                height: height * .17,
                                width: width,
                                decoration: BoxDecoration(
                                    color: themeData.primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(ginSavedDataList[index].grnno,
                                              style: TextStyle(fontSize: 15)),
                                          Text(ginSavedDataList[index].grndate,
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          ginSavedDataList[index].supplier,
                                          maxLines: 3,
                                        )),
                                    // SizedBox(
                                    //   height: 3,
                                    // ),
                                    Flexible(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ginSavedDataList[index].purorderno,
                                        ),
                                        Text(
                                          ginSavedDataList[index].purorderdate,
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: width * .02,
                                  child: CircleAvatar(
                                    backgroundColor: color(),
                                    radius: 10,
                                    child: icon(),
                                    // backgroundColor:
                                    //     ginSavedDataList[index].status ==
                                    //             "Approved"
                                    //         ? Colors.green
                                    //         : Colors.red,
                                    // radius: 10,
                                    // child: ginSavedDataList[index].status ==
                                    //         "Approved"
                                    //     ? Icon(
                                    //         Icons.check,
                                    //         color: Colors.white,
                                    //         size: 12,
                                    //       )
                                    //     : Icon(
                                    //         Icons.clear,
                                    //         color: Colors.white,
                                    //         size: 12,
                                    //       ),
                                  )),
                            ],
                          ),
                        );
                      },
                    )
                  : _isLoading
                      ? Center(
                          child: BaseLoadingView(
                            message: "Loading",
                          ),
                        )
                      : Center(
                          child: Text("No Data to show"),
                        )
              //Center(child: loadingWidget()
              // BaseLoadingView(
              //   message: "Loading",
              // ),
              // ),
              );
        });
  }

  showDialog(
    BuildContext context,
    GINDateFilterModel model,
    GINViewModel viewModel,
    double position,
  ) async {
    start = 0;

    GINDateFilterModel resultedData = await appShowChildDialog(
        context: context,
        child: GinDateFilterDialog(
          viewModel: viewModel,
          // model: GinDateFilterDialog,
          model: viewModel.ginDtlFilter,
        ));
    ginSavedDataList = [];
    viewModel.onGinFilterSubmit(resultedData, start, ginSavedDataList);
  }
}

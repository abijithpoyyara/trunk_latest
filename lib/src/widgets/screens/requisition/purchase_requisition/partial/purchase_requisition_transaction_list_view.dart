import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/purchase_requisition/purchase_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_view_model.dart';
import 'package:redstars/src/services/repository/notifications/notifications_repository.dart';
import 'package:redstars/src/services/repository/requisition/purchase_requisition/purchase_requisition_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/partial/purchase_requisition_filter_view.dart';

import '../purchase_requisition_view.dart';

class PRListView extends StatefulWidget {
  final PurchaseRequisitionViewModel viewmodel;

  const PRListView({
    Key key,
    this.viewmodel,
  }) : super(key: key);

  @override
  _PRListViewState createState() => _PRListViewState();
}

class _PRListViewState extends State<PRListView> {
  int sor_id, eor_id, totalRecords = 1, limit, start;

  ScrollController _controller;
  bool _isLoading;

  List<PurchaseViewList> purchaseListData;
  List<PurchaseViewList> data1;
  String st;
  // @override
  // void initState() {
  //   super.initState();
  //   purchaseListData = [];
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
    purchaseListData = [];
    data1 = [];
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
    await PurchaseRequisitionRepository().getPurchaseView(
        filterModel: widget.viewmodel.model,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => {
          setState(() {
            purchaseListData = [];
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
                print("purchase----${purchaseListData.length}");
                data1 = result.purchaseViewList;
                purchaseListData = result.purchaseViewList;
              } else {
                print("secd called");
                purchaseListData.addAll(result.purchaseViewList);
                print("purchase----${result.purchaseViewList}");
                eor_id = result.SOR_Id;
                sor_id = result.EOR_Id;
                totalRecords = result.totalRecords;
                // start += limit;
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
  //       widget.viewmodel.model, start, _scrollPosition, purchaseListData);
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, PurchaseRequisitionViewModel>(
        // init: (store, context) {
        //   final state = store.state.requisitionState.purchaseRequisitionState;
        //   // store.dispatch(fetchUomData());
        //   store.dispatch(fetchPurchaseViewListData(
        //     start: 0,
        //     filterModel: PVFilterModel(
        //         fromDate: state.filterModel.fromDate,
        //         toDate: state.filterModel.toDate,
        //         reqNo: ""),
        //   ));
        // },
        // onDidChange: (viewModel, context) {
        //   if (viewModel.detailPurchaseModelData != null) Navigator.pop(context);
        // },
        converter: (store) => PurchaseRequisitionViewModel.fromStore(store),
        builder: (context, viewModel) {
          print("total records---- ${purchaseListData.length}");
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
                  viewModel.model,
                  viewModel,
                  viewModel.scrollPosition,
                );
              },
            ),
            appBar: BaseAppBar(
              title: Text("Requisitions"),
            ),
            body: purchaseListData != null && purchaseListData.isNotEmpty
                ? ListView.builder(
                    itemCount: purchaseListData.length,
                    controller: _controller,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () {
                          viewModel.onPurchaseView(
                              viewModel.purchaseViewListModel,
                              purchaseListData[index],
                              PVFilterModel(
                                  fromDate: viewModel.model.fromDate));
                          // setState(() {
                          //   viewModel.statusinformation =
                          //       purchaseListData[index].status;
                          //   st =
                          //       viewModel.statusinformation;
                          //   print(
                          //       "wwwwwwwwwwwww${viewModel.statusinformation}");
                          //
                          //   // viewModel.listStatus.first =
                          //   //     purchaseListData[index];
                          // });
                          st = purchaseListData[index].status;
                          Navigator.pop(context, st);
                          // BaseNavigate(context, PurchaseRequisitionView(purchaseListDataIn: purchaseListData[index],));
                          PurchaseRequisitionView();
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
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(purchaseListData[index].requestno,
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                    purchaseListData[index].location,
                                  )),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Flexible(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        purchaseListData[index].createduser,
                                      ),
                                      Text(
                                        purchaseListData[index].createddate,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Positioned(
                                right: width * .02,
                                child: CircleAvatar(
                                  backgroundColor:
                                      purchaseListData[index].status ==
                                              "APPROVED"
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                  child: purchaseListData[index].status ==
                                          "APPROVED"
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                      : Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                )),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("No List to Show"),
                  ),
          );
        });
  }

  showDialog(
    BuildContext context,
    PVFilterModel model,
    PurchaseRequisitionViewModel viewModel,
    double position,
  ) async {
    start = 0;

    PVFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: PurchaseFilterDialog(
          viewModel: viewModel,
          model: viewModel.model,
        ));
    purchaseListData = [];
    viewModel.onFilterSubmit(resultSet, start, position, purchaseListData);
  }
}

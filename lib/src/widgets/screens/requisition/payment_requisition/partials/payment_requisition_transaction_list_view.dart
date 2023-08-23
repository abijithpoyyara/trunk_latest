import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/payment_requisition/payment_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_view_list_model.dart';
import 'package:redstars/src/services/repository/requisition/payment_requisition/payment_requisition_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/partials/payment_requisition_filter_view.dart';

import '../../../../../../utility.dart';

class PAYListView extends StatefulWidget {
  final PaymentRequisitionViewModel viewmodel;
  const PAYListView({
    Key key,
    this.viewmodel,
  }) : super(key: key);

  @override
  _PAYListViewState createState() => _PAYListViewState();
}

class _PAYListViewState extends State<PAYListView> {
  int sor_id, eor_id, totalRecords, start, limit = 10;
//  ScrollController _controller;
  ScrollController _controller = new ScrollController();
  bool _isLoading;

  List<PaymentListview> paymentListData;
  List<PaymentListview> data1;

  @override
  void initState() {
    super.initState();
    start = 0;
    paymentListData = [];
    _isLoading = false;
    data1 = [];
    //  limit = 10;
    _loadItems(initLoad: true);
    //  initLoad = false;
    _controller = ScrollController(
      initialScrollOffset: widget.viewmodel.scrollPosition ?? 0,
      keepScrollOffset: true,
    );
    //  _isLoading = false;
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // if (paymentListData.length ==
        //     widget.viewmodel.paymentReqModel.totalRecords)
        if (!_isLoading) _loadItems();
      }
    });
  }

  _loadItems({bool initLoad = false}) async {
    setState(() {
      _isLoading = true;
      if (initLoad) start = 0;
    });

    await PaymentRequisitionRepository().getPaymentReqstnView(
        filterModel: widget.viewmodel.model,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        optionId: widget.viewmodel.optionId,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) => setState(() {
              paymentListData = [];
              _isLoading = false;
              eor_id = null;
              sor_id = null;
              totalRecords = null;
              start = null;
            }),
        onRequestSuccess: (result) {
          setState(() {
            _isLoading = false;
            if (initLoad) {
              print("initial---${paymentListData.length}");
              data1 = result.paymentReqViewList;
              paymentListData = result.paymentReqViewList;
            } else {
              data1.addAll(result.paymentReqViewList);
              paymentListData.addAll(result.paymentReqViewList);
              print("length----${paymentListData.length}");
              eor_id = result.SOR_Id;
              sor_id = result.EOR_Id;
              totalRecords = result.totalRecords;
              //  start += limit;
            }
          });
        });

    var _scrollPosition = _controller.position.pixels;
    // widget.viewmodel.onLoadMore(
    //     widget.viewmodel.model, start, _scrollPosition, paymentListData);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BaseView<AppState, PaymentRequisitionViewModel>(
        // init: (store, context) {
        //   final state = store.state.requisitionState.paymentRequisitionState;
        //   store.dispatch(fetchPaymentViewListData(
        //     start: 0,
        //     filterModel: PVFilterModel(
        //         fromDate: state.fromDate, toDate: state.toDate, reqNo: ""),
        //     //listData: paymentListData
        //   ));
        // },

        converter: (store) => PaymentRequisitionViewModel.fromStore(store),
        builder: (context, viewModel) {
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
            body: paymentListData.length > 0
                ? ListView.builder(
                    itemCount:
                        // viewModel.paymentReqModel.paymentReqViewList.length,
                        paymentListData.length,
                    controller: _controller,
                    itemBuilder: (context, int pos) {
                      return GestureDetector(
                        onTap: () {
                          viewModel.onGetDtlJsonData(
                              paymentListData[pos], viewModel.model);
                          Navigator.pop(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(9),
                              margin: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              height: height * .19,
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
                                        Text(paymentListData[pos]?.requestno,
                                            style: TextStyle(fontSize: 15)),
                                        Text(paymentListData[pos]?.requestdate),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                          paymentListData[pos]?.analysisname)),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Flexible(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Requested Amount"),
                                      Text(paymentListData[pos]
                                                  ?.requestedamount ==
                                              null
                                          ? "00"
                                          : BaseNumberFormat(
                                                      number:
                                                          paymentListData[pos]
                                                              ?.requestedamount)
                                                  .formatCurrency()
                                                  .toString() ??
                                              ""),
                                    ],
                                  )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Flexible(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Payment Type"),
                                      Text(paymentListData[pos]?.paymenttype ??
                                          ""),
                                    ],
                                  )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                right: width * .02,
                                child: CircleAvatar(
                                  backgroundColor:
                                      paymentListData[pos]?.status == "APPROVED"
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                  child:
                                      paymentListData[pos]?.status == "APPROVED"
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
    PaymentRequisitionViewModel viewModel,
    double position,
  ) async {
    start = 0;

    PVFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: PaymentFilterDialog(
          viewModel: viewModel,
          model: viewModel.model,
        ));
    paymentListData = [];

    viewModel.onFilterSubmit(resultSet, start, position, paymentListData);
  }
}

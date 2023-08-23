import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_invoice/salesinvoice_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_view_list_model.dart';
import 'package:redstars/src/services/repository/sales_invoice/sale_enquiry_repository.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/partial/sales_filter.dart';
import 'package:redstars/utility.dart';

import '../sales_invoice_pre_fill.dart';

class SalesInvoiceViewList extends StatefulWidget {
  SalesInvoiceViewModel viewmodel;
  SalesInvoiceViewList({Key key, this.viewmodel}) : super(key: key);

  @override
  _SalesInvoiceViewListState createState() => _SalesInvoiceViewListState();
}

class _SalesInvoiceViewListState extends State<SalesInvoiceViewList> {
  int sor_id, eor_id, totalRecords = 1, limit = 10, start;

  ScrollController _controller;
  bool _isLoading;

  List<SalesInvoiceSavedViewList> salesInvoicelist;

  @override
  void initState() {
    super.initState();
    salesInvoicelist = [];

    _loadItems(initLoad: true);
    _controller = ScrollController(
      initialScrollOffset: widget.viewmodel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_isLoading) _loadItems(initLoad: false);
      }
    });
  }

  List<SalesInvoiceSavedViewList> data1 = [];
  _loadItems({bool initLoad = false}) async {
    setState(() {
      _isLoading = true;
      if (initLoad) start = 0;
    });
    await SaleInvoiceRepository().getSalesInvoiceView(
        filterModel: widget.viewmodel.salesFilter,
        optionId: widget.viewmodel.optionId,
        eor_Id: initLoad ? null : eor_id,
        sor_Id: initLoad ? null : sor_id,
        totalRecords: initLoad ? null : totalRecords,
        start: initLoad ? 0 : start += limit ?? 0,
        onRequestFailure: (error) {
          setState(() {
            salesInvoicelist = [];
            _isLoading = false;
            eor_id = null;
            sor_id = null;
            totalRecords = null;
            start = null;
          });
        },
        onRequestSuccess: (result) {
          setState(() {
            _isLoading = false;
            if (initLoad) {
              data1 = result.salesInvoicelist;
              print("data1= ${data1}");
              salesInvoicelist = result.salesInvoicelist;
              print("purchase----${salesInvoicelist.length}");
            } else {
              print("data2= ${data1}");
              salesInvoicelist.addAll(result.salesInvoicelist);
              print("purchase----${result.salesInvoicelist.length}");
              eor_id = result.EOR_Id;
              sor_id = result.SOR_Id;
              totalRecords = result.totalRecords;
              // start += limit;

            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BaseView<AppState, SalesInvoiceViewModel>(
        // init: (store, context) {

        // final state = store.state.requisitionState.purchaseRequisitionState;
        //  final optionId = store.state.homeState.selectedOption.optionId;
        //  store.dispatch(fetchUomData());
        // store.dispatch(fetchSalesInvoiceListView(
        //   optionId: optionId,
        //   // start: 0,
        //   filterModel: PVFilterModel(
        //       salesinvoiceFromDate: state.fromDate,
        //       salesinvoiceToDate: state.toDate,
        //       salesinvoiceTransno: ""),
        // ));
        //  },
        converter: (store) => SalesInvoiceViewModel.fromStore(store),
        builder: (context, viewModel) {
          print("total records---- ${salesInvoicelist.length}");
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Date filter",
              child: Icon(
                Icons.filter_list,
                color: themeData.primaryColorDark,
              ),
              onPressed: () {
                showDialog(context, viewModel.salesFilter, viewModel,
                    viewModel.scrollPosition);
              },
            ),
            appBar: BaseAppBar(
              title: Text("Invoice"),
            ),
            body: salesInvoicelist.length > 0
                ? ListView.builder(
                    itemCount:

                        //viewModel.salesViewListModel.salesInvoicelist.length,
                        salesInvoicelist.length,
                    controller: _controller,
                    itemBuilder: (context, int index) {
                      print("length---${salesInvoicelist.length}");
                      return GestureDetector(
                        onTap: () {
                          viewModel.onTapViewList(salesInvoicelist[index]);
                          BaseNavigate(
                              context,
                              SalesFillForm(
                                viewModel: viewModel,
                                //  datalist: viewModel.salesInvoiceDtlList.first,
                              ));
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
                                        Text(salesInvoicelist[index].transno,
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                          salesInvoicelist[index].transdate,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      child: Text(
                                    salesInvoicelist[index].customername,
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
                                        salesInvoicelist[index]
                                            .nettotal
                                            .toString(),
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
                                      salesInvoicelist[index].status ==
                                              "APPROVED"
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                  child: salesInvoicelist[index].status ==
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
    SalesInvoiceViewModel viewModel,
    double position,
  ) async {
    start = 0;

    PVFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: SalesInvoiceFilterDialog(
          viewModel: viewModel,
          model: viewModel.salesFilter,
        ));
    salesInvoicelist = [];
    viewModel.onEnterFilter(resultSet, start, 0.0, salesInvoicelist);
  }
}

class Data {
  String name;
  String id;
  String saleman;
  Data(this.id, this.name, this.saleman);
}

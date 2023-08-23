import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_invoice/salesinvoice_viewmodel.dart';
import 'package:redstars/utility.dart';

class SalesFillForm extends StatefulWidget {
  final SalesInvoiceViewModel viewModel;
  //final SalesInvoiceDetailList datalist;

  SalesFillForm({Key key, this.viewModel}) : super(key: key);

  @override
  _SalesFillFormState createState() => _SalesFillFormState();
}

class _SalesFillFormState extends State<SalesFillForm> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData colorTheme = ThemeProvider.of(context);
    BaseColors colors = BaseColors.of(context);
    BaseTheme style = BaseTheme.of(context);
    BaseTheme theme = BaseTheme.of(context);
    String sname;
    String custName;
    double totalValue = 0.0;
    String currency;
    String uomName;

    return BaseView<AppState, SalesInvoiceViewModel>(
        converter: (store) => SalesInvoiceViewModel.fromStore(store),
        builder: (context, viewModel) {
          viewModel.salesman.forEach((element) {
            if (element.personnelid ==
                viewModel.salesInvoiceDtlList.first.salesmanid) {
              sname = element.description;
            }
            return sname;
          });
          viewModel.customerTypes.forEach((element) {
            if (element.id ==
                viewModel.salesInvoiceDtlList.first.customertypebccid) {
              custName = element.description;
            }
            return custName;
          });
          viewModel.currency.forEach((element) {
            if (element.id ==
                viewModel.salesInvoiceDtlList.first.fccurrencyid) {
              currency = element.code;
            }
            return currency;
          });

          totalValue += viewModel.salesInvoiceDtlList.first.dtlJson.fold(
              0, (previousValue, element) => previousValue + element.subtotal);

          return Scaffold(
            appBar: BaseAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sales invoice")
                  // Text(
                  //   "CSV-00007/20EO",
                  // ),
                  // Text("30-01-2021")
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: (MediaQuery.of(context).size.height / 1.9).toInt(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Invoice for",
                                    style: theme.body2Hint,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${viewModel.salesInvoiceDtlList.first.customername}"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: theme.body2Hint,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${viewModel.salesViewListModel.salesInvoicelist.first.nettotal}")
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_chart,
                                color: colorTheme.accentColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Invoice Details")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: colorTheme.primaryColor,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 20),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Customer Type:",
                                            style: theme.body2Hint,
                                          ),
                                          Text(
                                            "Date",
                                            style: theme.body2Hint,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            custName ?? "",
                                          ),
                                          Text(BaseDates(DateTime.parse(
                                                  "${viewModel.salesInvoiceDtlList.first.transdate}"))
                                              .dbformat)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Transaction no:",
                                            style: theme.body2Hint,
                                          ),
                                          Text("Salesman:",
                                              style: theme.body2Hint)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${viewModel.salesInvoiceDtlList.first.transno}"),
                                          Text("${sname}")
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("F.Currency:",
                                                style: theme.body2Hint),
                                            Text("Exchange rate:",
                                                style: theme.body2Hint)
                                          ]),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(currency),
                                          Text(
                                              "${viewModel.salesInvoiceDtlList.first.exchrate}")
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_road_outlined,
                                color: colorTheme.accentColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Item Details")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, int index) {
                              viewModel.uomsList.forEach((element) {
                                if (element.uomid ==
                                    viewModel.salesInvoiceDtlList.first
                                        .dtlJson[index].uomid) {
                                  uomName = element.uomname;
                                }
                                return uomName;
                              });
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: colorTheme.primaryColor,
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 20),
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Item Name:",
                                                      style: theme.body2Hint,
                                                    ),
                                                    Text(
                                                      "Quantity",
                                                      style: theme.body2Hint,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${viewModel.salesInvoiceDtlList.first.dtlJson[index].itemname}",
                                                      style: theme.body2Medium
                                                          .copyWith(
                                                              fontSize: 16),
                                                    ),
                                                    Text(
                                                        "${viewModel.salesInvoiceDtlList.first.dtlJson[index].qty}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Uom:",
                                                      style: theme.body2Hint,
                                                    ),
                                                    Text("Rate:",
                                                        style: theme.body2Hint)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("${uomName ?? ""} "),
                                                    Text(
                                                        "${viewModel.salesInvoiceDtlList.first.dtlJson[index].rate}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Divider(
                                              color:
                                                  colorTheme.primaryColorDark,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total"),
                                                Text(
                                                    "${viewModel.salesInvoiceDtlList.first.dtlJson[index].subtotal}")
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: viewModel
                                .salesInvoiceDtlList.first.dtlJson.length,
                          ),
                        ),
                        // CartPriceDtl(
                        //   viewModel: widget.viewModel,
                        // )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .05,
                        right: MediaQuery.of(context).size.width * .05),
                    child: Card(
                      color: colorTheme.primaryColor,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total"),
                            Text(totalValue.toString())
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

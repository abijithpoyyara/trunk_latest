// import 'package:flutter/material.dart';
// import 'package:redstars/src/redux/states/sales_invoice%20state/product_state.dart';
// import 'package:redstars/src/redux/states/sales_invoice%20state/sales_enquiry_state.dart';
//
// @immutable
// class InvoiceState {
//   final SaleInvoiceState saleInvoiceState;
//
//   final ProductState productState;
//
//   InvoiceState({
//     @required this.saleInvoiceState,
//     //   @required this.enquiryStatusState,
//     @required this.productState,
//   });
//
//   InvoiceState copyWith({
//     SaleInvoiceState saleInvoiceState,
//     ProductState productState,
//     // SaleEnquiryStatusState enquiryStatusState,
//   }) {
//     return InvoiceState(
//       saleInvoiceState: saleInvoiceState ?? this.saleInvoiceState,
//       productState: productState ?? this.productState,
//       // enquiryStatusState: enquiryStatusState ?? this.enquiryStatusState,
//     );
//   }
//
//   factory InvoiceState.initial() {
//     return InvoiceState(
//       saleInvoiceState: SaleInvoiceState.initial(),
//       productState: ProductState.initial(),
//       // enquiryStatusState: SaleEnquiryStatusState.initial(),
//     );
//   }
// }

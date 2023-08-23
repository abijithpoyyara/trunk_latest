// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
// import 'package:base/res/values/base_theme.dart';
// import 'package:base/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:redstars/res/drawbles/app_vectors.dart';
// import 'package:redstars/src/redux/states/app_state.dart';
// import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
// import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
// import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
//
// import 'model/transaction_save_model.dart';
//
// class TransUnblockReqApprovalEdit extends StatefulWidget {
//   final bool isComingNotification;
//  var optionId;
//   var transTableId ;
//   var transId;
//   var approveOptionId;
//   final int index;
//   final List<TransactionUnblockListView> data;
//   final TransactionUnblockReqApprlViewModel viewModel;
//
//   TransUnblockReqApprovalEdit(
//       {Key key, this.index, this.data, this.viewModel,
//         this.optionId,this.approveOptionId,
//         this.transId,this.transTableId,
//       this.isComingNotification=false})
//       : super(key: key);
//
//   @override
//   _TransUnblockReqApprovalEditState createState() =>
//       _TransUnblockReqApprovalEditState(
// //      model
//           );
// }
//
// class _TransUnblockReqApprovalEditState
//     extends State<TransUnblockReqApprovalEdit> {
//   ApprovalSaveModel model;
//
//   int _value;
//   String _currentSelectedValue;
//
//   final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//
// //  _TransUnblockReqApprovalEditState(this.model);
//   @override
//   void initState() {
//     model = ApprovalSaveModel();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData themedata = ThemeProvider.of(context);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
//         converter: (store) =>
//             TransactionUnblockReqApprlViewModel.fromStore(store),
//         onDidChange: (viewModel, context) {
//           if (viewModel.isTransReqAppvl) {
//             showSuccessDialog(context, "Saved Successfully", "Success", () {
//               viewModel.onTransactionApprlReqClearAction();
//               viewModel.onRefreshCountData();
//               Navigator.pop(context);
//               Navigator.pop(context);
//             });
//           }
//         },
//         builder: (context, viewModel) {
//           return Center(
//               child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Material(
//                 color: themedata.primaryColor,
//                 borderRadius: BorderRadius.circular(5.0),
//                 child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text("Request Unblock ",
//                                 style: BaseTheme.of(context).title),
//                             SizedBox(height: 8),
//
//                             Container(
//                               padding: EdgeInsets.all(9),
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 1, horizontal: 10),
//                               height: height * .20,
//                               width: width,
//                               decoration: BoxDecoration(
//                                   // color: Colors.red,
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Flexible(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Flexible(
//                                               child: Text("Blockage Date ",
//                                                   style:
//                                                       TextStyle(fontSize: 14)),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                   widget.data[widget.index]
//                                                       .blockeddate,
//                                                   style:
//                                                       TextStyle(fontSize: 15)),
//                                             )
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             Flexible(
//                                               child: Text("Requested Person",
//                                                   style:
//                                                       TextStyle(fontSize: 14)),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                   widget.data[widget.index]
//                                                       .unblockrequestedperson,
//                                                   style:
//                                                       TextStyle(fontSize: 15)),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Flexible(
//                                   //   child: Row(
//                                   //     mainAxisAlignment:
//                                   //         MainAxisAlignment.spaceBetween,
//                                   //     children: [
//                                   //       Column(
//                                   //         crossAxisAlignment:
//                                   //             CrossAxisAlignment.start,
//                                   //         children: [
//                                   //           Flexible(
//                                   //             child: Text("Blockage Date ",
//                                   //                 style:
//                                   //                     TextStyle(fontSize: 14)),
//                                   //           ),
//                                   //           Flexible(
//                                   //             child: Text(
//                                   //                 widget.data[widget.index]
//                                   //                     .blockeddate,
//                                   //                 style:
//                                   //                     TextStyle(fontSize: 15)),
//                                   //           )
//                                   //         ],
//                                   //       ),
//                                   //       Column(
//                                   //         crossAxisAlignment:
//                                   //             CrossAxisAlignment.end,
//                                   //         children: [
//                                   //           Flexible(
//                                   //             child: Text("Requested Person",
//                                   //                 style:
//                                   //                     TextStyle(fontSize: 14)),
//                                   //           ),
//                                   //           Flexible(
//                                   //             child: Text(
//                                   //                 widget.data[widget.index]
//                                   //                     .unblockrequestedperson,
//                                   //                 style:
//                                   //                     TextStyle(fontSize: 15)),
//                                   //           )
//                                   //         ],
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Flexible(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                   "Requested Date & Time ",
//                                                   style:
//                                                       TextStyle(fontSize: 14)),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                   widget.data[widget.index]
//                                                       .unblockrequesteddatetime,
//                                                   style:
//                                                       TextStyle(fontSize: 15)),
//                                             )
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             Flexible(
//                                               child: Text("user Name",
//                                                   style:
//                                                       TextStyle(fontSize: 14)),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                   widget.viewModel
//                                                           ?.loginedUserName ??
//                                                       "",
//                                                   style:
//                                                       TextStyle(fontSize: 15)),
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 3.5,
//                                   ),
//                                   Flexible(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Flexible(
//                                               child: Text("Action Date",
//                                                   style:
//                                                       TextStyle(fontSize: 14)),
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                   widget.data[widget.index]
//                                                       .unblockrequestdate,
//                                                   style:
//                                                       TextStyle(fontSize: 15)),
//                                             )
//                                           ],
//                                         ),
//
// //                                    Column(
// //                                      crossAxisAlignment: CrossAxisAlignment.end,
// //                                      children: [
// //                                        Text(
// //                                         "rrr",
// //                                            style: TextStyle(fontSize: 14)),
// //                                        // 2
// //
// //                                      ],
// //                                    ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 2),
//                               child: BaseDialogField<ActionTaken>(
//                                 displayTitle: "Action",
//                                 vector: AppVectors.direct,
//                                 hint: "Tap select data",
//                                 icon: Icons.dashboard,
//                                 list: widget.viewModel.actionTypes,
//                                 initialValue: model.approvalStatus,
//                                 isEnabled: true,
//                                 listBuilder: (val, pos) => DocumentTypeTile(
//                                   selected: true,
//                                   //isVector: true,,
//                                   icon: Icons.list,
//                                   title: val.description,
//                                   onPressed: () => Navigator.pop(context, val),
//                                 ),
//                                 fieldBuilder: (selected) => Text(
//                                   selected.description,
//                                   style: BaseTheme.of(context).textfield,
//                                   textAlign: TextAlign.start,
//                                 ),
//                                 validator: (val) =>
//                                     val == null ? "please Select" : null,
//
//                                 onSaved: (value) {
//                                   model.approvalStatus = value;
//                                 },
//                                 onChanged: (value) {
//                                   model.approvalStatus = value;
//                                 },
// //          onSaved: (val) {}
//                               ),
//                             ),
// //                      Container(
// //                        padding:
// //                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
// //                        child: FormField<String>(
// //                          builder: (FormFieldState<String> state) {
// //                            return InputDecorator(
// //                              decoration: InputDecoration(
// //                                  labelText: ("Action"),
// //                                  labelStyle: TextStyle(
// //                                      fontSize: 20, color: Colors.white),
// ////                                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 25.0),
// //                                  hintText: 'Please select ',
// //                                  border: OutlineInputBorder(
// //                                      borderRadius:
// //                                          BorderRadius.circular(20.0))),
// //                              isEmpty: _currentSelectedValue == '',
// //                              child: DropdownButtonHideUnderline(
// //                                child: DropdownButton<String>(
// //                                  dropdownColor: themedata.primaryColor,
// //                                  value: _currentSelectedValue,
// //                                  isDense: true,
// //                                  onChanged: (String newValue) {
// //                                    setState(() {
// //                                      _currentSelectedValue = newValue;
// //                                      state.didChange(newValue);
// //                                    });
// //                                  },
// //                                  items: widget.viewModel.ActionTypes
// //                                      .map((ActonTaken value) {
// //                                    return DropdownMenuItem<String>(
// //                                      value: value.description,
// //                                      child: Text(value.description),
// //                                    );
// //                                  }).toList(),
// //                                ),
// //                              ),
// //                            );
// //                          },
// //                        ),
// //                      ),
//
//                             Flexible(
//                               child: ListView(
//                                 children: [
//                                   SizedBox(height: 8),
//                                   _buildDateField(
//                                     "Extended Date ",
//                                     DateTime.now(),
//                                     (val) => model?.extendedDate = val,
//                                     (val) => model?.extendedDate = val,
//                                   ),
//                                   SizedBox(
//                                     height: 3,
//                                   ),
//                                   Container(
//                                     //                            color: Colors.deepPurpleAccent,
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 2),
//                                     //                          child:  Padding(
//                                     //                            padding: EdgeInsets.all(0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 30, bottom: 4),
//                                           child:
//                                               Text("Action Taken Against Whom"),
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.ac_unit_sharp,
//                                               color: Colors.white,
//                                             ),
//                                             SizedBox(
//                                               width: 6,
//                                             ),
//                                             Flexible(
//                                               child: TextFormField(
// //                                      maxLines: 2,
//                                                 enabled: false,
//                                                 initialValue: widget
//                                                     .data[widget.index]
//                                                     .actiontakenagainst,
//                                                 decoration: InputDecoration(
//                                                     disabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           color: Colors.white,
//                                                           width: 2.0),
//                                                     ),
//                                                     labelStyle: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   _actionTaken("Action Taken"),
//                                   SizedBox(height: 8),
//                                   _ActualBlkReason(
//                                       "Describe Actual Blocking Reason"),
//                                   SizedBox(height: 8),
//                                   _approvalRemark("Approval Remark"),
//                                   SizedBox(height: 8),
//                                 ],
//                               ),
//                             ),
//
//                             _buildFilterButton(viewModel),
//                           ],
//                         )))),
//           ));
//         });
//   }
//
//   Widget _buildDateField(
//     String title,
//     DateTime initialDate,
//     Function(DateTime) onChanged,
//     Function(DateTime) onSaved,
//   ) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: BaseDatePicker(
//         isVector: true,
//         hint: title,
//         icon: Icons.calendar_today,
//         displayTitle: title,
//         initialValue: initialDate,
//         disablePreviousDates: true,
//         autovalidate: true,
//         onChanged: onChanged,
//         onSaved: onSaved,
//         validator: (val) => (val == null) ? "Please select date" : null,
//       ),
//     );
//   }
//
//   Widget _ActualBlkReason(String title) {
//     return Container(
// //      color: Colors.deepPurpleAccent,
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: BaseTextField(
//           isEnabled: false,
//           displayTitle: title,
//           initialValue: widget.data[widget.index].blockedreason,
//           // onChanged: (val) => model?.reqNo = val,
//           // onSaved: (val) => model?.reqNo = val,
//           autovalidate: false,
//         ));
//   }
//
//   Widget _approvalRemark(String title) {
//     return Container(
// //      color: Colors.deepPurpleAccent,
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: BaseTextField(
//           displayTitle: title,
//           initialValue: "",
//           onChanged: (val) => model?.remarks = val,
//           onSaved: (val) => model?.remarks = val,
//           autovalidate: false,
//         ));
//   }
//
//   Widget _actionTaken(String title) {
//     return Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: BaseTextField(
//           isEnabled: false,
//           displayTitle: title,
//           icon: Icons.money,
//           initialValue: (widget.data[widget.index].actiontaken ?? ""),
//           //  onChanged: (val) => model?.transNo = val,
//           //  onSaved: (val) => model?.transNo = val,
//           autovalidate: false,
//         ));
//   }
//
//   Widget _buildFilterButton(TransactionUnblockReqApprlViewModel viewModel) {
//     ThemeData themedata = ThemeProvider.of(context);
//     return Container(
//       child: MaterialButton(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         onPressed: () {
//           _submitForm(viewModel);
//         },
//         child: Text(
//           'Save',
//           style: BaseTheme.of(context).bodyMedium.copyWith(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//         ),
//         color: themedata.primaryColorDark,
//       ),
//     );
//   }
//
//   void _submitForm(TransactionUnblockReqApprlViewModel viewModel) {
//     final FormState form = _formKey.currentState;
//     if (!form.validate()) {
//       print('Form is not valid!  Please review and correct.');
//     } else {
//       form.save();
//       viewModel.onSave(
//         DateTime.now(),
//         model?.remarks ?? "",
//         model?.approvalStatus?.code == "APPROVED" ? "A" : "R",
//         model?.extendedDate ?? DateTime.now(),
//         widget.data[widget.index].transunblockrequestid,
//         widget.data[widget.index].unblockrequestreftableid,
//         widget.data[widget.index].unblockrequestreftabledataid,
//       );
//       viewModel.onApprvalModelSave(model);
//
//       print(model);
//     }
//   }
// }

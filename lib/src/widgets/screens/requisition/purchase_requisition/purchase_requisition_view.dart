import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/requisition/purchase_requisition/purchase_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/purchase_requisition/purchase_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_view_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/new_item_sheet.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/partial/purchase_requisition_transaction_list_view.dart';
import 'package:redstars/utility.dart';

import '../partials/approval_button.dart';
import 'model/purchase_requisition_model.dart';

final keyForm = GlobalKey<ApprovalButtonsState>();
String statusval;

class PurchaseRequisitionView extends StatelessWidget {
  final PurchaseViewList purchaseListDataIn;
  const PurchaseRequisitionView({Key key, this.purchaseListDataIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return BaseView<AppState, PurchaseRequisitionViewModel>(
        init: (store, con) {
          store.dispatch(fetchInitialData());
          store.dispatch(fetchDepartments());
          store.dispatch(fetchBranchStore());
          store.dispatch(fetchBranches());
          //store.dispatch(fetchItems());
        },
        onDidChange: (viewModel, context) {
          if (viewModel.isSaved)
            showSuccessDialog(context,
                "Purchase requisition saved" + "successfully", "Success", () {
              viewModel.onClear();
            });
        },
        builder: (con, viewModel) {
          return Scaffold(
            appBar: BaseAppBar(
              title: Text("Purchase Requisition"),
              actions: [
                Visibility(
                 // visible: viewModel.viewDtlId == 0,
                  //statusval != "APPROVED",
                  child: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        String message = viewModel.validateItems();
                        if (message != null && message.isEmpty) {
                          keyForm.currentState.onSubmit(context);
                        } else {
                          BaseSnackBar.of(con).show(message);
                        }
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      _awaitReturnValueFromSecondScreen(context, viewModel);
                    })
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        BaseNavigate.slideUp(
                            ItemAttachmentView<AppState, ScanViewModel>(),
                            name: "/scan_view"),
                      );
                    },
                    heroTag: "attachments",
                    autofocus: true,
                    child: SvgPicture.asset(
                      AppVectors.ic_attachment,
                      color: ThemeProvider.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 15),
                  FloatingActionButton(
                      backgroundColor: themeData.scaffoldBackgroundColor,
                      onPressed: () {
                        showItemAddSheet(context, viewModel: viewModel);
                      },
                      heroTag: "items",
                      autofocus: true,
                      child: SvgPicture.asset(
                        AppVectors.addnew,
                      ))
                ]),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                    if (viewModel.requisitionItems?.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (con, position) {
                          PurchaseRequisitionModel object =
                              viewModel.requisitionItems[position];
                          return Dismissible(
                              onDismissed: (direction) {
                                viewModel.onRemoveItem(object);
                              },
                              background: Container(
                                decoration: BoxDecoration(color: Colors.red),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: _buildDeleteButton(theme),
                                ),
                              ),
                              secondaryBackground: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.red),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: _buildDeleteButton(theme),
                                    ),
                                  ],
                                ),
                              ),
                              key: Key(object?.item?.code),
                              confirmDismiss: (direction) => appChoiceDialog(
                                  message: "Do you want to delete this record",
                                  context: con),
                              child: ListPurchaseItem(
                                viewModel: viewModel,
                                requisitionModel: object,
                                onClick: (selected) => showItemAddSheet(
                                  con,
                                  selected: selected,
                                  viewModel: viewModel,
                                ),
                              ));
                        },
                        itemCount: viewModel.requisitionItems?.length ?? 0,
                      )
                    else
                      emptyView(theme, colors, context),
                  ])),
                  SizedBox(height: 10),
                  if (viewModel.requisitionItems.isNotEmpty)
                    ApprovalButtons(
                        id: viewModel.viewDtlId,
                        key: keyForm,
                        sts: statusval,
                        initsta: viewModel.requisitionItems.first.remark,
                        onSubmit: ({String remarks}) {
                          String message = viewModel.validateItems();
                          if (message != null && message.isEmpty) {
                            viewModel.saveRequisition(remarks: remarks);
                          } else {
                            BaseSnackBar.of(con).show(message);
                            print(message);
                          }
                        }),
                ]),
          );
        },
        converter: (store) => PurchaseRequisitionViewModel.fromStore(store),
        onDispose: (store) => store.dispatch(OnClearAction()));
  }

  void showItemAddSheet(BuildContext context,
      {PurchaseRequisitionViewModel viewModel,
      PurchaseRequisitionModel selected}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => ItemPurchaseView<PurchaseRequisitionModel>(
          viewModel: viewModel,
          onNewItem: (reqItem) => viewModel
              .onAdd(PurchaseRequisitionModel.fromRequisitionModel(reqItem)),
          selected: selected),
    );
  }

  Widget _buildDeleteButton(BaseTheme theme, {bool reverse = false}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget emptyView(BaseTheme theme, BaseColors colors, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Container(
          height: height / 4.5,
          width: width / 2,
          child: Stack(children: [
            Positioned.fill(
              // top: MediaQuery.of(context).size.height * .14,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AppVectors.emptyBox
                    // color: Colors.black,
                    ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _awaitReturnValueFromSecondScreen(
      BuildContext context, PurchaseRequisitionViewModel viewModel) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PRListView(
            viewmodel: viewModel,
          ),
        ));

    statusval = result;
  }
}

import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item.dart';
import 'package:redstars/utility.dart';

class SalesEnquiryDetailsScreen extends StatelessWidget {
  final String title;

  const SalesEnquiryDetailsScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStore<AppState, SalesEnquiryMisViewModel>(
      converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
      builder: (context, viewModel) => BaseScrollableTabs(
        isScrollable: false,
        title: "$title",
        tabs: viewModel.selectedParticularBranch?.statuses?.entries
            ?.map((statuses) => BaseTabPage(
                title:
                    '${BaseStringCase(statuses.key).sentenceCase} ( ${statuses.value.length ?? 0} )',
                body: (statuses.value?.length ?? 0) > 0
                    ? Container(
                        padding: EdgeInsets.only(top: 8),
                        child: _EnquiryList(statuses: statuses))
                    : EmptyResultView(
                        message: "Completed",
                      )))
            ?.toList(),
      ),
    );
  }
}

class _EnquiryList extends StatefulWidget {
  final MapEntry<String, List<MisEnquiryDtl>> statuses;

  const _EnquiryList({Key key, this.statuses}) : super(key: key);

  @override
  __EnquiryListState createState() => __EnquiryListState();
}

class __EnquiryListState extends State<_EnquiryList>
    with SingleTickerProviderStateMixin {
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
    _scrollController.addListener(() {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.statuses.value?.length ?? 0,
        controller: _scrollController,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (cont, pos) {
          var enquiry = widget.statuses.value[pos];
          final Animation<double> animation = Tween<double>(begin: -1, end: 1)
              .animate(CurvedAnimation(
                  parent: animationController,
                  curve: Curves.fastOutSlowIn,
                  reverseCurve: Curves.fastLinearToSlowEaseIn));
          animationController.forward();

          return SaleEnquiryItem(
            branch: "${enquiry.branch}",
            uniqueNo: "${enquiry.enquiryUniqueNo}",
            createdDate: "${enquiry.enquiryDate}",
            enquiryNo: "${enquiry.enquiryNo}",
            status: "${enquiry.status}",
            animation: animation,
            animationController: animationController,
          );
        });
  }
}

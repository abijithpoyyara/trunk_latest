import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/sales_enquiry_mis/sale_enquiry_mis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item_list_view.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/report_date_filter.dart';
import 'package:redstars/utility.dart';

import 'mis_particular_screen.dart';
import 'view/filters_screen.dart';

class SalesMisScreen extends StatelessWidget {
  final String title;

  const SalesMisScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, SalesEnquiryMisViewModel>(
      init: (store, context) => store.dispatch(getSEMISInitialConfigs()),
      converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
      appBar: BaseAppBar(title: Text(title ?? "Sales Enquiry MIS")),
      builder: (context, viewModel) {
        return MisScreenBody(viewModel: viewModel);
      },
    );
  }
}

class MisScreenBody extends StatefulWidget {
  final SalesEnquiryMisViewModel viewModel;

  const MisScreenBody({Key key, this.viewModel}) : super(key: key);

  @override
  _MisScreenBodyState createState() => _MisScreenBodyState();
}

class _MisScreenBodyState extends State<MisScreenBody>
    with TickerProviderStateMixin {
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
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData theme = ThemeProvider.of(context);
    return Stack(
      children: [
        NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Container(
                      color: theme.primaryColor,
                      child: FilterWidget(viewModel: widget.viewModel));
                }, childCount: 1)),
                SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: BasePersistentHeaderDelegate(
                        minExtent: 52,
                        maxExtent: 52,
                        builder: (context, isAtTop) =>
                            getFilterWidget(isAtTop)))
              ];
            },
            floatHeaderSlivers: false,
            body: widget.viewModel.initialReportStatus.isLoading()
                ? BaseLoadingView(message: widget.viewModel.loadingMessage)
                // : BaseLoadingView(message: widget.viewModel.loadingMessage)
                : EnquiryListWidget(
                    animationController: animationController,
                    summaryList: widget.viewModel.summaryReport,
                    selectedItem: widget.viewModel.selectedSummaryItem,
                    onTap: (enqItem) {
                      // widget.viewModel.onEnquiryItemClick(enqItem);

                      Navigator.push(
                          context,
                          BaseNavigate.slideUp(
                              SEMISParticularScreen(enqItem: enqItem)));
                    },
                  )),
        Positioned(
            right: 15,
            bottom: 15,
            child: AnimatedOpacity(
                opacity: _showScrollTop ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: FloatingActionButton(
                    heroTag: "Scroll_to_top",
                    // backgroundColor: kPrimaryColor,
                    onPressed: () {
                      setState(() {
                        _showScrollTop = false;
                      });
                      _scrollController.animateTo(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceInOut);
                    },
                    child: Icon(Icons.arrow_upward_rounded,color: colors.selectedColor,),
                    tooltip: "Scroll to top")))
      ],
    );
  }

  Widget getFilterWidget(bool isExpanded) {
    return Builder(builder: (BuildContext context) {
      BaseTheme style = BaseTheme.of(context);
      BaseColors colors = BaseColors.of(context);
      ThemeData theme = ThemeProvider.of(context);

      return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, -2),
                      blurRadius: 8.0),
                ],
              ),
            ),
          ),
          Container(
            color: theme.primaryColor,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 4),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.viewModel.getFilterSummary(),
                        style: style.body2.copyWith(
                            // fontWeight: FontWeight.w100,
                            // fontSize: 16,
                            ),
                      ),
                    ),
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      FiltersScreen(
                                          viewModel: widget.viewModel),
                                  fullscreenDialog: false),
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.sort,
                                size: 18,
                              ))))
                ])),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Divider(height: 1),
          )
        ],
      );
    });
  }
}

class EnquiryListWidget extends StatelessWidget {
  final AnimationController animationController;
  final List<SalesEnquiryMisModel> summaryList;
  final SalesEnquiryMisModel selectedItem;
  final ValueSetter<SalesEnquiryMisModel> onTap;

  const EnquiryListWidget({
    Key key,
    this.animationController,
    this.summaryList,
    @required this.onTap,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                bottomRight: Radius.circular(22))),
        child: CupertinoScrollbar(
            child: RefreshIndicator(
          onRefresh: () {
            // widget.viewModel.refreshData();
            return Future.delayed(Duration(seconds: 2));
          },
          child: Builder(
            builder: (con) {
              return ListView.builder(
                  itemCount: summaryList?.length ?? 0,
                  padding: const EdgeInsets.only(top: 8),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final document = summaryList[index];
                    final int count = summaryList.length > 10 ? 10 : 5;
                    bool isSelected = document.itemId == selectedItem?.itemId;
                    final Animation<double> animation = Tween<double>(
                            begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                            parent: animationController,
                            curve:
                                Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    return InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.blueGrey,
                      onTap: () {
                        onTap(document);
                        // BaseNavigate(
                        //     context, SEMISDtlScreen(enquiryItem: document));
                      },
                      child: DocumentListItem(
                        enquiryItem: document,
                        animation: animation,
                        animationController: animationController,
                      ),
                    );
                  });
            },
          ),
        )));
  }
}

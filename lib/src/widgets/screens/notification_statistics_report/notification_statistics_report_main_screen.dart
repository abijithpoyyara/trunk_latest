import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstars/src/redux/actions/notification_statistics_report/notification_statistics_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/notification_statistics_report/notification_statistices_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/analysis_code_user_lookup_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_object_model.dart';
import 'package:redstars/src/services/repository/notification_statistics_report/notification_statistics_repository.dart';
import 'package:redstars/src/widgets/partials/lookup/analysis_code_lookup_field.dart';
import 'package:redstars/utility.dart';

import '../../../../resources.dart';
import 'notification_statistics_report_detail_page.dart';

bool isCountHasValue = false;
bool isPendingToSettle = false;
bool countIsNotNull = false;
bool numberTypeIsNotNull = false;
String initialNotify = "Payments Pending to Settle";
String initialReport = "Transaction Wise";

class NotificationStatisticsReport extends StatefulWidget {
  const NotificationStatisticsReport({Key key}) : super(key: key);

  @override
  _NotificationStatisticsReportState createState() =>
      _NotificationStatisticsReportState();
}

class _NotificationStatisticsReportState
    extends State<NotificationStatisticsReport> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedCurrent = formatter.format(currentDate);
    String formattedStart = formatter.format(startDate);
    DateTime fromDatefilter;
    DateTime toDatefilter;
    bool isEditingCompleted = false;
    return BaseView<AppState, NotificationStatisticsViewModel>(
      init: (store, context) {
        store.dispatch(fetchInitialData());
        store.dispatch(fetchVoucherInitialData());
        store.dispatch(fetchSortListData());
      },
      converter: (store) => NotificationStatisticsViewModel.fromStore(store),
      onDispose: (store) {
        store.dispatch(ClearAction());
      },
      appBar: BaseAppBar(
        actions: [],
        title: Text("Notification Statistics Report"),
      ),
      builder: (context, viewModel) {
        if (viewModel.reportObjList != null &&
                (viewModel?.reportObjList?.isNotEmpty ?? false) &&
                viewModel.notificationObj != null &&
                viewModel?.notificationObj?.isNotEmpty ??
            false) int reportId = viewModel.reportObjList.first?.id;
        // int notifiId = viewModel.notificationObj.first.id;
        DateTime currentDate = DateTime.now();
        DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String formattedCurrent = formatter.format(currentDate);
        String formattedStart = formatter.format(startDate);
        DateTime fromDatefilter;
        DateTime toDatefilter;

        List notificationItem = [];
        viewModel.notificationObj.forEach((element) {
          notificationItem.add(element.title);
        });

        List reportType = [];
        List reportType2 = [];
        viewModel.reportObjList.forEach((element) {
          reportType.add(element.description);
        });

        List userList = [];
        viewModel.userList.forEach((element) {
          userList.add(element.name);
        });

        String selectedUser;
        NotificationStatisticsObject selectedNotifId;
        NotificationStatisticeUserList selectedUserId;
        NotificationStatisticeReportObject selectedReportId;
        bool isUserWise = false;

        viewModel.reportObjList.forEach((element) {
          if (element.description == "User wise") {
            element.userListNeeded = "Yes";
          }
        });
        Map<String, dynamic> headerList;
        BaseTheme style = BaseTheme.of(context);
        ThemeData themeData = ThemeProvider.of(context);
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        List childData;
        return NotificationStatisticsScreenBody(viewModel: viewModel);
      },
    );
  }
}

class NotificationStatisticsScreenBody extends StatefulWidget {
  final NotificationStatisticsViewModel viewModel;

  const NotificationStatisticsScreenBody({Key key, this.viewModel})
      : super(key: key);

  @override
  _NotificationStatisticsScreenBodyState createState() =>
      _NotificationStatisticsScreenBodyState();
}

class _NotificationStatisticsScreenBodyState
    extends State<NotificationStatisticsScreenBody> {
  ScrollController _scrollController = new ScrollController();
  bool _isLoading;
  int start = 0;
  int limit;
  bool isInitial = false;
  bool isReset = false;
  List<BCCModel> _searchResult = [];
  List<BCCModel> _userDetails = [];
  List analysisUsersList = [];
  TextEditingController searchController = TextEditingController();
  List<NotificationStatisticsDetailData> notistatsList;
  List<NotificationStatisticsDetailData> notistatsList2;
  List<NotificationStatisticsObject> notificationObj2;
  List<NotificationStatisticeReportObject> reportObjList2;
  List<NotificationStatisticeUserList> userList2;

  // String selectednotificationtype = "Payments Pending to Settle";
  String selectednotificationtype = "Payments Pending to Settle";
  String selectReportTy = "Transaction Wise";
  String voucher;
  String count;
  int bookAcctId;
  bool isInitialReport = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.viewModel.selectedCountType(null);
    selectReportTy = widget.viewModel.selectedReportType;
    selectednotificationtype = widget.viewModel.selectedNotifType;
    print("called initSate");
    start = 0;
    _isLoading = false;
    limit = 10;
    _loadItems(initLoad: true);
    _scrollController = ScrollController(
      initialScrollOffset: widget.viewModel?.scrollPosition ?? 0,
      keepScrollOffset: true,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (notistatsList.length <
            notistatsList2.first.totalrecords) if (!_isLoading) _loadItems();
      }
    });
  }

  _loadItems({bool initLoad = false}) async {
    NotificationStatisticsObject selectedNotifId;
    NotificationStatisticeUserList selectedUserId;
    AnalysisCodeModelItem selectedAnalysisUser;
    int selectedAnalysisUserId;
    String selectedReport;
    String selectedNotific;
    String selectedUser;
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedCurrent = formatter.format(currentDate);
    String formattedStart = formatter.format(startDate);
    DateTime fromDatefilter;
    DateTime toDatefilter;
    bool isAcctCleared = false;
    setState(() {
      print(_isLoading);
      _isLoading = true;
      if (initLoad) start = 0;
    });
    NotificationStatisticeReportObject selectedReportId;
    widget.viewModel.reportObjList.forEach((element) {
      if (element.description == selectedReport ??
          widget.viewModel.selectedReportType) {
        selectedReportId = element;
      }
    });
    widget.viewModel.notificationObj.forEach((element) {
      if (element.title == selectedNotific ??
          widget.viewModel.selectedNotifType) {
        selectedNotifId = element;
      }
    });
    if (selectedReport == "User wise") {
      widget.viewModel.userList.forEach((element) {
        if (element.name == selectedUser) {
          selectedUserId = element;
        }
      });
    }

    print("first func");
    print(isPressedAnalysisUser);
    if (widget.viewModel.count == null &&
        widget.viewModel.numberField != null) {
      BaseSnackBar.of(context).show("Please enter value for count");
    } else {
      print(widget.viewModel?.selectedAccountNameId ?? 0);
      await NotificationStatisticsRepository().getReportData(
          start: initLoad ? 0 : start += limit ?? 0,
          limit: limit,
          fromDate: widget?.viewModel?.selectedFromDate ??
              fromDatefilter?.toString()?.substring(0, 10) ??
              startDate.toString().substring(0, 10),
          toDate: widget?.viewModel?.selectedToDate ??
              toDatefilter?.toString()?.substring(0, 10) ??
              currentDate.toString().substring(0, 10),
          voucher: widget.viewModel.selectedReportType == "User wise"
              ? null
              : (widget.viewModel?.voucher?.isEmpty ?? false)
                  ? null
                  : widget?.viewModel?.voucher,
          count:
              widget?.viewModel?.count == "" ? null : widget?.viewModel?.count,
          numberFieldId: widget.viewModel.numberField == null
              ? null
              : widget.viewModel.numberField,
          sortByBccId: widget?.viewModel?.selectedSortBccId != null &&
                  (widget.viewModel.selectedReportType == "User wise" &&
                      widget.viewModel.sortType.code.contains("DATE"))
              ? null
              : widget.viewModel.selectedSortBccId == null
                  ? null
                  : widget?.viewModel?.selectedSortBccId,
          userId: widget?.viewModel?.selectedReportType == "User wise"
              ? widget?.viewModel?.selectedUser == ""
                  ? null
                  : widget.viewModel.selectedAnalysisCodeId
              : null,
          accountId: widget?.viewModel?.selectedNotifType ==
                  "Pending Bank Reconcilation"
              ? widget?.viewModel?.accountFlag == true &&
                      widget?.viewModel?.selectedAccountName == ""
                  ? null
                  : widget?.viewModel?.selectedAccountNameId
              : null,
          reportId: widget?.viewModel?.selectedReportType != null &&
                      widget?.viewModel?.selectedReportType?.isNotEmpty ??
                  false &&
                      widget?.viewModel?.reportObjList != null &&
                      widget?.viewModel?.reportObjList?.isNotEmpty ??
                  false
              ? widget?.viewModel?.reportObjList
                  ?.firstWhere(
                      (element) =>
                          element.description ==
                          widget?.viewModel?.selectedReportType,
                      orElse: () => widget?.viewModel?.reportObjList?.first)
                  ?.id
              : widget?.viewModel?.reportObjList?.first?.id ?? 1548,
          notifId: widget?.viewModel?.selectedNotifType != null
              ? widget?.viewModel?.notificationObj
                  ?.firstWhere((element) =>
                      element.title == widget?.viewModel?.selectedNotifType)
                  ?.id
              : widget.viewModel.notificationObj.first.id,
          onRequestSuccess: (result) {
            if (this.mounted) {
              setState(() {
                _isLoading = false;
                if (initLoad) {
                  notistatsList = result.notificationDetailData;
                  notistatsList2 = result.notificationDetailData;
                } else {
                  notistatsList.addAll(result.notificationDetailData);
                }
              });
            }
          },
          onRequestFailure: (error) {
            setState(() {
              notistatsList = [];
              _isLoading = false;
              start = null;
            });
          });
    }
  }

  TextEditingController voucherController;
  TextEditingController countController;

  @override
  void dispose() {
    voucherController.dispose();
    countController.dispose();
    super.dispose();
  }

  bool isPressed = false;
  bool isPressedUser = false;
  bool isPressedAnalysisUser = false;

  bool isAcctCleared = false;
  BCCModel selectedBCCmodel;

  BCCModel dropdownvalue;
  BCCModel _selectedValue;
  String selectedReport2;
  String typeReport;

  @override
  Widget build(BuildContext context) {
    _selectedValue = widget.viewModel.sortType;
    voucherController = TextEditingController(text: widget.viewModel.voucher);
    countController = TextEditingController(text: widget.viewModel.count);
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedCurrent = formatter.format(currentDate);
    String formattedStart = formatter.format(startDate);
    String selectedReport;
    DateTime fromDatefilter;
    DateTime toDatefilter;

    BCCModel selectedBCCmodel3;
    String voucher = widget.viewModel.voucher;
    String count = widget.viewModel.count;

    List<BCCModel> paidFromBank = widget.viewModel.voucherTypes
        .where((element) => element?.typebcccode?.contains("BANK"))
        .toList();
    List notificationItem = [];
    widget.viewModel.notificationObj.forEach((element) {
      notificationItem.add(element.title);
    });

    List<String> nameAnalysisUserList = [];

    analysisUsersList.forEach((element) {
      nameAnalysisUserList.add(element.name);
    });

    List reportType = [];
    List reportType2 = [];
    widget.viewModel.reportObjList.forEach((element) {
      reportType.add(element.description);
    });

    List userList = [];
    widget.viewModel.userList.forEach((element) {
      userList.add(element.name);
    });

    String selectedUser;
    NotificationStatisticsObject selectedNotifId;
    NotificationStatisticeUserList selectedUserId;
    NotificationStatisticeReportObject selectedReportId;
    bool isUserWise = false;

    widget.viewModel.reportObjList.forEach((element) {
      if (element.description == "User wise") {
        element.userListNeeded = "Yes";
      }
    });
    Map<String, dynamic> headerList;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List childData;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list_sharp),
        onPressed: () {
          print("33 $selectednotificationtype");
          print("33 $initialNotify+$initialReport");
          print("33 $initialNotify+$selectReportTy+$selectedReport2");
          print(
              "33 $initialNotify+$selectedReport+${widget.viewModel.selectedReportType}");
          if (isInitial == false &&
              selectednotificationtype == "Payments Pending to Settle" &&
              initialReport == "Transaction Wise") {
            isPendingToSettle = true;
          }

          widget.viewModel.selectedAnalysisCodeIdFunc(null);
          widget.viewModel.ResetingFilter();
          showDialog(
              context: context,
              builder: (context) {
                selectednotificationtype = "Payments Pending to Settle";

                String selectedNotific = "Payments Pending to Settle";
                String selectedNotific2;

                DateTime currentDate = DateTime.now();
                DateTime startDate =
                    DateTime(currentDate.year, currentDate.month, 1);
                DateFormat formatter = DateFormat('yyyy-MM-dd');
                String formattedCurrent = formatter.format(currentDate);
                String formattedStart = formatter.format(startDate);
                DateTime fromDatefilter;
                DateTime toDatefilter;
                String notific = widget.viewModel.selectedNotifType;
                typeReport = widget.viewModel.selectedReportType;
                AnalysisCodeModelItem selectedAnalysisUser;

                BCCModel selectedAccountName;
                BCCModel selectedBCCmodel2;
                int selectedAccountNameId;
                int selectedAnalysisUserId;
                List descFromNumberTypes = [];
                widget.viewModel.numberTypes.forEach((element) {
                  descFromNumberTypes.add(element.description);
                });
                return AlertDialog(
                    backgroundColor: themeData.primaryColor,
                    title: Text("Filtering Conditions"),
                    contentPadding: EdgeInsets.zero,
                    content: StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        bool isVoucherVisible = false;

                        selectedReport2 = selectedReport ??
                            widget.viewModel.selectedReportType;
                        String selectedNotif2 = selectedNotific ??
                            widget.viewModel.selectedNotifType;
                        widget.viewModel.ResetingFilter();

                        if (selectedNotif2 == "Payments Pending to Settle" &&
                            selectedReport2 == "Transaction wise") {
                          isVoucherVisible = true;
                        }

                        List<String> descPaidFromBank = [];
                        paidFromBank.forEach((element) {
                          descPaidFromBank.add(element.bookaccountname);
                        });
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BaseDatePicker(
                                        displayTitle: "From Date",
                                        isVector: true,
                                        icon: Icons.date_range,
                                        initialValue: DateTime?.parse(widget
                                                    .viewModel
                                                    ?.selectedFromDate ??
                                                startDate.toString()) ??
                                            startDate,
                                        onChanged: (val) {
                                          widget.viewModel.selectedFromDateFunc(
                                              val.toString().substring(0, 10));
                                          fromDatefilter = val;
                                        },
                                        onSaved: (val) {
                                          fromDatefilter = val;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BaseDatePicker(
                                        displayTitle: "To Date",
                                        isVector: true,
                                        icon: Icons.date_range,
                                        initialValue: DateTime?.parse(widget
                                                    .viewModel
                                                    ?.selectedToDate ??
                                                currentDate.toString()) ??
                                            currentDate,
                                        onChanged: (val) {
                                          widget.viewModel.selectedToDateFunc(
                                              val.toString().substring(0, 10));
                                          toDatefilter = val;
                                        },
                                        onSaved: (val) {
                                          toDatefilter = val;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BaseDialogField(
                                  displayTitle: "Notification Item",
                                  list: notificationItem,
                                  initialValue:
                                      notific ?? "Payments Pending to Settle",
                                  fieldBuilder: (selected) => Text(selected),
                                  listBuilder: (val, pos) => DocumentTypeTile(
                                      selected: true,
                                      title: val.toString(),
                                      onPressed: () {
                                        setState(() {
                                          selectedNotific2 = val;
                                          selectedNotific = val;
                                          selectedNotif2 = val;
                                        });
                                        selectedNotific = val;
                                        selectedNotific2 = val;
                                        selectedNotif2 = val;

                                        Navigator.pop(context, val);
                                      }),
                                  onChanged: (val) => {
                                    if (val != "Payments Pending to Settle")
                                      {
                                        setState(() {
                                          typeReport = "Transaction wise";
                                          widget.viewModel
                                              .seletectedReportTypeFunc(
                                                  typeReport);
                                          isInitialReport = true;
                                        })
                                      }
                                    else
                                      {
                                        setState(() {
                                          typeReport = "Transaction wise";
                                          widget.viewModel
                                              .seletectedReportTypeFunc(
                                                  typeReport);
                                          isInitialReport = false;
                                        })
                                      },
                                    if ((selectedNotific2 ?? initialNotify) ==
                                            "Payments Pending to Settle" &&
                                        (selectedReport2 ?? initialReport) ==
                                            "Transaction Wise")
                                      {
                                        setState(() {
                                          isPendingToSettle = true;
                                        })
                                      }
                                    else
                                      {
                                        setState(() {
                                          isPendingToSettle = false;
                                        })
                                      },
                                    print("nnt $selectedNotific2"),
                                    print("notif $notific"),
                                    print(selectedReport2.toString() +
                                        selectedReport.toString() +
                                        widget.viewModel.selectedReportType
                                            .toString() +
                                        "------------" +
                                        selectednotificationtype.toString() +
                                        selectedNotif2.toString() +
                                        selectedNotific2.toString() +
                                        selectedNotific.toString() +
                                        widget.viewModel.selectedNotifType
                                            .toString()),
                                    selectednotificationtype = val,
                                    selectedNotific2 = val,
                                    if (selectednotificationtype !=
                                        "Payments Pending to Settle")
                                      {
                                        setState(() {
                                          selectReportTy = "Transaction Wise";
                                          widget.viewModel
                                              .seletectedReportTypeFunc(
                                                  selectReportTy);
                                        }),
                                      }
                                    else
                                      {
                                        setState(() {}),
                                      },
                                    widget.viewModel
                                        .seletectedNotifTypeFunc(val),
                                    selectedReport = null,
                                    selectedReport2 = null,
                                    selectedNotific = val,
                                    selectedNotif2 = val,
                                  },
                                  onSaved: (val) => {
                                    setState(() {
                                      selectedNotific2 = val;
                                      val != "Payments Pending to Settle"
                                          ? selectedReport2 = "User wise"
                                          : selectedReport2 =
                                              "Transaction Wise";
                                      selectedNotif2 = val;

                                      selectedNotific = val;
                                    }),
                                    selectedNotific = val,
                                    selectedNotif2 = val,
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Visibility(
                                    visible: selectedNotific2 == null
                                        ? notific == null
                                            ? selectednotificationtype ==
                                                "Payments Pending to Settle"
                                            : notific ==
                                                "Payments Pending to Settle"
                                        : selectedNotific2 ==
                                            "Payments Pending to Settle",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BaseDialogField(
                                        displayTitle: "Report Type",
                                        list: reportType,
                                        initialValue:
                                            typeReport ?? "Transaction Wise",
                                        fieldBuilder: (selected) =>
                                            Text(selected),
                                        listBuilder: (val, pos) {
                                          return DocumentTypeTile(
                                              icon: Icons.work,
                                              selected: true,
                                              title: val.toString(),
                                              onPressed: () {
                                                Navigator.pop(context, val);
                                                setState(() {
                                                  selectedReport = val;
                                                  if (selectedReport ==
                                                      "Transaction Wise") {
                                                    typeReport =
                                                        "Transaction Wise";
                                                  } else {
                                                    typeReport = val;
                                                    if (val == "User wise") {
                                                      typeReport = "User wise";
                                                      isInitial = true;
                                                    } else {
                                                      isInitial = false;
                                                    }
                                                  }
                                                });
                                              });
                                        },
                                        onChanged: (val) => {
                                          if (val == "User wise")
                                            {
                                              setState(() {
                                                typeReport = "User wise";
                                                isInitial = true;
                                                isPendingToSettle = false;
                                              })
                                            }
                                          else
                                            {
                                              print(isInitial),
                                              setState(() {
                                                typeReport = "Transaction Wise";
                                                isInitial = false;
                                                isPendingToSettle = true;
                                              })
                                            },
                                          print(isInitial),
                                          print(isPendingToSettle),
                                          widget.viewModel
                                              .seletectedReportTypeFunc(val),
                                          selectedUser = "",
                                          selectedReport = val,
                                          clearPreviousSortTypeCall(setState),
                                          print("cleared sortBccid"),
                                          print(widget
                                              .viewModel.selectedSortBccId)
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            selectedUser = "";
                                            selectedReport = val;
                                            clearPreviousSortTypeCall(setState);
                                          });
                                        },
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Visibility(
                                    visible: selectedNotific2 == null
                                        ? notific == null
                                            ? selectednotificationtype !=
                                                "Payments Pending to Settle"
                                            : notific !=
                                                "Payments Pending to Settle"
                                        : selectedNotific2 !=
                                            "Payments Pending to Settle",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BaseDialogField(
                                        displayTitle: "Report Type",
                                        list: ["Transaction Wise"],
                                        initialValue: selectedReport ??
                                            "Transaction Wise",
                                        fieldBuilder: (selected) =>
                                            Text(selected),
                                        listBuilder: (val, pos) {
                                          return DocumentTypeTile(
                                              icon: Icons.work,
                                              selected: true,
                                              title: val.toString(),
                                              onPressed: () {
                                                Navigator.pop(context, val);
                                                setState(() {
                                                  selectedReport = val;
                                                });
                                              });
                                        },
                                        onChanged: (val) => {
                                          widget.viewModel
                                              .seletectedReportTypeFunc(val),
                                          selectedUser = "",
                                          selectedReport = val,
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            selectedUser = "";
                                            selectedReport = val;
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              Visibility(
                                visible: (selectednotificationtype ==
                                            "Payments Pending to Settle" ||
                                        widget.viewModel.selectedReportType ==
                                            "Payments Pending to Settle") &&
                                    typeReport == "User wise",
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      child: Icon(
                                        Icons.account_circle_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: AnalysisCodeLookupField(
                                          initialValue: isPressedAnalysisUser ==
                                                  true
                                              ? AnalysisCodeModelItem(
                                                      name: "") ??
                                                  selectedAnalysisUser
                                              : AnalysisCodeModelItem(
                                                      name: widget?.viewModel
                                                              ?.selectedUser ??
                                                          "") ??
                                                  selectedAnalysisUser,
                                          onChanged: (val) {
                                            selectedAnalysisUser = val;
                                            selectedAnalysisUserId = val.id;
                                            widget.viewModel
                                                .selectedAnalysisCodeIdFunc(
                                                    val.id);
                                            widget.viewModel
                                                .selectedUserFunc(val.name);
                                          },
                                          displayTitle: "User",
                                          isClear: true,
                                          onPressed: () {
                                            print("Hello");
                                            isPressedAnalysisUser = true;
                                            widget.viewModel
                                                .selectedAnalysisCodeIdFunc(
                                                    null);
                                            widget.viewModel.selectedUserFunc(
                                                selectedAnalysisUser?.name ??
                                                    "");
                                          },
                                          isEnabled: true,
                                          isVector: false,
                                          isBorder: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isVoucherVisible == false
                                    ? typeReport == "Transaction wise" &&
                                        selectednotificationtype ==
                                            "Payments Pending to Settle"
                                    : true,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: BaseTextField(
                                          controller: voucherController,
                                          displayTitle: "Voucher NO",
                                          onChanged: (val) {
                                            voucher = val;
                                            widget.viewModel
                                                .selectedvoucherNo(val);
                                            voucherController.text = val;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          iconSize: 20,
                                          color: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              isPressed = true;
                                              voucherController.clear();

                                              print(voucherController.text);
                                              voucher = voucherController.text;
                                            });

                                            widget.viewModel
                                                .selectedvoucherNo("");
                                          },
                                          icon: Icon(Icons.clear)),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: BaseTextField(
                                          isNumberField: true,
                                          controller: countController,
                                          displayTitle: "Count",
                                          onEditingCompleted: (val) {
                                            if (val.isNotEmpty) {
                                              alertRefreshCall(setState, val);
                                            }
                                          },
                                          onChanged: (val) {
                                            if (val.isNotEmpty) {
                                              countIsNotNull = true;
                                            }
                                            count = val;
                                            widget.viewModel.selectedCount(val);
                                            countController.text = val;
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 8.0, right: 8.0),
                                          child: DropdownSearch(
                                            mode: Mode.MENU,
                                            items: descFromNumberTypes,
                                            maxHeight: 100,
                                            selectedItem: isAcctCleared == true
                                                ? ""
                                                : widget
                                                        ?.viewModel
                                                        ?.numberFormatTypeCode
                                                        ?.description ??
                                                    "",
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeData
                                                              .accentColor)),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: SizedBox(
                                                  width: 10,
                                                  child: IconButton(
                                                    iconSize: 20,
                                                    icon: Icon(
                                                      Icons.clear,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        countIsNotNull = false;
                                                        numberTypeIsNotNull =
                                                            false;
                                                        widget.viewModel
                                                            .selectedCountType(
                                                                null);
                                                        isAcctCleared = true;

                                                        isPressed = true;
                                                        countController.clear();
                                                        // widget.viewModel
                                                        //     .selectedCountType();
                                                        widget.viewModel
                                                            .onChangeFormatCode(
                                                                BCCModel(
                                                                    description:
                                                                        "",
                                                                    name: ""));
                                                        widget.viewModel
                                                            .onChangeFormatCode(
                                                                null);
                                                        print(countController
                                                            .text);
                                                        widget.viewModel
                                                            .onClearAction();
                                                        count = countController
                                                            .text;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              fillColor: Colors.orange,
                                              labelStyle:
                                                  BaseTheme.of(context).body2,
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                              suffixStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            popupBackgroundColor:
                                                themeData.primaryColor,
                                            onChanged: (val) {
                                              numberTypeIsNotNull = true;

                                              isAcctCleared = false;
                                              dropdownvalue =
                                                  BCCModel(description: val);
                                              // alertRefreshCall3(setState, "");
                                              BCCModel selectedSort;
                                              selectedSort = widget
                                                  .viewModel.numberTypes
                                                  .firstWhere((element) =>
                                                      element.description ==
                                                      val);
                                              widget.viewModel
                                                  .selectedCountType(
                                                      selectedSort?.id);
                                              widget.viewModel
                                                  .onChangeFormatCode(
                                                      selectedSort);
                                              print(selectedSort?.id ?? 0);
                                            },
                                            dropdownButtonBuilder: (context) {
                                              return Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              );
                                            },
                                            onSaved: (val) {
                                              dropdownvalue = val;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedNotific2 == null
                                    ? notific == "Pending Bank Reconcilation"
                                    : selectedNotific2 ==
                                        "Pending Bank Reconcilation",
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      child: Icon(
                                        Icons.account_circle_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Theme(
                                        data: ThemeData(
                                          textTheme: TextTheme(
                                              subtitle1: BaseTheme.of(context)
                                                  .textfield),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: DropdownSearch(
                                            clearButtonBuilder: (context) {
                                              return;
                                            },
                                            mode: Mode.DIALOG,
                                            label: 'Account Name',
                                            items: descPaidFromBank,
                                            showSearchBox: true,
                                            selectedItem: isAcctCleared
                                                ? ""
                                                : widget.viewModel
                                                    .selectedAccountName,
                                            searchFieldProps: TextFieldProps(),
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeData
                                                              .accentColor)),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: IconButton(
                                                  iconSize: 20,
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isAcctCleared = true;
                                                      widget.viewModel
                                                          .selectedAccountNameFunc(
                                                              "");
                                                    });
                                                  },
                                                ),
                                              ),
                                              fillColor: Colors.orange,
                                              labelText: "Account Name",
                                              labelStyle:
                                                  BaseTheme.of(context).body2,
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                              suffixStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            popupBackgroundColor:
                                                themeData.primaryColor,
                                            showClearButton: false,
                                            onChanged: (selectedItem) {
                                              if (paidFromBank.isNotEmpty &&
                                                  paidFromBank != null) {
                                                int selectedId = paidFromBank
                                                    .firstWhere((element) =>
                                                        element
                                                            .bookaccountname ==
                                                        selectedItem)
                                                    .bookaccountid;
                                                selectedAccountName = BCCModel(
                                                    description: selectedItem);
                                                selectedAccountNameId =
                                                    selectedId;
                                                bookAcctId = selectedId;
                                                print(
                                                    "SelectedAccount Name$selectedAccountName");
                                                print(bookAcctId);
                                                print(
                                                    "SelectedAccount Nameid$selectedAccountNameId");
                                                widget.viewModel
                                                    .selectedAccountNameFunc(
                                                        selectedItem);
                                                widget.viewModel
                                                    .selectedAccountNameIdFunc(
                                                        selectedId);
                                              }
                                            },
                                            dropdownButtonBuilder: (context) {
                                              return Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              );
                                            },
                                            onSaved: (selectedItem) {
                                              int selectedId = paidFromBank
                                                  .firstWhere((element) =>
                                                      element.bookaccountname ==
                                                      selectedItem)
                                                  .id;
                                              selectedAccountName =
                                                  selectedItem;
                                              selectedAccountNameId =
                                                  selectedId;
                                              bookAcctId = selectedId;
                                              print(
                                                  "SelectedAccount Name$selectedAccountName");
                                              print(bookAcctId);
                                              print(
                                                  "SelectedAccount Nameid$selectedAccountNameId");
                                              widget.viewModel
                                                  .selectedAccountNameFunc(
                                                      selectedItem);
                                              widget.viewModel
                                                  .selectedAccountNameIdFunc(
                                                      selectedId);
                                            },
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: BaseRaisedButton(
                                    child: Text("Submit"),
                                    backgroundColor:
                                        themeData.scaffoldBackgroundColor,
                                    onPressed: () {
                                      print(isPressedAnalysisUser);
                                      if (isPressedAnalysisUser == true) {
                                        widget.viewModel
                                            .selectedAnalysisCodeIdFunc(null);
                                      }
                                      if (selectedAccountName == null) {
                                        widget.viewModel.accountFlagFunc(true);
                                      }
                                      if (selectedAccountName != null) {
                                        widget.viewModel.accountFlagFunc(false);
                                      }
                                      NotificationStatisticeReportObject
                                          selectedReportId;
                                      widget.viewModel.reportObjList
                                          .forEach((element) {
                                        if (element.description ==
                                                selectedReport ??
                                            widget
                                                .viewModel.selectedReportType) {
                                          selectedReportId = element;
                                        }
                                      });
                                      widget.viewModel.notificationObj
                                          .forEach((element) {
                                        if (element.title == selectedNotific ??
                                            widget
                                                .viewModel.selectedNotifType) {
                                          selectedNotifId = element;
                                        }
                                      });
                                      if (selectedReport == "User wise") {
                                        widget.viewModel.userList
                                            .forEach((element) {
                                          if (element.name == selectedUser) {
                                            selectedUserId = element;
                                          }
                                          // print(selectedUserId);
                                          return selectedUserId;
                                        });
                                      }
                                      // String message =
                                      //     widget.viewModel.validateBeforeSave();
                                      // if (message != null && message.isEmpty) {
                                      //   print("callred once");
                                      if ((widget?.viewModel?.count == null) &&
                                          widget.viewModel.numberField !=
                                              null) {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          backgroundColor:
                                              themeData.primaryColor,
                                          content: Text(
                                              "Please enter value for count"),
                                        ));
                                      } else {
                                        print(widget.viewModel
                                                ?.selectedAccountNameId ??
                                            0);
                                        widget.viewModel.getReportData(
                                            Voucher: widget.viewModel.selectedReportType ==
                                                    "User wise"
                                                ? null
                                                : widget?.viewModel?.voucher?.isEmpty ??
                                                        false
                                                    ? null
                                                    : widget
                                                        ?.viewModel?.voucher,
                                            SelectedCount:
                                                count == "" ? null : count,
                                            start: 0,
                                            limit: 10,
                                            fromDate: fromDatefilter
                                                    ?.toString()
                                                    ?.substring(0, 10) ??
                                                startDate
                                                    .toString()
                                                    .substring(0, 10),
                                            toDate: toDatefilter?.toString()?.substring(0, 10) ??
                                                currentDate
                                                    .toString()
                                                    .substring(0, 10),
                                            userId:
                                                selectedReport == "User wise"
                                                    ? widget.viewModel.selectedUser ==
                                                            ""
                                                        ? null
                                                        : widget.viewModel
                                                            .selectedAnalysisCodeId
                                                    : null,
                                            reportId: selectedReportId?.id != null
                                                ? selectedReportId?.id
                                                : widget.viewModel.reportObjList?.first.id,
                                            notifId: selectedNotifId?.id == null ? widget.viewModel.notificationObj?.first?.id : selectedNotifId?.id ?? 2,
                                            accountId: bookAcctId,
                                            sortBccId: widget?.viewModel?.selectedSortBccId != null && (widget.viewModel.selectedReportType == "User wise" && widget.viewModel.sortType.code.contains("DATE"))
                                                ? null
                                                : widget.viewModel.selectedSortBccId == null
                                                    ? null
                                                    : widget?.viewModel?.selectedSortBccId,
                                            numberField: widget.viewModel.numberField == null ? null : widget?.viewModel?.numberField);
                                        // voucherController.clear();
                                        // countController.clear();
                                        Navigator.of(context).pop();
                                      }
                                    }),
                              )
                            ],
                          ),
                        );
                      },
                    ));
              });
        },
      ),
      body: notistatsList != null && (notistatsList?.isNotEmpty ?? false)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RaisedButton(
                        color: themeData.primaryColor,
                        child: Text(
                          "Sort",
                          style: BaseTheme.of(context).bodyMedium,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          showModalBottomSheet<void>(
                              isDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'SORT BY',
                                                style: BaseTheme.of(context)
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.white70,
                                        ),
                                        Expanded(
                                          child: widget.viewModel
                                                      .selectedReportType ==
                                                  "User wise"
                                              ? ListView.builder(
                                                  // shrinkWrap: true,
                                                  itemCount: widget
                                                          .viewModel
                                                          ?.sortTypeForUserType
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    return ListTile(
                                                      horizontalTitleGap: 0,
                                                      leading: Radio<BCCModel>(
                                                        value: widget.viewModel
                                                                ?.sortTypeForUserType[
                                                            index],
                                                        groupValue:
                                                            _selectedValue ??
                                                                widget.viewModel
                                                                    .sortType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedValue =
                                                                value;
                                                            widget.viewModel
                                                                .saveSortType(
                                                                    value);
                                                            widget.viewModel
                                                                .sortByAction(
                                                                    value.id);
                                                          });
                                                          if (widget.viewModel
                                                                      .count ==
                                                                  null &&
                                                              widget.viewModel
                                                                      .numberField !=
                                                                  null) {
                                                            BaseSnackBar.of(
                                                                    context)
                                                                .show(
                                                                    "Please enter value for count");
                                                          } else {
                                                            print(widget
                                                                    .viewModel
                                                                    ?.selectedAccountNameId ??
                                                                0);
                                                            widget.viewModel
                                                                .getReportData(
                                                              Voucher: widget
                                                                          .viewModel
                                                                          .selectedReportType ==
                                                                      "User wise"
                                                                  ? null
                                                                  : widget
                                                                      ?.viewModel
                                                                      ?.voucher,
                                                              SelectedCount:
                                                                  widget
                                                                      .viewModel
                                                                      .count,
                                                              start: 0,
                                                              limit: 10,
                                                              fromDate: widget
                                                                      .viewModel
                                                                      .selectedFromDate
                                                                      ?.toString()
                                                                      ?.substring(
                                                                          0,
                                                                          10) ??
                                                                  startDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                              toDate: widget
                                                                      .viewModel
                                                                      .selectedToDate
                                                                      ?.toString()
                                                                      ?.substring(
                                                                          0,
                                                                          10) ??
                                                                  currentDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                              userId: widget
                                                                          .viewModel
                                                                          .selectedUser ==
                                                                      ""
                                                                  ? null
                                                                  : widget
                                                                      .viewModel
                                                                      .selectedAnalysisCodeId,
                                                              reportId: selectedReportId
                                                                          ?.id !=
                                                                      null
                                                                  ? selectedReportId
                                                                      ?.id
                                                                  : widget
                                                                      .viewModel
                                                                      .reportObjList
                                                                      ?.first
                                                                      .id,
                                                              notifId: selectedNotifId
                                                                          ?.id ==
                                                                      null
                                                                  ? widget
                                                                      .viewModel
                                                                      .notificationObj
                                                                      ?.first
                                                                      ?.id
                                                                  : selectedNotifId
                                                                          ?.id ??
                                                                      2,
                                                              accountId:
                                                                  bookAcctId,
                                                              numberField: widget
                                                                          .viewModel
                                                                          .numberField ==
                                                                      null
                                                                  ? null
                                                                  : widget
                                                                      ?.viewModel
                                                                      ?.numberField,
                                                              sortBccId: widget
                                                                              ?.viewModel
                                                                              ?.selectedSortBccId !=
                                                                          null &&
                                                                      (widget.viewModel.selectedReportType ==
                                                                              "User wise" &&
                                                                          widget
                                                                              .viewModel
                                                                              .sortType
                                                                              .code
                                                                              .contains(
                                                                                  "DATE"))
                                                                  ? null
                                                                  : widget.viewModel
                                                                              .selectedSortBccId ==
                                                                          null
                                                                      ? null
                                                                      : widget
                                                                          ?.viewModel
                                                                          ?.selectedSortBccId,
                                                              // widget?.viewModel?.selectedSortBccId ==null?null:widget
                                                              //     .viewModel.selectedSortBccId
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                            print("nenu");
                                                            print(_selectedValue
                                                                .id);
                                                          }
                                                        },
                                                      ),
                                                      title: Text(
                                                        widget
                                                                .viewModel
                                                                ?.sortTypeForUserType[
                                                                    index]
                                                                ?.description ??
                                                            "",
                                                        style: BaseTheme.of(
                                                                context)
                                                            .bodyMedium,
                                                      ),
                                                    );
                                                  })
                                              : ListView.builder(
                                                  // shrinkWrap: true,
                                                  itemCount: widget
                                                          .viewModel
                                                          ?.sortingTypes
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    return ListTile(
                                                      horizontalTitleGap: 0,
                                                      leading: Radio<BCCModel>(
                                                        value: widget.viewModel
                                                                ?.sortingTypes[
                                                            index],
                                                        groupValue:
                                                            _selectedValue ??
                                                                widget.viewModel
                                                                    .sortType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedValue =
                                                                value;
                                                            widget.viewModel
                                                                .saveSortType(
                                                                    value);
                                                            widget.viewModel
                                                                .sortByAction(
                                                                    value.id);
                                                          });

                                                          if ((widget?.viewModel
                                                                          ?.count ??
                                                                      null) ==
                                                                  null &&
                                                              widget.viewModel
                                                                      .numberField !=
                                                                  null) {
                                                            print("neenuW");
                                                            // Navigator.pop(
                                                            //     context);
                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              backgroundColor:
                                                                  themeData
                                                                      .primaryColor,
                                                              content: Text(
                                                                  "Please enter value for count"),
                                                            ));
                                                          } else {
                                                            print(widget
                                                                    .viewModel
                                                                    ?.selectedAccountNameId ??
                                                                0);
                                                            widget.viewModel
                                                                .getReportData(
                                                              Voucher: widget
                                                                          .viewModel
                                                                          .selectedReportType ==
                                                                      "User wise"
                                                                  ? null
                                                                  : (widget?.viewModel?.voucher
                                                                              ?.isEmpty ??
                                                                          false)
                                                                      ? null
                                                                      : widget
                                                                          ?.viewModel
                                                                          ?.voucher,
                                                              SelectedCount:
                                                                  widget
                                                                      .viewModel
                                                                      .count,
                                                              start: 0,
                                                              limit: 10,
                                                              fromDate: widget
                                                                      .viewModel
                                                                      .selectedFromDate
                                                                      ?.toString()
                                                                      ?.substring(
                                                                          0,
                                                                          10) ??
                                                                  startDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                              toDate: widget
                                                                      .viewModel
                                                                      .selectedToDate
                                                                      ?.toString()
                                                                      ?.substring(
                                                                          0,
                                                                          10) ??
                                                                  currentDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                              userId: widget
                                                                          .viewModel
                                                                          .selectedUser ==
                                                                      ""
                                                                  ? null
                                                                  : widget
                                                                      .viewModel
                                                                      .selectedAnalysisCodeId,
                                                              reportId: selectedReportId
                                                                          ?.id !=
                                                                      null
                                                                  ? selectedReportId
                                                                      ?.id
                                                                  : widget
                                                                      .viewModel
                                                                      .reportObjList
                                                                      ?.first
                                                                      .id,
                                                              notifId: selectedNotifId
                                                                          ?.id ==
                                                                      null
                                                                  ? widget
                                                                      .viewModel
                                                                      .notificationObj
                                                                      ?.first
                                                                      ?.id
                                                                  : selectedNotifId
                                                                          ?.id ??
                                                                      2,
                                                              accountId:
                                                                  bookAcctId,
                                                              numberField: widget
                                                                          .viewModel
                                                                          .numberField ==
                                                                      null
                                                                  ? null
                                                                  : widget
                                                                      ?.viewModel
                                                                      ?.numberField,
                                                              sortBccId: widget
                                                                              ?.viewModel
                                                                              ?.selectedSortBccId !=
                                                                          null &&
                                                                      (widget.viewModel.selectedReportType ==
                                                                              "User wise" &&
                                                                          widget
                                                                              .viewModel
                                                                              .sortType
                                                                              .code
                                                                              .contains(
                                                                                  "DATE"))
                                                                  ? null
                                                                  : widget.viewModel
                                                                              .selectedSortBccId ==
                                                                          null
                                                                      ? null
                                                                      : widget
                                                                          ?.viewModel
                                                                          ?.selectedSortBccId,
                                                            );
                                                            Navigator.pop(
                                                                context);

                                                            print(_selectedValue
                                                                ?.id);
                                                          }
                                                        },
                                                      ),
                                                      title: Text(
                                                        widget
                                                                .viewModel
                                                                ?.sortingTypes[
                                                                    index]
                                                                ?.description ??
                                                            "",
                                                        style: BaseTheme.of(
                                                                context)
                                                            .bodyMedium,
                                                      ),
                                                    );
                                                  }),
                                        ),
                                      ],
                                    ),
                                    color: themeData.primaryColor,
                                  );
                                });
                              });
                        },
                      ),
                    )),
                Expanded(
                  flex: (height / 14).toInt(),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _isLoading
                          ? notistatsList.length ?? 0
                          : notistatsList.length ?? 0,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        List listOfHeading = [];
                        List listOfValue = [];
                        List listOfChildHeading = [].toSet().toList();
                        List listOfChildValue = [];
                        Map<String, dynamic> childMap;
                        notistatsList[index].headerDtl.forEach((element) {
                          element.header.forEach((key, value) {
                            if (key == "headerdata") {
                              listOfHeading.add(value);
                            } else {
                              listOfValue.add(value);
                            }
                          });
                        });
                        childData = notistatsList[index].child.toList();
                        notistatsList[index].child.forEach((element) {
                          element
                              .map((e) => e['child'].forEach((ele) {
                                    var k = ele['childdata'];
                                    listOfChildHeading.add(k);
                                    var j = ele['valuedata'];
                                    listOfChildValue.add(j);
                                  }))
                              .toList();
                        });
                        List distictHeadings =
                            listOfChildHeading.toSet().toList();
                        List childDatas;

                        List lst = listOfChildValue;
                        var chunks = [];
                        int chunkSize = distictHeadings.length;
                        for (var i = 0; i < lst.length; i += chunkSize) {
                          chunks.add(lst.sublist(
                              i,
                              i + chunkSize > lst.length
                                  ? lst.length
                                  : i + chunkSize));
                        }
                        return (_isLoading == true &&
                                index == notistatsList?.length &&
                                notistatsList.length > 0)
                            ? Padding(
                                padding: EdgeInsets.all(8),
                                child: BaseLoadingSpinner())
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      4.0,
                                      4.0,
                                      4.0,
                                      4.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        BaseNavigate(
                                            context,
                                            NotificationStatisticsReportDetail(
                                              notistatsList:
                                                  notistatsList[index],
                                            ));
                                      },
                                      child: Card(
                                        color: themeData.primaryColor,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                4.0,
                                                0.0,
                                                4.0,
                                                8.0,
                                              ),
                                              child: ListView.builder(
                                                itemCount: listOfHeading.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8.0,
                                                                12.0,
                                                                8.0,
                                                                0.0),
                                                        child: Text(
                                                          listOfHeading[i] ??
                                                              "NA",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      // SizedBox(width: width * 0.1,),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                            8.0,
                                                            12.0,
                                                            8.0,
                                                            0.0,
                                                          ),
                                                          child: Text(
                                                            listOfValue[i] ??
                                                                "NA",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      }),
                ),
              ],
            )
          : Center(
              child: EmptyResultView(
              message: "No Data",
            )),
    );
  }

  alertRefreshCall(StateSetter setInnerState, String val) {
    print(countController.text);
    if (countController.text != null &&
        countController.text.isNotEmpty &&
        countController.text != " ") {
      setInnerState(() {
        isCountHasValue = true;
      });
    } else if ((widget.viewModel?.count?.length ?? 0) < 0) {
      setInnerState(() {
        print("ajsallllllllllllllllll");
        isCountHasValue = false;
        widget.viewModel.onClearAction();
      });
    } else {
      setInnerState(() {
        print("ajsallllllllllllllllllggggggggggggggggg");
        isCountHasValue = false;
        widget.viewModel.onClearAction();
      });
    }
  }

  clearPreviousSortTypeCall(
    StateSetter setInnerState,
  ) {
    if (widget.viewModel.selectedReportType == "User wise") {
      setInnerState(() {
        widget.viewModel.clearSortType();
      });
    }
  }
}

class AccountNameFilter extends StatefulWidget {
  final NotificationStatisticsViewModel viewModel;
  final BCCModel poppedData;

  const AccountNameFilter({
    Key key,
    this.viewModel,
    this.poppedData,
  }) : super(key: key);

  @override
  _AccountNameFilterState createState() => _AccountNameFilterState();
}

class _AccountNameFilterState extends State<AccountNameFilter> {
  List<BCCModel> _searchResult = [];
  List<BCCModel> _userDetails = [];
  TextEditingController searchController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _buildUsersList() {
      ThemeData themeData = ThemeProvider.of(context);
      List<BCCModel> paidFromBank = widget.viewModel.voucherTypes
          .where((element) => element?.typebcccode?.contains("BANK"))
          .toList();
      return new ListView.builder(
        itemCount: paidFromBank.length,
        itemBuilder: (context, index) {
          return new Card(
            color: themeData.primaryColor,
            child:
                // DocumentTypeTile(title:  paidFromBank[index].description,onPressed: ()=> Navigator.pop(context, paidFromBank[index])),
                new ListTile(
              onTap: () {
                Navigator.pop(context, paidFromBank[index]);
                widget.viewModel
                    .selectedAccountNameFunc(paidFromBank[index].description);
                print("Printed");
                // widget.poppedData=paidFromBank[index];
                print(paidFromBank[index]);
              },
              title: new Text(paidFromBank[index].description),
            ),
            margin: const EdgeInsets.all(0.0),
          );
        },
      );
    }

    Widget _buildSearchResults() {
      ThemeData themeData = ThemeProvider.of(context);
      return new ListView.builder(
        itemCount: _searchResult.length,
        itemBuilder: (context, i) {
          return new Card(
            color: themeData.primaryColor,
            child: new ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              title: new Text(_searchResult[i].description),
            ),
            margin: const EdgeInsets.all(0.0),
          );
        },
      );
    }

    onSearchTextChanged(String text) async {
      ThemeData themeData = ThemeProvider.of(context);
      List<BCCModel> paidFromBank = widget.viewModel.voucherTypes
          .where((element) => element?.typebcccode?.contains("BANK"))
          .toList();
      _userDetails = paidFromBank;
      _searchResult.clear();
      if (text?.isEmpty ?? false) {
        setState(() {});
        return;
      }

      _userDetails.forEach((userDetail) {
        if ((userDetail.description.toUpperCase().contains(text.toUpperCase())))
          _searchResult.add(userDetail);
      });
      setState(() {});
    }

    Widget _buildSearchBox() {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Card(
          child: new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              style: TextStyle(color: Colors.black),
              controller: searchController2,
              decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none),
              onChanged: onSearchTextChanged,
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.cancel),
              onPressed: () {
                searchController2.clear();
                onSearchTextChanged('');
              },
            ),
          ),
        ),
      );
    }

    Widget _buildBody() {
      return new Column(
        children: <Widget>[
          new Container(
              color: Theme.of(context).primaryColor, child: _buildSearchBox()),
          new Expanded(
              child:
                  _searchResult.length != 0 || searchController2.text.isNotEmpty
                      ? _buildSearchResults()
                      : _buildUsersList()),
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SafeArea(child: _buildBody()),
          )
        ],
      ),
    );
  }
}

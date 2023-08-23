import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:badges/badges.dart';
import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/res/navigation/app_routes.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/login/login_viewmodel.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_detail_listing.dart';
import 'package:redstars/src/widgets/screens/splash/splash.dart';

import '../../../../utility.dart';

class SavedCompanyListPage extends StatefulWidget {
  final List<LoginModel> data;
  const SavedCompanyListPage({Key key, this.data}) : super(key: key);

  @override
  _SavedCompanyListPageState createState() => _SavedCompanyListPageState();
}

class _SavedCompanyListPageState extends State<SavedCompanyListPage> {
  List<LoginModel> companyList = [];
  List<LoginModel> filtercompanyList = [];
  List<LoginModel> uniqueList = [];
  List<LoginModel> temp2 = [];
  int notificationCount;
  String doc_key;
  String IsCompanyInit;

  Future<void> getSavedCompanyDetails() async {
    final String musicsString = await BasePrefs.getString('CompanyList');
    final List<LoginModel> sharedPrefCompanyList =
        LoginModel.decode(musicsString);
    setState(() {
      companyList = sharedPrefCompanyList;
    });
    var seen = Set<String>();
    uniqueList =
        companyList.where((student) => seen.add(student.clientId)).toList();
    setState(() {});
    return companyList;
  }
  // @override
  // initState() {
  //   super.initState();
  //
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return BaseView<AppState, LoginViewModel>(
        onDispose: (store) async {
            print("Company List disposed.");
          await BasePrefs.setString(
              BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");
          // await BasePrefs.setString(BaseConstants.COMPANY_LIST_SCREEN, "");
        },
        init: (store, context) async {
          await BasePrefs.setString(
              BaseConstants.SCREEN_STATE_KEY, "COMPANY_LISTING");
          final String musicsString = await BasePrefs.getString('CompanyList');
          final List<LoginModel> sharedPrefCompanyList =
              LoginModel.decode(musicsString);
          setState(() {
            companyList = sharedPrefCompanyList;
          });
          void checkAndAddMessageListener() async {
            print("Company List Listener Function.");
            doc_key =
                await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";
            IsCompanyInit = await BasePrefs.getString('IsCompanyInit')??"";

            if (IsCompanyInit == "") {
                await BasePrefs.setString("IsCompanyInit", "true");
              print("Company List Listener Initilised");
              FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
                doc_key = await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";

                print(doc_key);

                if (doc_key == "COMPANY_LISTING") {
                  print("Company List Listener Calling.");
                  print("Company List Listener event. $event");

            if (event != null) {
              store.dispatch(
                  fetchNotificationCountFromDb(loginModel: companyList));
            }
              }
          });
            }
          }
          checkAndAddMessageListener();

          var seen = Set<String>();
          uniqueList = companyList
              .where((student) => seen.add(student.clientId))
              .toList();
          setState(() {});
          companyList;
          store.dispatch(fetchNotificationCountFromDb(loginModel: companyList));
        },
        converter: (store) => LoginViewModel.fromStore(store),
        builder: (context, viewModel) {
          if (viewModel.notificationCountList.length > 0 &&
              uniqueList.length > 0) {
            uniqueList.sort((a,b) => a.liveClientDetails.clientname.compareTo(b.liveClientDetails.clientname));
            uniqueList.forEach((element) {
              viewModel?.notificationCountList?.forEach((ele) {
                if (element.clientId == ele.clientid) {
                  element.count = ele.notificationcount;
                }
              });
            });
            uniqueList.sort((b, a) {
              if (b.count == null && a.count == null) {
                return 0;
              } else if (b.count == null) {
                return 1;
              } else if (a.count == null) {
                return -1;
              } else {
                return a.count.compareTo(b.count);
              }
            });
          }
          return Scaffold(
            backgroundColor: ThemeProvider.of(context).primaryColor,
            floatingActionButton: FloatingActionButton(
              backgroundColor:
                  ThemeProvider.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                await BasePrefs.setString("AutoLogin", "");
                String auto= await BasePrefs.getString("AutoLogin");
                await BasePrefs.setString("notifCompany", "");

                print("auto---------$auto");

                print("auto---------$auto");


                viewModel.onLogout();
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  BaseNavigate.fadeIn<void>(
                    const SplashPage(isColdStart: false),
                    name: AppRoutes.login,
                  ),
                  (Route<void> route) => false,
                );
              },
            ),
            body: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 5.0,
                    decoration: BoxDecoration(
                      color: ThemeProvider.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                  top: height * .03,
                                  left: width * 0.2,
                                  right: width * 0.25,
                                  child: Image(
                                      image: AppImages.logo,
                                      fit: BoxFit.scaleDown,
                                      height: height * 0.14,
                                      width: width * 0.49))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 15), //CTM0054-23
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeProvider.of(context)
                                    .scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            height: MediaQuery.of(context).size.height / 28,
                            width: MediaQuery.of(context).size.width - 15,
                            child: Row(
			    /* CTM0054-23 starts */
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
//                                SizedBox(
//                                  width: 65,
//                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                ),
                                ),
                                Text(
                                    "Please choose a company",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
				  /* CTM0054-23 ends */
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: uniqueList.isNotEmpty && uniqueList != null
                            ? Visibility(
                                visible: isBranchList,
                                child: ListView.builder(
                                  itemCount: uniqueList?.length ??
                                      0 ??
                                      widget.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print("branch flag  $isBranchList");
                                    bool hasCompaniesLoginFLag = false;
//                                    companyList.forEach((element) {
//                                      if (companyList[index].clientId ==
//                                          element.clientId) {
//                                        hasCompaniesLoginFLag = true;
//                                      }
//                                    });
//                                     viewModel.notificationCountList
//                                         .forEach((element) {
//                                       if (element.clientid ==
//                                           uniqueList[index].clientId) {
//                                         notificationCount =
//                                             element.notificationcount;
//                                         uniqueList[index].count =
//                                             element.notificationcount;
//                                       }
//                                       return notificationCount;
//                                     });
                                    return GestureDetector(
                                      onTap: () async{
                                        viewModel.moreDetails(uniqueList[index]);

                                        if (uniqueList[index].company.name ==
                                            null) {
                                          viewModel.login(LoginModel(
                                            userName:
                                                uniqueList[index].userName,
                                            password:
                                                uniqueList[index].password,
                                            clientId:
                                                uniqueList[index].clientId,
                                            userId: uniqueList[index].userId,
                                            liveClientDetails: uniqueList[index]
                                                .liveClientDetails,
                                          ));
                                        } else {
                                          viewModel.updateUniqueList(uniqueList[index]);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SavedCompanyDetailListPage(
                                                        client_id:
                                                            uniqueList[index]
                                                                .clientId,
                                                        uniqueList: uniqueList,
                                                        userId:
                                                            uniqueList[index]
                                                                .userId
                                                                .toString(),
                                                        onPressed:
                                                            getSavedCompanyDetails(),
                                                      ))).then(
                                              (value) => setState(() {}));
                                        }
                                      },
//                                      onLongPress: () async {
//                                        ThemeData themeData = ThemeProvider.of(
//                                            context); //RD2199-22
//                                        final String SharedCompanyString =
//                                            await BasePrefs.getString(
//                                                'CompanyList');
//                                        final List<LoginModel>
//                                            sharedPrefCompanyList =
//                                            LoginModel.decode(
//                                                SharedCompanyString);
//                                        showDialog(
//                                            context: context,
//                                            builder: (context) {
//                                              return AlertDialog(
//                                                backgroundColor: themeData
//                                                    .scaffoldBackgroundColor,
//                                                title: Text(
//                                                    "Are you sure you want to Delete this?"),
//                                                actions: [
//                                                  Row(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .spaceAround,
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
//                                                    children: [
//                                                      BaseRaisedButton(
//                                                          child: Row(
//                                                            children: [
//                                                              Text("Yes"),
//                                                            ],
//                                                          ),
//                                                          onPressed: () {
//                                                            sharedPrefCompanyList
//                                                                .removeWhere((element) =>
//                                                                    sharedPrefCompanyList[
//                                                                            index]
//                                                                        .clientId ==
//                                                                    element
//                                                                        .clientId);
//                                                            final String
//                                                                encodedData =
//                                                                LoginModel.encode(
//                                                                    sharedPrefCompanyList);
//                                                            BasePrefs.setString(
//                                                                'CompanyList',
//                                                                encodedData);
//                                                            getSavedCompanyDetails();
//                                                            Navigator.pop(
//                                                                context);
//                                                          }),
//                                                      BaseRaisedButton(
//                                                          child: Row(
//                                                            children: [
//                                                              Text("No"),
//                                                            ],
//                                                          ),
//                                                          onPressed: () {
//                                                            Navigator.pop(
//                                                                context);
//                                                          }),
//                                                    ],
//                                                  ),
//                                                ],
//                                              );
//                                            });
//                                        /* RD2199-22 ends */
//                                      },
                                        child: new Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color:
                                              themeData.scaffoldBackgroundColor,
                                          margin: EdgeInsets.all(10),
                                          child: new Row(
                                            children: <Widget>[
                                              //new Image.network(video[index]),
                                              new Padding(
                                                  padding:
                                                      new EdgeInsets.all(3.0)),

                                            /* RD2199-22 starts */

                                              Flexible(
                                                flex: 2,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                  decoration: BoxDecoration(
                                                      color: ThemeProvider.of(
                                                              context)
                                                          .scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                    child: Image(
                                                      image: uniqueList[index]
                                                                  ?.company
                                                                  ?.name ==
                                                              "Red Stars International Trading"
                                                          ? AppImages
                                                              .redstarLogo
                                                          : uniqueList[index]
                                                                      ?.company
                                                                      ?.name ==
                                                                  "Redawa Motors Industry Pvt. Ltd. CO."
                                                              ? AppImages
                                                                  .redawaLogo
                                                              : uniqueList[index]
                                                                          ?.company
                                                                          ?.name ==
                                                                      "BMET Energy Telecom Industry and Trade PLC"
                                                                  ? AppImages
                                                                      .bmetLogo
                                                                  : AppImages
                                                                      .logoWithoutTitle,
                                                      height: 65,
                                                    ),
                                                  ),
                                                ),
                                                  Visibility(
                                                      visible: uniqueList[index]
                                                              .count !=
                                                          null,
                                                      child: Positioned(
                                                        left: 4,
                                                        top: 4,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          margin:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                              ),
                                                          child: Center(
                                                            child: Text(
                                                              "${uniqueList[index].count ?? ""}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    (uniqueList[index]
                                                            ?.liveClientDetails
                                                                    ?.clientname ??
                                                                "")
                                                            ?.toUpperCase() ??
                                                        widget
                                                            ?.data[index]
                                                            ?.liveClientDetails
                                                            ?.clientname ??
                                                        "",
                                                    maxLines: 5,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                      color:
                                                          themeData.accentColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text("No Company is available, "
                                    "\nPlease Save to Continue...")))),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    SizedBox(
//                      width: 40,
//                    ),
//                    Text("Long press to delete company"),
//                  ],
//                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          );
        });
  }
}
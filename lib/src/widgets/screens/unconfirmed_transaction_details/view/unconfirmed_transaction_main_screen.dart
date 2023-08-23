import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:base/redux.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/view/unconfirmed_transaction_detail_screen.dart';

import '../../../../../utility.dart';
import 'package:redstars/src/constants/app_constants.dart';

class UnconfirmedTransactionMainScreen extends StatefulWidget {
  const UnconfirmedTransactionMainScreen({Key key}) : super(key: key);

  @override
  _UnconfirmedTransactionMainScreenState createState() =>
      _UnconfirmedTransactionMainScreenState();
}

class _UnconfirmedTransactionMainScreenState
    extends State<UnconfirmedTransactionMainScreen> {
  String doc_key;
  String isUnconfirmedInit;
  @override
  Widget build(BuildContext context) {
    BCCModel selectedSales;
    BCCModel selectedPVoucher;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    return BaseView<AppState, UnConfirmedTransactionDetailViewModel>(
        init: (store, context) async {
          await BasePrefs.setString(
              BaseConstants.SCREEN_STATE_KEY, "MOB_UNCFIRMD_TRNSCTION");
          final filter = store.state.unConfirmedTransactionDetailState;

          store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails(
              optionId: store.state.homeState.selectedOption.id));

          store.dispatch(fetchUnconfirmedTransactionListAction(
            filterModel: filter.unConfirmedFilterModel,
          ));
          void checkAndAddMessageListener() async {
            print("Unconfirmed Approval Listener Function.");
            doc_key =
                await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";
            isUnconfirmedInit =
                await BasePrefs.getString('isUnconfirmedInit') ?? "";

            if (isUnconfirmedInit == "") {
              await BasePrefs.setString("isUnconfirmedInit", "true");

              print("Unconfirmed Approval Listener Initilised");
              FirebaseMessaging.onMessage.listen((RemoteMessage event) async{
                doc_key =
                    await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ??
                    "";
                print(doc_key);

                if (doc_key == "MOB_UNCFIRMD_TRNSCTION") {
                  print("Unconfirmed Approval Listener Calling.");
                  print("Unconfirmed Approval Listener event. $event");

                  if (event != null) {
                    store.dispatch(
                        fetchInitialConfigUnConfirmedTransactionDetails(
                        optionId: store.state.homeState.selectedOption.id,
                            isFromNotify: true));

                    store.dispatch(fetchUnconfirmedTransactionListAction(
                        filterModel: filter.unConfirmedFilterModel,
                        isFromNotify: true));


                  }
                }
              });
            }
          }

          checkAndAddMessageListener();
        },
        onDispose: (store) async {
          store.dispatch(OnClearAction());
          await store.dispatch(UnconfirmedTransactionDetailClearAction(
              unConfirmedTransactionDetailSave: false));
          String clientId =
              await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
          int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
          store.dispatch(
              fetchNotificationCount(clientid: clientId, userid: userId));
          store.dispatch(UnconfirmedTransactionDetailClearAction(
              unConfirmedTransactionDetailSave: false));
          await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "HOME_SCREEN");
        },
        converter: (store) =>
            UnConfirmedTransactionDetailViewModel.fromStore(store),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: BaseAppBar(
              title: Text("Unconfirmed Transaction"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.transOptionTypes.length,
                      itemBuilder: (context, index) {
                        int count;
                        if (viewModel.notificationDetails != null) {
                          viewModel.notificationDetails.forEach((element) {
                            if (element.refoptionid ==
                                int.parse(
                                    viewModel.transOptionTypes[index].extra)) {
                              count = element.notificationcount;
                            }
                          });
                        } else {
                          print("No Notification Detail");
                        }
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UnConfirmedTransactionScreen(
                                        unconfirmedViewModel: viewModel,
                                        selectedOption:
                                            viewModel.transOptionTypes[index],
                                      ))),
                          child: Container(
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: themeData.primaryColor),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 18),
                                                  child:Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      _CircleAvatar(
                                                        icon: Icons.description,
                                                      ),
                                                      Positioned(
                                                        left: -5,
                                                        top: -8,
                                                        child: Visibility(
                                                            visible:
                                                                (count ?? 0) >
                                                                    0,
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              margin: EdgeInsets
                                                                  .all(2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                      "$count",
                                                      style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                    ),
                                                  ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 30,
                                                  child: Text(
                                                    viewModel
                                                        .transOptionTypes[index]
                                                        .description,
                                                    style: theme.subhead1
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 18),
                                                  child: Text(
                                                    "",
                                                    style: theme.subhead1
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )))),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}

class _CircleAvatar extends StatelessWidget {
  final IconData icon;

  const _CircleAvatar({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: ThemeProvider.of(context).primaryColorDark,
        radius: 24,
        child: Icon(
          icon,
          color: Colors.white,
        ));
  }
}

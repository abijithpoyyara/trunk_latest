import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/src/services/model/response/client_info.dart';
import 'package:base/src/services/model/response/live_client_details.dart';
import 'package:base/src/widgets/screens/homepage/_home.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';

class ChangeScreenStateAction {
  final ScreenState type;

  ChangeScreenStateAction(this.type);
}

class SignInAction {
  SignInAction(this.request);

  final LoginModel request;
}

class UpdateUniqueListAction {
  final LoginModel unique;
  UpdateUniqueListAction(this.unique);
}

class SignInFailedAction {
  final Exception errorMessage;

  SignInFailedAction(this.errorMessage);
}

class SignInSuccessAction {
  User user;

  SignInSuccessAction(this.user);
}

class BusinessLevelFetchAction {
  final ClientDetails client;

  BusinessLevelFetchAction(this.client);
}

class ClientInfoSuccessAction {
  final ClientInfo client;

  ClientInfoSuccessAction(this.client);
}

class SaveTokenAction {
  final String token;

  SaveTokenAction(this.token);
}

class CheckTokenAction {
  final Function(LoginModel) hasTokenCallback;
  final Function() noTokenCallback;

  CheckTokenAction({this.hasTokenCallback, this.noTokenCallback});
}

class LiveClientDetailsFetchSuccessAction {
  final List<LiveClientDetails> liveClientDetails;
  LiveClientDetailsFetchSuccessAction(this.liveClientDetails);
}

class NotificationCountFromDbFetchAction {
  final List<NotificationCountFromDbList> notificationCount;
  NotificationCountFromDbFetchAction(this.notificationCount);
}

class GetNotificationCountOfBranch{
  final List<NotificationCountDetails> notificationCount;
  GetNotificationCountOfBranch(this.notificationCount);
}

class ResetIsExpandedAction {
  ResetIsExpandedAction();
}

class callInitialScreen {}

class OnLogoutAction {}

ThunkAction onLogoutAction() {
  return (Store store) async {
    store.dispatch(OnLogoutAction());

    new Future(() async {
      FirebaseNotificationHelper _firebase = FirebaseNotificationHelper();
      (await _firebase.getSubscribedTopics()).forEach((element) {
        print("topics : $element");
      });
      _firebase.unsubscribeTopics(await _firebase.getSubscribedTopics());

      await BasePrefs.setString(BaseConstants.SSNIDN_KEY, "");
      await BasePrefs.setString(BaseConstants.USERNAME_KEY, "");
      await BasePrefs.setString(BaseConstants.PASSWORD_KEY, "");
      await BasePrefs.setString(BaseConstants.CLIENTID_KEY, "");
      await BasePrefs.setString(BaseConstants.TOKEN, "");
    });
  };
}

ThunkAction authenticateUser(LoginModel loginModel,
    [Function(User) onLoginSuccess]) {
  return (Store store) async {
    new Future(() async {
      print("Started Authenticating");
      store.dispatch(SignInAction(loginModel));
      store.dispatch(ChangeScreenStateAction(ScreenState.WELCOME));
      BaseUserRepository().login(loginModel,
          onLoginFailure: (exception) =>
              store.dispatch(new SignInFailedAction(exception)),
          onLoginSuccess: (user) => {
                store.dispatch(new SignInSuccessAction(user)),
                if (onLoginSuccess != null)
                  onLoginSuccess(user)
                else
                  Keys.navKey.currentState.pushAndRemoveUntil<void>(
                      BasePageRoute.fadeIn<void>(HomePage()),
                      (Route<void> route) => false)
              });
    });
  };
}

/* RD2199-22 starts */
ThunkAction initialAuthenticate(LoginModel loginModel,
    [Function(User) onLoginSuccess]) {
  return (Store store) async {
    new Future(() async {
      print("Started Authenticating");
      store.dispatch(SignInAction(loginModel));
      store.dispatch(ChangeScreenStateAction(ScreenState.WELCOME));
      BaseUserRepository().login(loginModel,
          onLoginFailure: (exception) =>
              store.dispatch(new SignInFailedAction(exception)),
          onLoginSuccess: (user) => {
                store.dispatch(getMoreDetails(loginModel)),
                store.dispatch(new SignInSuccessAction(user)),
                if (onLoginSuccess != null) onLoginSuccess(user)
                // else
                //   Keys.navKey.currentState.pushAndRemoveUntil<void>(
                //       BasePageRoute.fadeIn<void>(HomePage()),
                //       (Route<void> route) => false)
              });
    });
  };
}

/* RD2199-22 ends */
ThunkAction getMoreDetails(LoginModel loginModel) {
  return (Store store) async {
    Future(() async {
      store.dispatch(SignInAction(loginModel));
//      store.dispatch(LoadingAction(status: LoadingStatus.loading, message: ""));
      BaseUserRepository().getBusinessLevels(
        username: loginModel.userName,
        password: loginModel.password,
        clientId: loginModel.clientId,
        onRequestFailure: (exception) =>
            store.dispatch(SignInFailedAction(exception)),
        onRequestSuccess: (levels) =>
            store.dispatch(BusinessLevelFetchAction(levels)),
      );
    });
  };
}

ThunkAction getClientInfo() {
  return (Store store) async {
    store.dispatch(LoadingAction(status: LoadingStatus.loading, message: ""));
    new Future(() async {
      ClientInfo client = await BaseUserRepository().getClientIfo();
      store.dispatch(ClientInfoSuccessAction(client));
    });
  };
}

ThunkAction fetchNotificationCountFromDb({List<LoginModel> loginModel}) {
  return (Store store) async {
    new Future(() async {
      //  store.dispatch(
      // new LoadingAction(status: LoadingStatus.loading, message: "Loading"));
      BaseUserRepository().getNotificationCountFromDb(
          loginModel: loginModel,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new NotificationCountFromDbFetchAction(response)));
    });
  };
}


//ThunkAction fetchNotificationCountOfBranch({List<LoginModel> loginModel}) {
//  return (Store store) async {
//    new Future(() async {
      // store.dispatch(
      //new LoadingAction(status: LoadingStatus.loading, message: "Loading"));
//      BaseUserRepository().getNotificationCountOfBranch(
//          loginModel: loginModel,
//          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
//              status: LoadingStatus.error, message: exception.toString())),
//          onRequestSuccess: (response) =>
//              store.dispatch(new GetNotificationCountOfBranch(response)));
//    print("done");
//    });
//  };
//}


ThunkAction fetchLiveClientList() {
  return (Store store) async {
    new Future(() async {
      BaseUserRepository().getLiveClientDetails(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) => store
              .dispatch(new LiveClientDetailsFetchSuccessAction(response)));
    });
  };
}

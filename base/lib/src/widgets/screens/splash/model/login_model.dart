import 'dart:convert';

import 'package:base/services.dart';

class LoginModel {
  String userName;
  String password;
  String clientId;
  String userId;
  ClientLevelDetails company;
  ClientLevelDetails branch;
  ClientLevelDetails location;
  LiveClientDetails liveClientDetails;
  int count;

  LoginModel({
    this.userName = "",
    this.password = "",
    this.clientId = "",
    this.userId,
    this.liveClientDetails,
    this.company,
    this.branch,
    this.location,
    this.count,
  });

  LoginModel merge(LoginModel copy) {
    return LoginModel(
        userName: this.userName ?? copy.userName,
        password: this.password ?? copy.password,
        clientId: this.clientId ?? copy.clientId,
        company: this.company ?? copy?.company,
        branch: this.branch ?? copy?.branch,
        location: this.location ?? copy?.location,
        liveClientDetails: this.liveClientDetails ?? copy.liveClientDetails,
        userId: this.userId ?? copy.userId,
   );
  }

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    return LoginModel(
        userName: jsonData['userName'],
        password: jsonData['password'],
        clientId: jsonData['clientId'],
        company: ClientLevelDetails.fromJson(jsonData['company']),
        location: ClientLevelDetails.fromJson(jsonData['location']),
        branch: ClientLevelDetails.fromJson(jsonData['branch']),
        liveClientDetails:
            LiveClientDetails.fromJson(jsonData['liveClientDetails']),
        userId: jsonData['userId'].toString());
  }

  static Map<String, dynamic> toMap(LoginModel LoginModel) => {
        'userName': LoginModel.userName,
        'password': LoginModel.password,
        'clientId': LoginModel.clientId,
        'company': LoginModel.company,
        'branch': LoginModel.branch,
        'location': LoginModel.location,
        'liveClientDetails': LoginModel.liveClientDetails,
        'userId': LoginModel.userId
      };

  static String encode(List<LoginModel> loginModel) => json.encode(
        loginModel
            .map<Map<String, dynamic>>((music) => LoginModel.toMap(music))
            .toList(),
      );

  static List<LoginModel> decode(String loginModel) =>
      (json.decode(loginModel) as List<dynamic>)
          .map<LoginModel>((item) => LoginModel.fromJson(item))
          .toList();
}

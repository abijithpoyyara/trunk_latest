import 'package:base/services.dart';

class User {
  String userName;
  String companyName;
  String companyLocation;
  String locationName;
  int userId;
  List<ModuleListModel> moduleList;
  List<BusinessLevelModel> businessLevelModel;
  User(
      {this.userName,
      this.companyName,
      this.companyLocation,
      this.locationName,
      this.moduleList,
      this.businessLevelModel,
      this.userId});
}

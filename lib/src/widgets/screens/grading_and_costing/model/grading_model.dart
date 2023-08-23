import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';

class GradingModel {
  List<GradeLookupItem> gradeLookupItem;
  double qty;
  double rate;
  double total;
  GradeLookupItem gradeLookupData;
  List<ProcessFillGradingList> gradingList;
  ProcessFillGradingList listData;
  DateTime date;

  GradingModel({
    this.gradingList,
    this.gradeLookupData,
    this.gradeLookupItem,
    this.listData,
    this.date,
  });
}

class GradeModel {
  double qty;
  double rate;
  double total;
  GradeLookupItem gradeLookupData;
  GradeModel({this.qty, this.gradeLookupData, this.rate, this.total});
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is GradeModel &&
  //         runtimeType == other.runtimeType &&
  //         gradeLookupData.name == other.gradeLookupData.name &&
  //         rate == other.rate;
  // @override
  // int get hashCode => gradeLookupData.hashCode;
}

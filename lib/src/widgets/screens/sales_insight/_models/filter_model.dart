import 'package:base/utility.dart';

class SaleInsightFilterModel {
  DateTime fromDate;
  DateTime toDate;
  bool isMargin;
  bool isMajorCategory;

  SaleInsightFilterModel(
      {this.fromDate, this.toDate, this.isMargin, this.isMajorCategory});

  @override
  String toString() {
    return "   fromDate : ${BaseDates(fromDate).format}" +
        "   toDate : ${BaseDates(toDate).format}" +
        "   isMargin : $isMargin" +
        "   isMajorCategory : $isMajorCategory";
  }
}

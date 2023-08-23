import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

class ItemRateGradeModel {
  ItemLookupItem item;
  double qty;
  double rate;
  GradeLookupItem grade;
  int itemDtlId;

  ItemRateGradeModel(
      {this.item, this.qty, this.rate, this.grade, this.itemDtlId});
}

import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

class ItemGradeRateSubModel extends ItemRateGradeModel {
  ItemGradeRateSubModel({
    ItemLookupItem item,
    double rate,
    GradeLookupItem grade,
    int itemDtlDataId,
  }) : super(item: item, rate: rate, grade: grade, itemDtlId: itemDtlDataId);

  factory ItemGradeRateSubModel.fromRequisitionModel(ItemRateGradeModel model) {
    return ItemGradeRateSubModel(
        item: model.item,
        rate: model.rate,
        grade: model.grade,
        itemDtlDataId: model.itemDtlId);
  }

  ItemGradeRateSubModel merge(ItemGradeRateSubModel model) {
    return ItemGradeRateSubModel(
        item: model.item ?? item,
        rate: model.rate ?? rate,
        grade: model.grade ?? grade,
        itemDtlDataId: model.itemDtlId ?? itemDtlId);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is ItemGradeRateSubModel &&
            runtimeType == other.runtimeType &&
            item == other.item &&
            grade == other.grade;
  }

  @override
  int get hashCode => item.hashCode ^ grade.hashCode;
}

import 'package:base/utility.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';

class SEMISBranchModel {
  String branchName;
  List<MisEnquiryDtl> enquiryDetails;
  Map<String, List<MisEnquiryDtl>> statuses;
  List<MisEnquiryDtl> approved;
  List<MisEnquiryDtl> pending;

  SEMISBranchModel(this.branchName, this.enquiryDetails) {
    statuses = enquiryDetails?.groupBy<String>((model) => model.status);

    // if (!statuses.containsKey("APPROVED")) {
    //   statuses["APPROVED"] = [];
    // }
    // if (!statuses.containsKey("PENDING")) {
    //   statuses["PENDING"] = [];
    // }
    // if (!statuses.containsKey("REJECTED")) {
    //   statuses["REJECTED"] = [];
    // }
  }
}

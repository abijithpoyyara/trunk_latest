import 'package:base/redux.dart';
import 'package:base/src/redux/actions/scan_actions.dart';
import 'package:base/src/services/model/response/scanner_model.dart';

class ScanMiddleware extends MiddlewareClass<BaseAppState> {
  @override
  call(Store<BaseAppState> store, action, next) {
    if (action is ConfigFetchSuccessAction) {
      var optionId = store.state.scanState?.optionDetail?.optionId?? 50;
      DocOption option = action.options.firstWhere(
          (element) {
            print("${element.documentsattachedoptionid} == $optionId");
            return element.documentsattachedoptionid == optionId;},
          orElse: () => null);
      print("$optionId called "+  option.toString());
      if (option != null) {
        List<String> callDtl = option.dropdowncall.split(',');
        store.dispatch(fetchDocumentTypes(
          procName: callDtl.first,
          actionFlag: callDtl[1],
          subActionFlag: callDtl.last,
          mappingId: option.id,
        ));
      }
    }
    next(action);
  }
}

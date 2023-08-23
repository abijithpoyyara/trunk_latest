import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/services/model/response/scanner_model.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';

class ScanRepository extends BaseRepository {
  static final ScanRepository _instance = ScanRepository._();

  ScanRepository._();

  factory ScanRepository() => _instance;

  void getFileFormats(
      {@required
          Function(List<FileFormatsModel>, List<DocOption>) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) {
    String url = "/security/controller/cmn/getdropdownlist";

    String fileFormatsXml = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "FILE_FORMATS_TO_UPLOAD")
        .buildElement();
    String optionMappingXml = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "DROPDOWN")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "BAYACONTROLCODES-DROPDOWN",
          procName: "bayacontrolcodelistproc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: fileFormatsXml,
          key: "fileFormats",
        )
        .addParams(
          list: "EXEC-PROC",
          procName: "TransactionDocAttachmentOptionsListProc",
          actionFlag: "LIST",
          subActionFlag: "OPTIONDOCMAPPING",
          xmlStr: optionMappingXml,
          key: "optionList",
        )
        .callReq();
    String service = "getdata";
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          ScannerConfigModel responseJson = ScannerConfigModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.fileFormats, responseJson.options);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void getDocumentTypes(
      {String procName,
      String actionFlag,
      String subActionFlag,
      int mappingId,
      @required Function(List<DocumentTypes> documentTypes) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(BaseConstants.SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    String service = "getdata";
    String url = "/security/controller/cmn/getdropdownlist";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DocMappingId", value: mappingId.toString())
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: procName,
          actionFlag: actionFlag,
          subActionFlag: "OPTIONDOCMAPPING",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          DocumentTypeModel responseJson = DocumentTypeModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            var documentTypes = responseJson.documentTypes;
            documentTypes.sort((a, b) => (a.sortOrder > b.sortOrder) ? 1 : -1);
            onRequestSuccess(documentTypes);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void generateXML(
    List<ItemAttachmentModel> attachments,
    DocOption docOption,
    int fileTypeBccId,
    ValueSetter<String> onSuccess,
  ) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String xml = "";
    attachments.forEach((attachment) {
      XMLBuilder builder = XMLBuilder(tag: "Insert")
          .addElement(key: "TransDocAttchId", value: "0")
          .addElement(
              key: "DocOptionTableId",
              value: '${attachment.documentType.tableId}')
          .addElement(
              key: "DocOptionTableDataId",
              value: '${attachment.documentType.id}')
          .addElement(key: "RefTableId", value: "**reftableid**")
          .addElement(key: "RefTableDataId", value: "**reftabledataid**")
          .addElement(key: "RefOptionId", value: "**refoptionid**")
          .addElement(key: "RefTransNo", value: "**reftransno**")
          .addElement(key: "RefTransDate", value: "**reftransdate**")
          .addElement(
              key: "DocumentId", value: '${attachment.documentType.documentId}')
          .addElement(key: "DocumentNo", value: '${attachment.docNo}')
          .addElement(
              key: "DocumentDate",
              value: '${BaseDates(attachment.docDate).dbformat}')
          .addElement(key: "TempMappingId", value: "${attachment.mappingId}")
          .addElement(
              key: "TempMappingParentId",
              value: "${attachment.mainDoc?.mappingId ?? 0}");
      if (attachment.mainDoc != null) {
        builder
            .addElement(
                key: "ParentDocRefTableId",
                value: "${attachment.mainDoc.documentType.tableId}")
            .addElement(
                key: "ParentDocRefTableDataId",
                value: "${attachment.mainDoc.documentType.id}");
      }
      builder
          .addElement(key: "isactiveyn", value: "Y")
          .addElement(key: "CreatedUserId", value: "${userId}")
          .addElement(key: "LastModUserId", value: "${userId}");

      xml += builder.buildElement();
      attachment.uploadedImages.forEach((element) {
        xml += XMLBuilder(tag: "Attachment")
            .addElement(key: "TempMappingId", value: "${attachment.mappingId}")
            .addElement(
                key: "attachmentoriginalname", value: element.data.filename)
            .addElement(
                key: "attachmentphysicalname",
                value: element.data.filephysicalname)
            .addElement(key: "filetypebccid", value: "$fileTypeBccId")
            .addElement(key: "LastModUserId", value: "${userId}")
            .buildElement();
      });
    });
    onSuccess(xml);
  }

  var s = {
    "docAttachReqYN": true,
    "docAttachXml": "<Insert "
        "TransDocAttchId = \"0\" "
        "DocOptionTableId\t = \"1080\" "
        "DocOptionTableDataId\t = \"32\" "
        "RefTableId\t = \"**reftableid**\" "
        "RefTableDataId\t = \"**reftabledataid**\" "
        "RefOptionId\t = \"**refoptionid**\" "
        "RefTransNo\t = \"**reftransno**\" "
        "RefTransDate\t = \"**reftransdate**\" "
        "DocumentId\t = \"16\" "
        "DocumentNo\t = \"COO01\" "
        "DocumentDate\t = \"20-08-2020\" "
        "TempMappingId\t = \"2\" "
        "TempMappingParentId\t = \"0\" "
        "ParentDocRefTableId\t = \"1080\" "
        "ParentDocRefTableDataId\t = \"1\" "
        "isactiveyn = \"Y\" "
        "CreatedUserId\t = \"1\" "
        "LastModUserId\t= \"1\">"
        "</Insert>"
        "<Attachment "
        "TempMappingId\t = \"2\" "
        "attachmentoriginalname = \"team.PNG\" "
        "attachmentphysicalname = \"ThuAug20145053IST2020-team.png\" "
        "filetypebccid\t   = \"173\">"
        "</Attachment>"
        "<Insert "
        "TransDocAttchId = \"0\" "
        "DocOptionTableId\t = \"1080\" "
        "DocOptionTableDataId\t = \"6\" "
        "RefTableId\t = \"**reftableid**\" "
        "RefTableDataId\t = \"**reftabledataid**\" "
        "RefOptionId\t = \"**refoptionid**\" "
        "RefTransNo\t = \"**reftransno**\" "
        "RefTransDate\t = \"**reftransdate**\" "
        "DocumentId\t = \"6\" "
        "DocumentNo\t = \"GD01\" "
        "DocumentDate\t = \"20-08-2020\" "
        "TempMappingId\t = \"1\" "
        "TempMappingParentId\t = \"0\" "
        "isactiveyn = \"Y\" "
        "CreatedUserId\t = \"1\" "
        "LastModUserId\t= \"1\">"
        "</Insert>"
        "<Attachment "
        "TempMappingId\t = \"1\" "
        "attachmentoriginalname = \"team.PNG\" "
        "attachmentphysicalname = \"ThuAug20145021IST2020-team.png\" "
        "filetypebccid\t   = \"173\">"
        "</Attachment>",
    "SerialNoCol": "reqno",
    "TransDateCol": "reqdate",
    "checkListDataObj": []
  };
/* getDocAttachXml: function () {
    getComponent('name', 'optionCombo').setValue(BASE.ACTIVE_CNTRL.dropDownRecord.data.mappingname); //RD0370-20
    var validFlag = this.addToList("", true); // RD0370-20
    var gridStore = getStoreByName('docListGridStore');
    var xmlStr = '';

    gridStore.each(function (record) {
    var ActiveorNot = record.data.isActive; //RD0158-20
    var ActiveYN = (ActiveorNot === 'Active') ? 'Y' : 'N'; //RD0158-20
    if (record.data.mode === 'ADD' || record.data.mode === 'EDIT') {
    var TransDocAttchId = 0;
    xmlStr += '<Insert';
    if (record.data.mode === 'EDIT') {
    TransDocAttchId = record.data.id;
    }
    xmlStr += ' TransDocAttchId = "' + TransDocAttchId + '"';
    xmlStr += ' DocOptionTableId	 = "' + record.data.tableid + '"';
    xmlStr += ' DocOptionTableDataId	 = "' + record.data.transdocoptionmappingtabledataid + '"';
    xmlStr += ' RefTableId	 = "' + "**reftableid**" + '"';
    xmlStr += ' RefTableDataId	 = "' + "**reftabledataid**" + '"';
    xmlStr += ' RefOptionId	 = "' + "**refoptionid**" + '"';
    xmlStr += ' RefTransNo	 = "' + "**reftransno**" + '"';
    xmlStr += ' RefTransDate	 = "' + "**reftransdate**" + '"';
    xmlStr += ' DocumentId	 = "' + record.data.documentid + '"';
    xmlStr += ' DocumentNo	 = "' + record.data.documentno + '"';
    if (record.data.documentdate) {
    xmlStr += ' DocumentDate	 = "' + record.data.documentdate + '"';
    }
    if (record.data.mode === 'ADD') {
    xmlStr += ' TempMappingId	 = "' + record.data.mappingid + '"';
    xmlStr += ' TempMappingParentId	 = "' + record.data.mappingparentid + '"';
    }
    if (record.data.parentdocreftableid && record.data.parentdocreftableid !== 0) {
    xmlStr += ' ParentDocRefTableId	 = "' + record.data.parentdocreftableid + '"';
    xmlStr += ' ParentDocRefTableDataId	 = "' + record.data.parentdocreftabledataid + '"';
    }

    xmlStr += ' isactiveyn = "' + ActiveYN + '"';
    xmlStr += ' CreatedUserId	 = "' + BASE.USER_ID + '"';
    xmlStr += ' LastModUserId	= "' + BASE.USER_ID + '"';
    xmlStr += '></Insert>';

    var attachmentsStore = getStoreByName('attachmentsStore');
    attachmentsStore.filter('docno', record.data.documentno); // RD0384-20
    attachmentsStore.each(function (rec) {
//                    if (rec.data.flag !== 'READ-ONLY') {
    xmlStr += '<Attachment';
    if (record.data.mode === 'ADD') { // RD0384-20
    xmlStr += ' TempMappingId	 = "' + record.data.mappingid + '"'; // RD0384-20
    } else {
    xmlStr += ' reftabledataid	 = "' + TransDocAttchId + '"';
    }
    xmlStr += ' attachmentoriginalname = "' + rec.data.attachmentoriginalname + '"';
    xmlStr += ' attachmentphysicalname = "' + rec.data.attachmentphysicalname + '"';
    xmlStr += ' filetypebccid	   = "' + rec.data.filetypebccid + '"';
    xmlStr += '></Attachment>';
//                    }
    });
    attachmentsStore.clearFilter(); // RD0384-20
    }
    });
    return  xmlStr; //RD0370-20
*/ /* RD0034-20 ends */ /*
  }*/

}

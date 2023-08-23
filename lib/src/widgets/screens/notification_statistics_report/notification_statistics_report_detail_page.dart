import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';

class NotificationStatisticsReportDetail extends StatefulWidget {
  final NotificationStatisticsDetailData notistatsList;
  const NotificationStatisticsReportDetail({Key key,
    this.notistatsList
  }) : super(key: key);

  @override
  _NotificationStatisticsReportDetailState createState() => _NotificationStatisticsReportDetailState();
}

class _NotificationStatisticsReportDetailState extends State<NotificationStatisticsReportDetail> {
  @override
  Widget build(BuildContext context) {
    List<NotificationStatisticsDetailData> notistatsList2;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List childData;
    List listOfHeading = [];
    List listOfValue = [];
    List listOfChildHeading = [].toSet().toList();
    List listOfChildValue = [];
    Map<String, dynamic> childMap;
    widget.notistatsList.headerDtl.forEach((element) {
      element.header.forEach((key, value) {
        if (key == "headerdata") {
          listOfHeading.add(value);
        } else {
          listOfValue.add(value);
        }
      });
    });
    childData = widget.notistatsList.child.toList();
    widget.notistatsList.child.forEach((element) {
      element
          .map((e) => e['child'].forEach((ele) {
        var k = ele['childdata'];
        listOfChildHeading.add(k);
        var j = ele['valuedata'];
        listOfChildValue.add(j);
      }))
          .toList();
    });
    List distictHeadings =
    listOfChildHeading.toSet().toList();
    int distictHeadingslength = distictHeadings.length;
    int sublistdistictHeadingslength = distictHeadings.length-4;
    List remarkHeading = distictHeadings.sublist(sublistdistictHeadingslength, distictHeadingslength);
    remarkHeading.removeLast();
    List childDatas;
    List lst = listOfChildValue;
    var detailValue = [];
    int chunkSize = distictHeadings.length;
    for (var i = 0; i < lst.length; i += chunkSize) {
      detailValue.add(lst.sublist(
          i, i + chunkSize > lst.length
              ? lst.length
              : i + chunkSize
      ));
    }
    var remarksList = [];
    var listOfUsers = [];
    var listOfUserSplit = [];
    int lengthofChunks = detailValue.length;
    int sublistlengthofChunks = chunkSize-4;
    int listofuserslength = chunkSize-1;
    detailValue.forEach((element) {
      listOfUsers.add(element.elementAt(listofuserslength));
      remarksList.add(element.sublist(sublistlengthofChunks,chunkSize));
      element.removeRange(sublistlengthofChunks, chunkSize);
    });
    listOfUsers.forEach((element) {
      listOfUserSplit.add(element.split(','));
    });
    distictHeadings.removeRange(sublistlengthofChunks, chunkSize);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: detailValue.length,
                  itemBuilder: (BuildContext context, int pos) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            color: themeData.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: distictHeadings.length,
                                      itemBuilder: (context, int i) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0, 6.0,8.0,0.0,),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 1,

                                                  child: Text(distictHeadings[i])),
                                              SizedBox(width: 10,),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  detailValue[pos][i] != null
                                                      ? detailValue[pos][i]
                                                      : "NA",


                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: remarkHeading.length,
                                      itemBuilder: (context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0,),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor:
                                              Colors.white54,
                                              dividerColor: Colors.transparent,
                                            ),
                                            child: ListTileTheme(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              contentPadding: EdgeInsets.fromLTRB(15.0,0.0,0.0,0.0,),
                                              dense: true,
                                              horizontalTitleGap: 0.0,
                                              minLeadingWidth: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(9),
                                                  child: ExpansionTile(
                                                    backgroundColor: themeData.scaffoldBackgroundColor.withOpacity(0.7),
                                                    collapsedBackgroundColor: themeData.scaffoldBackgroundColor.withOpacity(0.7),
                                                    maintainState: true,
                                                    trailing: Icon(
                                                      Icons.expand_more,
                                                      size: 36,
                                                    ),
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Card(
                                                            elevation: 0,
                                                            color: themeData.scaffoldBackgroundColor,
                                                            child: ListTileTheme(
                                                              child: ListTile(
                                                                tileColor: Colors.transparent,
                                                                title: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(remarksList[pos][index] ?? "NA",
                                                                      textAlign: TextAlign.left,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                    title: Text(
                                                      remarkHeading[index],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0,),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor:
                                              Colors.white54,
                                              dividerColor: Colors.transparent,
                                            ),
                                            child: ListTileTheme(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              contentPadding: EdgeInsets.fromLTRB(15.0,0.0,0.0,0.0,),
                                              dense: true,
                                              horizontalTitleGap: 0.0,
                                              minLeadingWidth: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(9),
                                                  child: ExpansionTile(
                                                    backgroundColor: themeData.scaffoldBackgroundColor.withOpacity(0.7),
                                                    collapsedBackgroundColor: themeData.scaffoldBackgroundColor.withOpacity(0.7),
                                                    maintainState: true,
                                                    trailing: Icon(
                                                      Icons.expand_more,
                                                      size: 36,
                                                    ),
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Card(
                                                            elevation: 0,
                                                            color: themeData.scaffoldBackgroundColor,
                                                            child: ListTileTheme(
                                                              child: ListTile(
                                                                tileColor: Colors.transparent,
                                                                title: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    listOfUsers != null ? Wrap(
                                                                      children: List.generate(listOfUserSplit[pos].length, (index) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                                                                          child: Chip(
                                                                            elevation: 0,
                                                                            backgroundColor: themeData.primaryColor,
                                                                            label: Text(
                                                                              listOfUserSplit[pos][index],
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                    ) : Text("NA"),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                    title: Text(
                                                      "Action Taken Against Whom",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,


                    child:   Container(
                      width:MediaQuery.of(context).size.width/17,
                        height:MediaQuery.of(context).size.width/16,
                    child: Center(child: Text((pos+1).toString())),
                    decoration: new BoxDecoration(
                    color: themeData.primaryColorDark,
//                    Colors.blue,
                    shape: BoxShape.circle,
                    ),)

                          )
                        ],
                      ),
                    );
                  }
              ))
        ],
      ),
    );
  }
}

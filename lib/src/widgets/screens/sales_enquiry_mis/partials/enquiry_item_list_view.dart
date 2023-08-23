import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';

class DocumentListItem extends StatelessWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final String filePath;

  final SalesEnquiryMisModel enquiryItem;

  final VoidCallback onTap;

  const DocumentListItem({
    Key key,
    this.animationController,
    this.animation,
    this.onTap,
    this.filePath,
    this.enquiryItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 50 * (1.0 - animation.value), 0.0),
                child: AnimatedContainer(
                    margin: EdgeInsets.only(left: 0, bottom: 8),
                    padding: const EdgeInsets.only(
                      left: 4,
                      // right: 10,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration:
                        BoxDecoration(border: Border(bottom: BaseBorderSide())),
                    duration: Duration(milliseconds: 6300),
                    child: Column(
                      children: [
                        Row(children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: Container(
                              height: 70,
                              width: 90,
                              child: Container(
                                height: 160,
                                child: PhotoWidget(
                                    imageUrl:
                                        "${(enquiryItem?.thumbnail ?? "")}"),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text("${enquiryItem.itemName}",
                                    textAlign: TextAlign.left,
                                    style: textTheme.subhead1),
                                SizedBox(height: 5),
                                _buildStockDetail(
                                  color: Colors.green,
                                  title: "Branch Stock",
                                  inStock: enquiryItem.branchStock,
                                  sold: enquiryItem.readyStock,
                                ),
                                SizedBox(height: 12),
                                _buildStockDetail(
                                  color: Colors.blue,
                                  title: "Other Branch Stock",
                                  inStock: enquiryItem.othBranchStock,
                                  sold: enquiryItem.othReadyStock,
                                ),
                              ]))
                        ]),
                      ],
                    )),
              ));
        });
  }

  Widget _buildStockDetail({
    String title,
    double inStock,
    double sold,
    Color color,
  }) {
    return Builder(builder: (BuildContext context) {
      BaseTheme textTheme = BaseTheme.of(context);

      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("$title",
                  style: textTheme.bodyBold.copyWith(fontSize: 12)),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("$sold/$inStock")),
          ],
        ),
        if (inStock > 0)
          Padding(
              padding: EdgeInsets.only(left: 6, top: 4),
              child: LinearProgressIndicator(
                minHeight: 5,
                value: sold / inStock,
                valueColor: AlwaysStoppedAnimation(color),
                backgroundColor: Colors.red.withOpacity(.3),
              ))
      ]);
    });
  }
}

class DocumentTypeWidget extends StatelessWidget {
  final int icon;
  final Color color;
  final String docName;

  const DocumentTypeWidget({
    this.icon,
    this.color,
    this.docName,
  });

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);

    return Row(
      children: <Widget>[
        Icon(
          IconData(icon, fontFamily: 'MaterialIcons'),
          size: 18,
          color: color,
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            '$docName',
            overflow: TextOverflow.ellipsis,
            style: theme.subhead1,
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:base/resources.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class DocumentItemsGrid extends StatefulWidget {
  final List<String> scannedDocuments;

  const DocumentItemsGrid({Key key, this.scannedDocuments}) : super(key: key);

  @override
  DocumentItemsGridState createState() => DocumentItemsGridState();
}

class DocumentItemsGridState extends State<DocumentItemsGrid> {
  List<String> _scannedDocuments;

  List<String> get scannedDocuments => _scannedDocuments;

  @override
  void initState() {
    super.initState();
    _scannedDocuments = widget?.scannedDocuments ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final _style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Attached Documents',
                      textAlign: TextAlign.left,
                      style: _style.subhead1Semi
                          .copyWith(fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: 8),
                (_scannedDocuments?.isNotEmpty ?? false)
                    ? CarouselSlider.builder(
                        itemCount: _scannedDocuments.length,
                        itemBuilder: (context, position,_) {
                          File file = File(_scannedDocuments[position]);
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(
                                  left: height * .08,
                                  right: height * .08,
                                  top: height * .005,
                                  bottom: height * .23),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(children: <Widget>[
                                    file == null
                                        ? new Text('Sorry nothing selected!!')
                                        : Image.file(
                                            file,
                                            fit: BoxFit.cover,
                                            width: 1000.0,
                                          ),
                                    Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Text(
                                                "Page No. " +
                                                    (position + 1).toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ))))
                                  ])));
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          aspectRatio: 1.0,
                          scrollPhysics: BouncingScrollPhysics(),
                          enableInfiniteScroll: false,
                        ),
                      )
                    : _EmptyScanView(),
              ]),
        ),
        Positioned(
            bottom: -7,
            right: 20,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                      child: FloatingActionButton(
                          heroTag: "btn_camera",
                          onPressed: () => _getImage(ImageSource.camera),
                          tooltip: "Capture Image",
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: themeData.primaryColorDark,
                          ))),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                      child: FloatingActionButton(
                        backgroundColor: themeData.primaryColorDark,
                        heroTag: "btn_gallery",
                        onPressed: () => _getImage(ImageSource.gallery),
                        tooltip: "Pick From Gallery",
                        child: SvgPicture.asset(BaseVectors.folder),
                      ))
                ])),
      ],
    );
  }

  void _getImage(ImageSource source) async {
    PickedFile image =
        await ImagePicker().getImage(source: source, imageQuality: 55);
    setState(() {
      _scannedDocuments.add(image.path);
    });
  }
}

class _EmptyScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SizedBox.fromSize(
        size: Size(width, height / 1.78),
        child: Container(
            color: themeData.scaffoldBackgroundColor,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: height * .01),
            height: 300,
            width: 300,
            child: Column(
              children: <Widget>[
                Text(
                  "No Attachments added",
                  style: BaseTheme.of(context).body2.copyWith(fontSize: 16),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            )));
  }
}

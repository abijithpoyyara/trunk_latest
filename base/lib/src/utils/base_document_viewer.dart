import 'dart:async';

import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

final webViewKey = GlobalKey<WebViewContainerState>();
const String googleViewer = "https://docs.google.com/gview?embedded=true&url=";

bool isWebView = false;

class FileDetails {
  String originalfilename;
  String filename;
  String fileextension;

  FileDetails({this.originalfilename, this.filename, this.fileextension});
}

class DocumentViewerModel {
  String title;
  String date;
  String subtitle;
  String footer;
  List<FileDetails> files;

  DocumentViewerModel({
    this.title,
    this.date,
    this.subtitle,
    this.footer,
    this.files,
  });
}

class DocumentViewerList extends StatelessWidget {
  final List<DocumentViewerModel> documents;
  final String filePath;
  final String transactionNo;

  const DocumentViewerList(
      {Key key, this.documents, this.transactionNo, this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      children: documents
          .map<Widget>(
              (e) => DocumentViewerItem(document: e, filePath: filePath))
          .toList(),
    );
  }
}

class DocumentViewerItem extends StatefulWidget {
  final DocumentViewerModel document;
  final String filePath;

  const DocumentViewerItem({
    Key key,
    @required this.document,
    this.filePath,
  });

  @override
  _DocumentViewerItemState createState() => _DocumentViewerItemState();
}

class _DocumentViewerItemState extends State<DocumentViewerItem>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;

  // WebViewController webViewController;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    BaseTheme textTheme = BaseTheme.of(context);
    final height = MediaQuery.of(context).size.height;
    return PageView.builder(
        allowImplicitScrolling: false,
        itemCount: widget.document.files.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) =>
            buildListItems(height, widget.document.files[index], context));
  }

  Widget buildListItems(var height, FileDetails file, BuildContext context) {
    String fileGoogleUrl = googleViewer + widget.filePath + file.filename;
    String fileUrl = widget.filePath + file.filename;
    String extension = file.fileextension;
    if (!(extension.contains("png") ||
        extension.contains("jpg") ||
        extension.contains("jpeg") ||
        extension.contains("pdf"))) {
      isWebView = true;
    }
    print("File path----${widget.filePath}");

    print("file Uri : $fileUrl");

    BaseColors _colors = BaseColors.of(context);
    return Container(
      color: _colors.white.withOpacity(.5),
      height: height,
      child: Stack(children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: !(extension.contains("png") ||
                    extension.contains("jpg") ||
                    extension.contains("jpeg"))
                ? extension.contains("pdf")
                    ? PDFViewerFromUrl(
                        url: fileUrl,
                      )
                    : WebViewContainer(
                        key: webViewKey,
                        fileUrl: fileGoogleUrl,
                        onFinished: pageFinishedLoading,
                      )
                : PhotoWidget(imageUrl: widget.filePath + file.filename
                    // widget.filePath + file.filename,
                    )),
        Positioned(
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(file.originalfilename,
                    style: BaseTheme.of(context).subhead1Bold.copyWith(
                        color: !(extension == "png" || extension == "jpg")
                            ? Colors.black
                            : _colors.white)))),
        Positioned(
            top: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(10, 0, 0, 0),
                  Color.fromARGB(190, 30, 10, 40)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(children: [
                  Text(widget.document.title ?? "Title ",
                      style: BaseTheme.of(context)
                          .subhead1Bold
                          .copyWith(color: _colors.white)),
                  Text(widget.document.subtitle ?? '',
                      style: BaseTheme.of(context)
                          .subhead2
                          .copyWith(color: _colors.white))
                ]))),
      ]),
    );
  }

  void pageFinishedLoading(String url) {
    setState(() {
      isLoading = false;
      isWebView = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class PhotoWidget extends StatelessWidget {
  final String imageUrl;

  PhotoWidget({@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    print("photoview called");
    return PhotoView(
        key: ValueKey(1),
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 4,
        initialScale: PhotoViewComputedScale.contained,
        enableRotation: true,
        loadingBuilder: (con, _) => Center(
            child: BaseLoadingSpinner(
                color: BaseColors.of(context).primaryColor, size: 35)));
  }
}

class _WebViewWidget extends StatefulWidget {
  final String extension;
  final String fileUrl;

  const _WebViewWidget({Key key, this.extension, @required this.fileUrl})
      : super(key: key);

  @override
  __WebViewWidgetState createState() => __WebViewWidgetState();
}

class __WebViewWidgetState extends State<_WebViewWidget>
    with AutomaticKeepAliveClientMixin {
  LoadingStatus _loadingStatus;
  String _message;

  @override
  void initState() {
    _loadingStatus = LoadingStatus.success;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _loadingStatus == LoadingStatus.success
        ? _DocViewer(
            extension: widget.extension,
            filePath: widget.fileUrl.replaceAll(" ", "%20"),
          )
        : Container(
            alignment: Alignment.center,
            child: _loadingStatus == LoadingStatus.error
                ? Text(_message)
                : Column(
                    children: <Widget>[
                      BaseLoadingSpinner(),
                      SizedBox(height: 8),
                      Text("Loading"),
                    ],
                  ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class _DocViewer extends StatefulWidget {
  final String filePath;
  final String extension;

  const _DocViewer({Key key, this.filePath, this.extension}) : super(key: key);

  @override
  __DocViewerState createState() => __DocViewerState();
}

class __DocViewerState extends State<_DocViewer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print("height ${constraints.maxHeight}");
        print("width ${constraints.maxWidth}");
        return Container();
        // return HtmlWidget(
        //   buildFrame(widget.filePath),
        //   webView: true,
        //   enableCaching: true,
        //   buildAsync: true,
        //   webViewJs: true,
        // );
      },
    );
  }

  buildFrame(String filePath) {
    String html =
        ''' <iframe  src="https://docs.google.com/gview?url=${widget.filePath}&embedded=true" width="500" height="800" ></iframe>''';
    print(html);

    return html;
  }
}

class WebViewContainer extends StatefulWidget {
  final String fileUrl;
  final void Function(String) onFinished;

  WebViewContainer({Key key, this.fileUrl, this.onFinished}) : super(key: key);

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  WebViewController _webViewController;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return WebView(
      key: webViewKey,
      initialUrl: Uri.dataFromString(
              '<html><body> <iframe  src="${widget.fileUrl}" width="100%" height="100%" ></iframe></body></html>',
              mimeType: 'text/html')
          .toString(),
      // Uri.dataFromString(
      //         // '<html><body><iframe scrolling="no" width="100%" height="100%" src="${widget.fileUrl}"></iframe></body></html>',
      //         '<html><body><iframe scrolling="no" width="100%" height="100%" src="${widget.fileUrl}"></iframe></body></html>',
      //         //<iframe scrolling="no" src="' + BASE.FILE_ATCHMT_DOWNLOAD_PATH + (obj.fpath) + '" width="100%" height="100%" ></iframe>
      //         mimeType: 'text/html')
      //     .toString(),
      onProgress: (int progress) {
        isWebView = true;
        print('WebView is loading (progress : $progress%)');
      },
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },

      onPageFinished: widget.onFinished,
    );
  }

  void reloadWebView() {
    _webViewController?.reload();
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  PDFViewerFromUrl({Key key, @required this.url}) : super(key: key);
  final String url;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int current, int total) =>
            _pageCountController.add('${current + 1} - $total'),
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text("File not found")),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  tooltip: "previous page",
                  heroTag: '-',
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  ),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data;
                    final int currentPage =
                        (await pdfController.getCurrentPage()) - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
                StreamBuilder<String>(
                    stream: _pageCountController.stream,
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[900],
                            ),
                            child: Text(snapshot.data),
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                FloatingActionButton(
                  tooltip: "next page",
                  heroTag: '+',
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data;
                    final int currentPage =
                        (await pdfController.getCurrentPage()) + 1;
                    final int numberOfPages =
                        await pdfController.getPageCount() ?? 0;
                    if (numberOfPages > currentPage) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

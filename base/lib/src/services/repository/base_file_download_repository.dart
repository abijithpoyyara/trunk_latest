import 'package:base/services.dart';

class FileDownloadRepository {
  Future<void> downloadFile(String fileUrl,
      {String fileName,
      Function(String filePath) onDownloadComplete,
      Function(AppException error) onDownloadFailed,
      Function(int progress) onDownloadProgress}) async {
//    Dio dio = new Dio();

//    Directory dir = await getTemporaryDirectory();
//    String path = dir.path + "/" + filePatheName;
//    await dio
//        .download(fileUrl, path,
//            deleteOnError: true,
//            onReceiveProgress: (received, total) =>
//                onDownloadProgress(received ~/ total * 100))
//        .then((response) => onDownloadComplete(path))
//        .catchError((error) {
//      print(error);
//      onDownloadFailed(FetchDataException());
//    });
//    } else
//      onDownloadFailed(FetchDataException("File permission not grantted"));
  }
}

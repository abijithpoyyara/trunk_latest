import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({
    Key key,
    @required this.onSendMail,
  }) : super(key: key);

  final VoidCallback onSendMail;

  @override
  Widget build(BuildContext context) {
    final textTheme = BaseTheme.of(context).subhead1Bold;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitFadingCube(
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 48.0),
          Text(
            "ACCESS DENIED",
            style: textTheme,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              "Do not be alarmed. \n We just need your attention. \n\n It is possible you have violated one or a couple of our usage policy?.\n If this is not the case, please contact an Administrator.",
              style: textTheme.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32.0),
          RaisedButton.icon(
            shape: const StadiumBorder(),
            colorBrightness: Brightness.dark,
            onPressed: onSendMail,
            icon: const Icon(Icons.mail),
            label: const Text("Send a mail"),
          ),
        ],
      ),
    );
  }
}

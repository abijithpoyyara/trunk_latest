import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';

class SaleEnquiryItem extends StatelessWidget {
  final String enquiryNo;
  final String uniqueNo;
  final String createdDate;
  final String branch;
  final String status;
  final Animation<double> animation;
  final AnimationController animationController;

  const SaleEnquiryItem({
    Key key,
    this.enquiryNo,
    this.uniqueNo,
    this.createdDate,
    this.branch,
    this.status,
    this.animation,
    this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                (1 - animation.value) * 5, (1 - animation.value), 0),
            child: ClipPath(
              clipper: CustomClipPath(),
              child: AnimatedContainer(
                  margin: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  duration: animationController.duration,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BaseBorderSide()),
                    gradient: LinearGradient(colors: [
                      colors.white.withOpacity(.14),
                      themeData.primaryColor.withOpacity(.15),
                      themeData.primaryColor.withOpacity(.34),
                    ]),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("$enquiryNo",
                            style: textTheme.subhead1Semi
                                .copyWith(letterSpacing: .3)),
                        SizedBox(height: 4.0),
                        Text(uniqueNo, style: textTheme.subhead1),
                        SizedBox(height: 4.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("$createdDate", style: textTheme.body),
                              // Text("$status", style: textTheme.body)
                            ])
                      ])),
            ),
          ),
        );
      },
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0.0),
        clockwise: true, radius: Radius.circular(radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

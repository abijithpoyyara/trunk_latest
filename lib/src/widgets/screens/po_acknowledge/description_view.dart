import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/utility.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

  class VehicleView extends StatefulWidget {
  final POVehicleModel vehicle;
  final bool isNewRecord;
  final ValueSetter<POVehicleModel> onSubmit;
  final Function(POVehicleModel) onDelete;

  const VehicleView({
    Key key,
    this.vehicle,
    this.onSubmit,
    this.onDelete,
    this.isNewRecord = false,
  }) : super(key: key);

  @override
  _VehicleViewState createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {
  GlobalKey<FormState> _formKey;
  POVehicleModel _vehicle;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _vehicle = widget.vehicle ?? POVehicleModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = BaseTheme.of(context).style;
    final colors = BaseTheme.of(context).colors;
    ThemeData themedata =ThemeProvider.of(context);
    return Scaffold(backgroundColor: themedata.accentColor,
        // resizeToAvoidBottomPadding: false,
        body: Container(
      color:themedata.primaryColorDark.withOpacity(.7),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
      ),
      child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            Container(
              color: themedata.primaryColorDark,
              padding: EdgeInsets.all(5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vehicle Details',
                        /*style: textStyles.headLine4.copyWith(color: colors.accentColor)*/),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context))
                  ]),
            ),
         //   SizedBox(height: 30),
            Container(color: themedata.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BaseTextField(
                  icon: Icons.directions_bus,
                  initialValue: _vehicle.vehicleNo,
                  onSaved: (val) => setState(() => _vehicle.vehicleNo = val),
                  autoFocus: true,
                  validator: BaseValidate.tryString("Please add vehicle number"),
                  displayTitle: "Vehicle Number",
                ),
              ),
            ),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color:themedata.scaffoldBackgroundColor,
                        border: Border.all(color: colors.accentColor),
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: TextFormField(
                        initialValue: _vehicle.description,
                        maxLines: 25,
                        minLines: 15,
                        enabled: true,
                        cursorColor: colors.accentColor,
                        /*style:textStyles.bodyHint.copyWith(color: colors.accentColor) ,*/
                        // autofocus: true,
                        scrollPadding: EdgeInsets.all(4),
                        textInputAction: TextInputAction.newline,
                        onSaved: (val) =>
                            setState(() => _vehicle.description = val),
                        decoration: InputDecoration(
                          hintStyle:TextStyle(color: themedata.accentColor),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'Type to enter descriptions.....',
                            /*hintStyle: textStyles.bodyHint.copyWith(color: colors.accentColor)*/)))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  if (!widget.isNewRecord)
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: colors.selectedColor,
                        onPressed: () async {
                          final result = await baseChoiceDialog(
                              message: ''
                                  'Are you sure want to delete this vehicle ?',
                              context: context,
                              title: 'Delete');
                          if (result) {
                            _formKey.currentState.save();
                            widget.onDelete(widget.vehicle);
                          }
                        },
                        child: Text(
                          "DELETE",
                          // style: textStyles.body2.semiMedium.copyWith(color: colors.white),
                        ),
                      ),
                    ),
                  SizedBox(width: 4),
                  Expanded(
                    child: RaisedButton(

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: themedata.primaryColorDark,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          widget.onSubmit(_vehicle);
                        }
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: themedata.accentColor,),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
      ),
    ),
        );
  }
}

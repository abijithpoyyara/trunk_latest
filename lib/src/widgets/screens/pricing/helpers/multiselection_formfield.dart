import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/widgets/screens/pricing/helpers/multiselect_dialogue.dart';

class MultiSelectFormField extends FormField<List<String>> {
  final List<String> itemList;
  final String buttonText;
  final String questionText;
  final bool isLocation;

  MultiSelectFormField({
    this.buttonText,
    this.questionText,
    this.itemList,
    this.isLocation = false,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldSetter<List<String>> onChanged,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
          onSaved: onSaved,
          //  onChanged:onChanged,
          validator: validator,
          initialValue: initialValue ?? [], // Avoid Null
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<List<String>> state) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;
            return Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: isLocation
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                        child: Card(
                            color: isLocation
                                ? BaseColors.of(context).secondaryColor
                                : Colors.white,
                            elevation: 0,
                            child: ClipPath(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: isLocation
                                          ? BaseColors.of(context)
                                              .secondaryColor
                                          : Colors.white,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: isLocation
                                                  ? Colors.white.withOpacity(.5)
                                                  : Colors.transparent))),
                                  // padding: isLocation
                                  //     ? EdgeInsets.zero
                                  //     : EdgeInsets.zero,
                                  margin: isLocation
                                      ? EdgeInsets.only(left: 23)
                                      : EdgeInsets.all(5),
                                  height: 40,
                                  width: isLocation ? width * .8 : width * .95,
                                  child: isLocation
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: (state.value == null ||
                                                  state.value.length <= 0)

                                              // Show the buttonText as it is
                                              ? Text(
                                                  buttonText,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: isLocation
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )

                                              // Else show number of selected options
                                              : Text(
                                                  state.value.length == 1
                                                      // SINGLE FLAVOR SELECTED

                                                      ? '${state.value.toString()} '

                                                      // MULTIPLE FLAVOR SELECTED
                                                      : '${state.value.toString()} ',
                                                  style: TextStyle(
                                                      color: isLocation
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        )
                                      : Center(
                                          //If value is null or no option is selected
                                          child: (state.value == null ||
                                                  state.value.length <= 0)

                                              // Show the buttonText as it is
                                              ? Text(
                                                  buttonText,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: isLocation
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )

                                              // Else show number of selected options
                                              : Text(
                                                  state.value.length == 1
                                                      // SINGLE FLAVOR SELECTED

                                                      ? '${state.value.toString()} '

                                                      // MULTIPLE FLAVOR SELECTED
                                                      : '${state.value.toString()} ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                ),
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))))),
                        onTap: () async => state.didChange(await showDialog(
                                context: context,
                                builder: (_) => MultiSelectDialog(
                                      question: Text(questionText),
                                      answers: itemList,
                                    )) ??
                            []))
                  ],
                ),
                // If validation fails, display an error
                state.hasError
                    ? Center(
                        child: Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container() //Else show an empty container
              ],
            );
          },
        );
}

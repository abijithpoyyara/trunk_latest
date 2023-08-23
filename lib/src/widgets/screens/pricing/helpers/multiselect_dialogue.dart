import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';

class MultiSelectDialog extends StatelessWidget {
  final List<String> answers;

  final Widget question;

  final List<String> selectedItems = [];

  Map<String, bool> mappedItem;

  MultiSelectDialog({Key key, this.answers, this.question}) : super(key: key);

  // MultiSelectDialog({this.answers, this.question});

  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(answers,
        key: (k) => k,
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }

    return SimpleDialog(
      backgroundColor: BaseColors.of(context).secondaryColor,
      title: question,
      children: [
        ...mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => Column(
              children: [
                Container(
                  color: BaseColors.of(context).secondaryColor,
                  child: CheckboxListTile(
                      checkColor: BaseColors.of(context).white,
                      activeColor: BaseColors.of(context).primaryColor,
                      // Displays the option
                      value: mappedItem[key],
                      title: Text(key),
                      // Displays checked or unchecked value
                      controlAffinity: ListTileControlAffinity.platform,
                      onChanged: (value) =>
                          setState(() => mappedItem[key] = value)),
                ),
              ],
            ),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: RaisedButton(
                color: BaseColors.of(context).selectedColor,
                //style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}

class MultiSelectDialogLocation extends StatelessWidget {
  final List<String> answers;

  final Widget question;

  final List<String> selectedItems = [];

  Map<String, bool> mappedItem;

  MultiSelectDialogLocation({Key key, this.answers, this.question})
      : super(key: key);

  // MultiSelectDialog({this.answers, this.question});

  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(answers,
        key: (k) => k,
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }

    return SimpleDialog(
      backgroundColor: BaseColors.of(context).secondaryColor,
      title: question,
      children: [
        ...mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => Column(
              children: [
                Container(
                  color: BaseColors.of(context).secondaryColor,
                  child: CheckboxListTile(
                      checkColor: BaseColors.of(context).white,
                      activeColor: BaseColors.of(context).primaryColor,
                      // Displays the option
                      value: mappedItem[key],
                      title: Text(key),
                      // Displays checked or unchecked value
                      controlAffinity: ListTileControlAffinity.platform,
                      onChanged: (value) =>
                          setState(() => mappedItem[key] = value)),
                ),
              ],
            ),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: RaisedButton(
                color: BaseColors.of(context).selectedColor,
                //style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}

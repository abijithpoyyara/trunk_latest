import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';

class ContainerSelector extends StatefulWidget {
  final Function(int) onButtonSelected;

  ContainerSelector({this.onButtonSelected});

  @override
  _ContainerSelectorState createState() => _ContainerSelectorState();
}

class _ContainerSelectorState extends State<ContainerSelector> {
  int selectedButton = 1; // Default selected button

  void toggleSelection(int buttonIndex) {
    setState(() {
      selectedButton = buttonIndex;
      widget.onButtonSelected(selectedButton);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: basegreenColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => toggleSelection(2),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selectedButton == 2 ? basegreenColor : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Branch',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          selectedButton == 2 ? homeHeadTextColor : basegreenColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => toggleSelection(1),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selectedButton == 1 ? basegreenColor: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Option',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          selectedButton == 1 ? homeContainerWhiteColor : basegreenColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

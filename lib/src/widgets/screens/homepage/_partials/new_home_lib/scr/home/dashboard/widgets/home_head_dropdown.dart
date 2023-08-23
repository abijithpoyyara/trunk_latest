import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';
import '../../../../util/colors.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> optionList;

  CustomDropdown({this.optionList});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedOption = 'Redstars Mob Trading'; // Default selected option

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      height: MediaQuery.of(context).size.height*.06,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: const Color.fromARGB(1, 0, 0, 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Branch :  ",
            style: TextStyle(
                color: homeHeadTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 2),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedOption,
                items: widget.optionList.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: homeHeadTextColor,
                ),
                iconSize: 24,
                elevation: 0,
                style: const TextStyle(
                    color: homeHeadTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 2.1),
                dropdownColor: themeData.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:base/res/values/base_colors.dart';
// import 'package:base/res/values/base_style.dart';
// import 'package:base/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
//
// class SearchWidget extends StatefulWidget {
//   final PricingViewModel viewModel;
//   final String initialValue;
//   final VoidCallback onClearSearch;
//   final Function(String) onSearch;
//
//   const SearchWidget(
//       {Key key,
//       this.viewModel,
//       this.initialValue,
//       this.onSearch,
//       this.onClearSearch})
//       : super(key: key);
//
//   @override
//   _SearchWidgetState createState() => _SearchWidgetState();
// }
//
// class _SearchWidgetState extends State<SearchWidget> {
//   @override
//   Widget build(BuildContext context) {
//     BaseColors colors = BaseColors.of(context);
//     return Card(
//       color: colors.secondaryColor,
//       margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//         child: BaseTextField(
//          // e: InputBorder.none,
//           hint: "Search",
//           initialValue: widget.initialValue,
//        //   inputAction: TextInputAction.search,
//           onEditingCompleted: (query) => widget.onSearch,
//           padding: EdgeInsets.all(2),
//           suffixIcon: IconButton(
//             icon: Icon(
//               Icons.close,
//               size: 14,
//             ),
//             onPressed: () {
//               widget.onClearSearch;
//             },
//           ),
//           border: OutlineInputBorder(),
//           focusBorder: UnderlineInputBorder(
//               borderSide: BaseBorderSide(color: Colors.transparent)),
//           icon: Icons.search,
//         ),
//       ),
//     );
//   }
// }

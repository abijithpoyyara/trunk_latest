import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';

class Test45 extends StatefulWidget {
  final GradingCostingViewModel viewModel;

  const Test45({Key key, this.viewModel}) : super(key: key);
  @override
  _Test45State createState() => _Test45State();
}

class _Test45State extends State<Test45> {
  TextEditingController _controller = TextEditingController();
  int s = 0;
  var k;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          initialValue: (widget
                                  .viewModel.itemDetailList[index].gradingQty)
                              .toString(),
                          onChanged: (val) {
                            setState(() {
                              s = int.parse(val);
                              print("enter value${val}");
                              widget.viewModel.itemDetailList[index]
                                  .gradingQty = s;
                              print(
                                  "enter valu77e${widget.viewModel.itemDetailList[index].gradingQty}");
                            });
                          },
                        ),
                        Text(
                            (widget.viewModel.itemDetailList[index].gradingQty *
                                    2)
                                .toString()),
                        TextFormField(
                          controller: _controller,
                          onChanged: (val) {
                            setState(() {
                              s = int.parse(val);
                              print("enter value${val}");
                              widget.viewModel.itemDetailList[index]
                                  .gradingQty = val as int;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _controller,
                          onChanged: (val) {
                            setState(() {
                              s = int.parse(val);

                              print("enter value${val}");
                              widget.viewModel.itemDetailList[index]
                                  .gradingQty = val as int;
                            });
                          },
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  int f() {
    k = s * 2;
    return k;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/pricing/pricing_viewmodel.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class ItemDtlUpdate extends StatefulWidget {
  final PricingViewModel viewModel;
  ItemDtlUpdate({Key key, this.viewModel}) : super(key: key);

  @override
  _ItemDtlUpdateState createState() => new _ItemDtlUpdateState();
}

class _ItemDtlUpdateState extends State<ItemDtlUpdate> {
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isChanged = false;

  List<ItemDetailListItems> _listCourse = [];
  List<ItemDetailListItems> data;
  @override
  void initState() {
    // Initialize empty List
    _listCourse.add(ItemDetailListItems());
    super.initState();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }

  Widget buildField(int index, PricingViewModel viewModel) {
    BaseTheme _style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    data = viewModel.itemDtl;
    return Container(
      color: themeData.primaryColor,
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        color: themeData.primaryColor,
        //margin: EdgeInsets.only(left: 7),
        padding: EdgeInsets.all(12),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            //  crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: Text(data[index]?.itemname ?? " ",
                        textAlign: TextAlign.left,
                        style: _style.subhead1.copyWith(
                            color: _style.colors.accentColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(data[index]?.uom ?? "",
                        textAlign: TextAlign.right,
                        style: _style.body2.copyWith(
                            color: _style.colors.accentColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: .3)),
                  ),
                ],
              ),
              // SizedBox(height: 4.0),
              // Text(data[index]?.itemcode ?? " ",
              //     textAlign: TextAlign.left,
              //     style: _style.body2.copyWith(fontWeight: FontWeight.w400)),
              //  SizedBox(height: 4.0),
              // Text(widget.uom,
              //     style:
              //         _style.body2Medium.copyWith(fontWeight: FontWeight.w400)),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price",
                      textAlign: TextAlign.left,
                      style: _style.body2Medium
                          .copyWith(fontWeight: FontWeight.w400)),
                  Text(data[index].rateDtl.sellingcost.toString() ?? "00",
                      textAlign: TextAlign.right,
                      style: _style.body2Medium
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: MediaQuery.of(context).size.width * .09,
                  width: MediaQuery.of(context).size.width * .3,
                  padding: EdgeInsets.all(3),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: themeData.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          initialValue: "",

                          keyboardType: TextInputType.number,
                          // textAlign: TextAlign.center,
                          onChanged: (val) {
                            data[index]?.newPrice = val;
                            print("saved Vlues===>${val}");
                          },
                          // onSaved: (val) {
                          //   data[index]?.newPrice = val;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SizedBox(
              //   height: 20,
              // )
            ]),
      ),
      // color: data[index]?.newPrice?.isEmpty ?? true
      //     ? BaseColors.of(context).selectedColor
      //     : BaseColors.of(context).selectedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    // var loginBtn = new RaisedButton(
    //   onPressed: _submit,
    //   child: new Text("CALCULATE"),
    //   color: Colors.primaries[0],
    // );
    var showForm = new Container(
      // padding: new EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Form(
              key: formKey,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return buildField(index, widget.viewModel);
                },
                itemCount: widget.viewModel.itemDtl.length,
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
          //  _isLoading ? new CircularProgressIndicator() : loginBtn
        ],
      ),
    );
    return new Scaffold(
      body: showForm,
    );
  }
}

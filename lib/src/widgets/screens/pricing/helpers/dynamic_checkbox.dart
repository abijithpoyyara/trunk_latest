import 'package:base/res/values/base_colors.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';

class DynamicallyCheckBox extends StatefulWidget {
  final List<ItemGroupLookupItem> values;
  final String title;

  const DynamicallyCheckBox({Key key, this.values, this.title})
      : super(key: key);
  @override
  _DynamicallyCheckBoxState createState() => _DynamicallyCheckBoxState();
}

class _DynamicallyCheckBoxState extends State<DynamicallyCheckBox> {
  List<String> selectedItem = [];
  Map<String, bool> mappedItems;

  @override
  Widget build(BuildContext context) {
    List<String> result = [];
    widget.values.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map?.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }
    //
    // getItems() {
    //   mappedItems.forEach((key, value) {
    //     if (value == true) {
    //       selectedItem.add(key);
    //       return selectedItem;
    //     }
    //   });
    //   Navigator.pop(context, selectedItem.toString());
    //   print(selectedItem.toString());
    //   selectedItem.clear();
    // }

    if (mappedItems == null) {
      initMap();
    }
    BaseColors colors = BaseColors.of(context);
    return Scaffold(
      appBar: BaseAppBar(title: Text(widget.title ?? ""), actions: [
        IconButton(
          disabledColor: Colors.black,
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              showSearch(
                  context: context,
                  delegate: SearchAppBar(
                    widget.values,
                  ));
            });
          },
        )
      ]),
      body: Container(
        color: BaseColors.of(context).secondaryColor,
        child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              children: mappedItems.keys.map((String key) {
                return Container(
                  color: BaseColors.of(context).secondaryColor,
                  child: new CheckboxListTile(
                    title: new Text(key),
                    value: mappedItems[key],
                    activeColor: colors.primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        mappedItems[key] = value;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          RaisedButton(
            child: Text(" OK"),
            onPressed: () {
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  return selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
              print(selectedItem.toString());
            },
            color: BaseColors.of(context).selectedColor,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
        ]),
      ),
    );
  }
}

class SearchAppBar extends SearchDelegate<List<String>> {
  final List<ItemGroupLookupItem> transactions;

  SearchAppBar(this.transactions);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: new TextStyle(fontFamily: 'Roboto')),
        primaryColor: BaseColors.of(context).primaryColor,
        primaryIconTheme: theme.primaryIconTheme
            .copyWith(color: BaseColors.of(context).accentColor, size: 12),
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            size: 20,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, size: 20),
        onPressed: () {
          close(context, null);
        });
  }

  // @override
  Widget buildResults(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo =
          name.description != null ? name.description.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    List<String> selectedItem = [];
    Map<String, bool> mappedItems;
    List<String> result = [];
    transactionsList.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      // selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }
    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return Container(
                color: BaseColors.of(context).secondaryColor,
                child: StatefulBuilder(
                  builder: (context, StateSetter setState) =>
                      new CheckboxListTile(
                    title: new Text(key),
                    value: mappedItems[key],
                    activeColor: BaseColors.of(context).primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        mappedItems[key] = value;
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text(" OK"),
          onPressed: () {
            selectedItem.clear();

            // Traverse each map entry
            mappedItems.forEach((key, value) {
              if (value == true) {
                return selectedItem.add(key);
              }
            });

            // Close the Dialog & return selectedItems
            Navigator.pop(context, selectedItem);
            print(selectedItem.toString());
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }

  // @override
  Widget buildSuggestions(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo =
          name.description != null ? name.description.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    List<String> selectedItem = [];
    Map<String, bool> mappedItems;
    List<String> result = [];
    transactionsList.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }

    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return StatefulBuilder(
                builder: (_, StateSetter setState) => CheckboxListTile(
                  title: new Text(key),
                  value: mappedItems[key],
                  activeColor: BaseColors.of(context).primaryColor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      mappedItems[key] = value;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text("OK "),
          onPressed: () {
            selectedItem.clear();

            // Traverse each map entry
            mappedItems.forEach((key, value) {
              if (value == true) {
                selectedItem.add(key);
              }
            });

            print(selectedItem);
            // Close the Dialog & return selectedItems
            Navigator.pop(context, selectedItem);
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }
}

/// Multiselection for items
class DynamicallyCheckBoxedItems extends StatefulWidget {
  final List<ItemLookupItem> values;
  final String title;

  const DynamicallyCheckBoxedItems({Key key, this.values, this.title})
      : super(key: key);
  @override
  _DynamicallyCheckBoxedItemsState createState() =>
      _DynamicallyCheckBoxedItemsState();
}

class _DynamicallyCheckBoxedItemsState
    extends State<DynamicallyCheckBoxedItems> {
  List<String> selectedItem = [];
  Map<String, bool> mappedItems;

  @override
  Widget build(BuildContext context) {
    List<String> result = [];
    widget.values.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }
    BaseColors colors = BaseColors.of(context);
    return Scaffold(
      appBar: BaseAppBar(title: Text(widget.title), actions: [
        IconButton(
          disabledColor: Colors.black,
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              showSearch(
                  context: context, delegate: SearchAppBarItems(widget.values));
            });
          },
        )
      ]),
      body: Container(
        color: BaseColors.of(context).secondaryColor,
        child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              children: mappedItems.keys.map((String key) {
                return Container(
                  color: BaseColors.of(context).secondaryColor,
                  child: new CheckboxListTile(
                    title: new Text(key),
                    value: mappedItems[key],
                    activeColor: colors.primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        mappedItems[key] = value;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          RaisedButton(
            child: Text(" OK"),
            onPressed: () {
              {
                selectedItem.clear();

                // Traverse each map entry
                mappedItems.forEach((key, value) {
                  if (value == true) {
                    selectedItem.add(key);
                  }
                });

                // Close the Dialog & return selectedItems
                Navigator.pop(context, selectedItem);
              }
            },
            color: BaseColors.of(context).selectedColor,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
        ]),
      ),
    );
  }
}

class SearchAppBarItems extends SearchDelegate<List<String>> {
  final List<ItemLookupItem> transactions;

  SearchAppBarItems(this.transactions);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: new TextStyle(fontFamily: 'Roboto')),
        primaryColor: BaseColors.of(context).primaryColor,
        primaryIconTheme: theme.primaryIconTheme
            .copyWith(color: BaseColors.of(context).accentColor, size: 12),
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            size: 20,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, size: 20),
        onPressed: () {
          close(context, null);
        });
  }

  // @override
  Widget buildResults(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo =
          name.description != null ? name.description.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    List<String> selectedItem = [];
    Map<String, bool> mappedItems;
    List<String> result = [];
    transactionsList.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      // selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }
    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return StatefulBuilder(
                builder: (_, StateSetter setState) => CheckboxListTile(
                  title: new Text(key),
                  value: mappedItems[key],
                  activeColor: BaseColors.of(context).primaryColor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      mappedItems[key] = value;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text(" OK "),
          onPressed: () {
            {
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
            }
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }

  // @override
  Widget buildSuggestions(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo =
          name.description != null ? name.description.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    List<String> selectedItem = [];
    Map<String, bool> mappedItems;
    List<String> result = [];
    transactionsList.forEach((element) {
      result.add(element.description);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }

    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return StatefulBuilder(
                builder: (_, StateSetter setState) => CheckboxListTile(
                  title: new Text(key),
                  value: mappedItems[key],
                  activeColor: BaseColors.of(context).primaryColor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      mappedItems[key] = value;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text("OK "),
          onPressed: () {
            {
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
            }
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }
}

///MultiselectionLocation

class DynamicallyCheckBoxedLoction extends StatefulWidget {
  final List<LocationLookUpItem> values;
  final String title;

  const DynamicallyCheckBoxedLoction({Key key, this.values, this.title})
      : super(key: key);
  @override
  _DynamicallyCheckBoxedLoctionState createState() =>
      _DynamicallyCheckBoxedLoctionState();
}

class _DynamicallyCheckBoxedLoctionState
    extends State<DynamicallyCheckBoxedLoction> {
  List<String> selectedItem = [];
  Map<String, bool> mappedItems;

  @override
  Widget build(BuildContext context) {
    List<String> result = [];
    widget.values.forEach((element) {
      result.add(element.name);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }
    BaseColors colors = BaseColors.of(context);
    return Scaffold(
      appBar: BaseAppBar(title: Text(widget.title), actions: [
        IconButton(
          disabledColor: Colors.black,
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              showSearch(
                  context: context,
                  delegate: SearchAppBarLocations(
                    widget.values,
                  ));
            });
          },
        )
      ]),
      body: Container(
        color: BaseColors.of(context).secondaryColor,
        child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              children: mappedItems.keys.map((String key) {
                return Container(
                  color: BaseColors.of(context).secondaryColor,
                  child: new CheckboxListTile(
                    title: new Text(key),
                    value: mappedItems[key],
                    activeColor: colors.primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        mappedItems[key] = value;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          RaisedButton(
            child: Text(" OK"),
            onPressed: () {
              // Clear the list
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
            },
            color: BaseColors.of(context).selectedColor,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
        ]),
      ),
    );
  }
}

class SearchAppBarLocations extends SearchDelegate<LocationLookUpItem> {
  final List<LocationLookUpItem> transactions;

  SearchAppBarLocations(this.transactions);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: new TextStyle(fontFamily: 'Roboto')),
        primaryColor: BaseColors.of(context).primaryColor,
        primaryIconTheme: theme.primaryIconTheme
            .copyWith(color: BaseColors.of(context).accentColor, size: 12),
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            size: 20,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, size: 20),
        onPressed: () {
          close(context, null);
        });
  }

  // @override
  Widget buildResults(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo = name.name != null ? name.name.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    var selectedItem = [];
    Map<String, bool> mappedItems;
    var result = [];
    transactionsList.forEach((element) {
      result.add(element.name);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      // selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }
    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return StatefulBuilder(
                builder: (_, StateSetter setState) => CheckboxListTile(
                  title: new Text(key),
                  value: mappedItems[key],
                  activeColor: BaseColors.of(context).primaryColor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      mappedItems[key] = value;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text(" OK "),
          onPressed: () {
            {
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
            }
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }

  // @override
  Widget buildSuggestions(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo = name.name != null ? name.name.toUpperCase() : "";

      return transNo.contains(query.toUpperCase());
    }).toList();

    var selectedItem = [];
    Map<String, bool> mappedItems;
    var result = [];
    transactionsList.forEach((element) {
      result.add(element.name);
    });

    Map<String, bool> initMap() {
      return mappedItems = Map.fromIterable(result,
          key: (k) => k.toString(),
          value: (v) {
            if (v != true && v != false)
              return false;
            else
              return v as bool;
          });
    }

    getItems() {
      mappedItems.forEach((key, value) {
        if (value == true) {
          selectedItem.add(key);
        }
      });
      selectedItem.clear();
    }

    if (mappedItems == null) {
      initMap();
    }

    return Container(
      color: BaseColors.of(context).secondaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: mappedItems.keys.map((String key) {
              return StatefulBuilder(
                builder: (_, StateSetter setState) => CheckboxListTile(
                  title: new Text(key),
                  value: mappedItems[key],
                  activeColor: BaseColors.of(context).primaryColor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      mappedItems[key] = value;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text("OK "),
          onPressed: () {
            {
              selectedItem.clear();

              // Traverse each map entry
              mappedItems.forEach((key, value) {
                if (value == true) {
                  selectedItem.add(key);
                }
              });

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItem);
            }
          },
          color: BaseColors.of(context).selectedColor,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ]),
    );
  }
}

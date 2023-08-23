import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTreeModel {
  Map<String, dynamic> data;
  final int id;
  final int parentId;
  final String title;
  final String subTitle;
  final bool isLeaf;
  final bool isExpanded;
  List<AppTreeModel> childList;

  AppTreeModel(
      {@required this.id,
      @required this.parentId,
      @required this.title,
      @required this.isLeaf,
      this.subTitle,
      this.childList,
      this.data,
      this.isExpanded});
}

class AppTreeView extends StatelessWidget {
  final Map<int, List<AppTreeModel>> treeData;
  final Function(Map<String, dynamic> data) onLeafItemClick;

  AppTreeView(this.treeData, {this.onLeafItemClick});

  @override
  Widget build(BuildContext context) {
    return _AppTreeList(
      onLeafItemClick: onLeafItemClick,
      treeData: _buildList(),
      isChildList: false,
    );
  }

  List<AppTreeModel> _buildList() {
    if ((treeData?.isNotEmpty ?? false) && treeData[0].isNotEmpty) {
      return treeData[0].map((element) {
        int parentId = element.id;
        element.childList = _findChildren(parentId);
        return element;
      }).toList();
    }
    return [];
  }

  _findChildren(int parentId) {
    List<AppTreeModel> treeMapData = List();
    List<AppTreeModel> data = treeData[parentId];
    data?.forEach((element) {
      int parentId = element.id;
      element.childList = _findChildren(parentId);
      treeMapData.add(element);
    });
    print("List size parentId : ${treeMapData.length}");
    return treeMapData;
  }
}

class _AppTreeList extends StatefulWidget {
  final List<AppTreeModel> treeData;
  final bool isChildList;

  final Function(Map<String, dynamic> data) onLeafItemClick;

  const _AppTreeList(
      {Key key,
      @required this.treeData,
      this.isChildList = false,
      this.onLeafItemClick})
      : super(key: key);

  @override
  __AppTreeListState createState() => __AppTreeListState();
}

class __AppTreeListState extends State<_AppTreeList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: widget.isChildList
          ? NeverScrollableScrollPhysics()
          : BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 6),
      itemCount: widget.treeData?.length ?? 0,
      itemBuilder: (_con, index) {
        AppTreeModel _item = widget.treeData[index];
        return _item.isLeaf
            ? _AppLeafListItem(
                title: _item.title,
                subTitle: _item.subTitle,
                onClick: () {
                  widget.onLeafItemClick(_item.data);
                  print("On clicked base leaf");
                },
              )
            : _AppParentListItem(
                title: _item.title,
                subTitle: _item.subTitle,
                hasChild: _item.childList?.isNotEmpty ?? false,
                children: _item.childList,
                isExpanded: _item.isExpanded,
                onClick: (data) {
                  widget.onLeafItemClick(data);
                  print("On clicked from parent  leaf");
                });
      },
    );
  }
}

class _AppParentListItem extends StatefulWidget {
  final String title;
  final String subTitle;
  final bool hasChild;
  final Function(Map<String, dynamic> data) onClick;

  final bool isExpanded;
  final List<AppTreeModel> children;

  _AppParentListItem(
      {@required this.title,
      this.subTitle,
      @required this.hasChild,
      this.onClick,
      this.children,
      this.isExpanded});

  @override
  __AppParentListItemState createState() =>
      __AppParentListItemState(expanded: isExpanded);
}

class __AppParentListItemState extends State<_AppParentListItem> {
  bool isExpanded = false;

  __AppParentListItemState({bool expanded}) {
    isExpanded = expanded ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    Widget tile = ListTile(
      title: Text("${widget.title ?? ""}"),
      subtitle:
          widget.subTitle != null ? Text("${widget.subTitle ?? ""}") : null,
      leading: Icon(Icons.folder, color: isExpanded?themeData.primaryColorDark:_colors.hintColor),
      trailing: widget.hasChild
          ? Icon(
              isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              color:isExpanded?themeData.primaryColorDark: _colors.hintColor)
          : null,
      onTap: !widget.hasChild
          ? null
          : () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
    );

    return !isExpanded
        ? tile
        : Column(
            children: <Widget>[
              tile,
              _AppTreeList(
                treeData: widget.children,
                isChildList: true,
                onLeafItemClick: (data) =>
                    {widget.onClick(data), print("On clicked parent leaf")},
              )
            ],
          );
  }
}

class _AppLeafListItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onClick;

  _AppLeafListItem({
    @required this.title,
    this.subTitle,
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${title ?? ""}"),
      subtitle: subTitle != null ? Text("${subTitle ?? ""}") : null,
      leading: Icon(Icons.insert_drive_file),
      onTap: onClick,
    );
  }
}

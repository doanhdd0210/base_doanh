import '../../src/models/model_generator/manager_filter_response.dart';

class TreeNodeData {
  String title;
  String id;
  String icon;
  bool expaned;
  bool checked;
  dynamic extra;
  List<TreeNodeData> children;

  TreeNodeData({
    required this.title,
    required this.expaned,
    required this.checked,
    required this.children,
    required this.id,
    required this.icon,
    this.extra,
  });
}

class ResultTreeNode {
  List<TreeNodeData> listTree;
  List<FilterField> filterField;
  ResultTreeNode({
    required this.listTree,
    required this.filterField,
  });
}

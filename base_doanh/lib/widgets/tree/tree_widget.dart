import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../../bloc/manager_filter/manager_bloc.dart';
import 'tree_view.dart';
import '../../l10n/key_text.dart';

void showManagerFilter(BuildContext context, ManagerBloc bloc,
        Function(String ids, bool isManager) funFilter) =>
    showBottomGenCRM(
      child: TreeWidget(
        bloc: bloc,
        funFilter: funFilter,
      ),
    );

class TreeWidget extends StatefulWidget {
  TreeWidget({
    Key? key,
    required this.bloc,
    required this.funFilter,
  }) : super(key: key);
  final ManagerBloc bloc;
  final Function(String ids, bool isManager) funFilter;

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  bool isShow = false;
  bool isCheck = true;
  late final ManagerBloc _bloc;
  String? _title;
  String? _value;

  List<TreeNodeData> _setTreeData(
    TreeNodeData node,
    List<TreeNodeData> result,
    bool isCheck, {
    TreeNodeData? p,
    List<TreeNodeData>? listParent,
    bool isTree = false,
    bool isParent = false,
  }) {
    for (int i = 0; i < result.length; i++) {
      if (isTree) {
        result[i].checked = isCheck;
        if (result[i].children.isNotEmpty) {
          _setTreeData(node, result[i].children, isCheck, isTree: true);
        }
      } else if (isParent) {
        /// isParent
      } else {
        if (node == result[i]) {
          result[i].checked = isCheck;
          if (result[i].children.isNotEmpty) {
            _setTreeData(node, result[i].children, isCheck, isTree: true);
          }
        } else {
          _setTreeData(
            node,
            result[i].children,
            isCheck,
            p: p,
            listParent: listParent,
          );
        }
      }
    }
    return result;
  }

  List<TreeNodeData> _setTreeExpand(
    TreeNodeData node,
    List<TreeNodeData> result,
    bool isExpand,
  ) {
    for (int i = 0; i < result.length; i++) {
      if (node == result[i]) {
        result[i].expaned = isExpand;
      } else {
        _setTreeExpand(
          node,
          result[i].children,
          isExpand,
        );
      }
    }
    return result;
  }

  @override
  void initState() {
    _bloc = widget.bloc;
    _bloc.initData();
    if (_bloc.filterField.isNotEmpty &&
        _bloc.radioTitle == getT(KeyT.user_manager) &&
        _bloc.radioType == null) {
      _bloc.radioTitle = _bloc.filterField.first.label ?? '';
      _bloc.radioType = _bloc.filterField.first.name ?? '';
    }
    _title = _bloc.radioTitle;
    _value = _bloc.radioType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TreeNodeData>?>(
        stream: _bloc.managerTrees,
        builder: (context, snapshot) {
          final list = snapshot.data;
          if (list?.isNotEmpty ?? false) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetText(
                          title: _title,
                          style: AppStyle.DEFAULT_TITLE_APPBAR,
                        ),
                        GestureDetector(
                          onTap: () {
                            isCheck = !isCheck;
                            _bloc.resetData(isCheck);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: COLORS.RED.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: WidgetText(
                              title: getT(KeyT.all),
                              style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TreeView(
                        data: list ?? [],
                        onTap: (data, index) {
                          _bloc.managerTrees.add(_setTreeExpand(
                            data,
                            list ?? [],
                            !data.expaned,
                          ));
                        },
                        onCheck: (isCheck, data, index, p, lp) {
                          _bloc.managerTrees.add(_setTreeData(
                            data,
                            list ?? [],
                            isCheck,
                            p: p,
                            listParent: lp,
                          ));
                        },
                        showCheckBox: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: boxShadowVip,
                      color: COLORS.WHITE,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_bloc.filterField.isNotEmpty)
                          Wrap(
                            spacing: 20,
                            children: [
                              ..._bloc.filterField
                                  .map(
                                    (e) => _radioWidget(
                                      e.name ?? '',
                                      e.label ?? '',
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                paddingAll: 12,
                                backgroundColor: COLORS.GREY.withOpacity(0.5),
                                marginHorizontal: 0,
                                title: getT(KeyT.close),
                                onTap: () => Get.back(),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: ButtonCustom(
                                paddingAll: 12,
                                marginHorizontal: 0,
                                title: getT(KeyT.find),
                                onTap: () {
                                  _bloc.save();
                                  widget.funFilter(
                                      _bloc.ids, _value == ManagerBloc.MANAGER);
                                  if (_title != null)
                                    _bloc.radioTitle = _title ?? '';
                                  _bloc.radioType = _value;
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }

  Widget _radioWidget(String value, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          child: Radio<String>(
            value: value,
            groupValue: _value,
            onChanged: (String? value) {
              setState(() {
                _value = value;
                _title = title;
              });
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _value = value;
              _title = title;
            });
          },
          child: Text(
            title,
            style: AppStyle.DEFAULT_14W600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

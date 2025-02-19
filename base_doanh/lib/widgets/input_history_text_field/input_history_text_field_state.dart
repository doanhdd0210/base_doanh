import 'package:flutter/material.dart';
import '../../config/resources/styles.dart';
import '../../config/themes/app_theme.dart';
import '../../presentation/language/language_data.dart';
import '../../utils/style_utils.dart';
import 'input_history_controller.dart';
import 'input_history_item.dart';
import 'input_history_items.dart';
import 'input_history_text_field.dart';

class InputHistoryTextFieldState extends State<InputHistoryTextField> {
  late InputHistoryController _inputHistoryController;
  OverlayEntry? _overlayHistoryList;
  String? _lastSubmitValue;

  @override
  void initState() {
    super.initState();
    this._initWidgetState();
    this._initController();
  }

  void _initWidgetState() {
    if (!widget.enableHistory) return;
    widget.focusNode ??= FocusNode();
    widget.textEditingController ??=
        TextEditingController(text: _lastSubmitValue);
    if (widget.enableFilterHistory)
      widget.textEditingController?.addListener(_onTextChange);
    widget.focusNode?.addListener(_onFocusChange);
  }

  void _initController() {
    _inputHistoryController =
        widget.inputHistoryController ?? InputHistoryController();
    _inputHistoryController.setup(
        widget.historyKey, widget.limit, widget.textEditingController,
        lockItems: widget.lockItems);
  }

  void _onTextChange() {
    this
        ._inputHistoryController
        .filterHistory(widget.textEditingController!.text);
  }

  void _onFocusChange() {
    if (this.widget.hasFocusExpand) this._toggleOverlayHistoryList();
    //trigger filterHistory on focus
    if (widget.focusNode!.hasFocus)
      this
          ._inputHistoryController
          .filterHistory(widget.textEditingController!.text);
    if (widget.textEditingController!.text != _lastSubmitValue &&
        !widget.focusNode!.hasFocus) {
      //trigger _saveHistory on submit
      _saveHistory();
      _lastSubmitValue = widget.textEditingController!.text;
    }
  }

  void _saveHistory() {
    if (!widget.enableSave) return;
    final text = widget.textEditingController?.text;
    _inputHistoryController.add(text ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    this._inputHistoryController.dispose();
    this._overlayHistoryList?.remove();
  }

  @override
  Widget build(BuildContext context) {
    return _textField();
  }

  Future<void> _toggleOverlayHistoryList() async {
    if (!widget.showHistoryList) return;
    this._initOverlay();
    if (!(widget.focusNode?.hasFocus ?? false)) {
      this._inputHistoryController.hide();
      return;
    }
    this._inputHistoryController.toggleExpand();
  }

  void _initOverlay() {
    if (_overlayHistoryList != null) {
      return;
    }
    _overlayHistoryList = this._historyListContainer();
    Overlay.of(context).insert(this._overlayHistoryList!);
  }

  OverlayEntry _historyListContainer() {
    final render = context.findRenderObject() as RenderBox;
    return OverlayEntry(
      builder: (context) {
        return StreamBuilder<bool>(
          stream: this._inputHistoryController.listShow.stream,
          builder: (context, shown) {
            if (!shown.hasData) return SizedBox.shrink();
            return Stack(
              children: <Widget>[
                shown.data! ? _backdrop(context) : SizedBox.shrink(),
                _historyList(context, render, shown.data!)
              ],
            );
          },
        );
      },
    );
  }

  Widget _historyList(BuildContext context, RenderBox render, bool isShow) {
    final offset = render.localToGlobal(Offset.zero);
    final listOffset = widget.listOffset ?? Offset(0, 0);
    return Positioned(
        top: offset.dy +
            render.size.height +
            (widget.listStyle == ListStyle.Badge
                ? listOffset.dy + 10
                : listOffset.dy),
        left: 0, //offset.dx, //+ listOffset.dx,
        right: 0,
        height: isShow ? null : 0,
        child: Material(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppTheme.getInstance().shadowColor().withOpacity(0.3),
                  spreadRadius: 0, // Độ lan rộng của shadow (đặt thành 0)
                  blurRadius: 10, // Độ mờ của shadow
                  offset: Offset(0,
                      10), // Để shadow hiển thị ở dưới, đặt offset dương (0, 5)
                ),
              ],
              color: Colors.white,
            ),
            child: StreamBuilder<InputHistoryItems>(
              stream: this._inputHistoryController.list.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError || !isShow)
                  return SizedBox.shrink();
                if (widget.listStyle == ListStyle.Badge) {
                  return Wrap(
                    children: [
                      for (var item in snapshot.data!.all)
                        _badgeHistoryItem(item)
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Lang.key(keyT.RECENT_SEARCHES),
                              style: TextStyleCustom.f16w600,
                            ),
                            InkWell(
                              onTap: () async {
                                _inputHistoryController.hide();
                                if (_inputHistoryController
                                        .getHistory.all.length !=
                                    -1) {
                                  _deleteAll(_inputHistoryController);
                                }
                              },
                              child: Text(
                                Lang.key(keyT.CLEAR_ALL),
                                style: TextStyleCustom.f16w600.copyWith(
                                  color: AppTheme.getInstance().colorFF7210ff(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      line(color: AppTheme.getInstance().getLineColor()),
                      spaceH8,
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 0,
                          maxHeight: (MediaQuery.of(context).size.height / 2),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.all.length,
                          itemBuilder: (context, index) {
                            return Opacity(
                              opacity: widget.enableOpacityGradient
                                  ? 1 - index / snapshot.data!.all.length
                                  : 1,
                              child: widget.historyListItemLayoutBuilder?.call(
                                      this._inputHistoryController,
                                      snapshot.data!.all[index],
                                      index) ??
                                  _listHistoryItem(snapshot.data!.all[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget _badgeHistoryItem(item) {
    return Container(
      height: 32,
      margin: EdgeInsets.only(right: 5, bottom: 5),
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: this._backgroundColor(item) ??
            // ignore: deprecated_member_use_from_same_package
            widget.badgeColor ??
            Theme.of(context).disabledColor.withAlpha(20),
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      child: InkWell(
        onTap: () => this._inputHistoryController.select(item.text),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// history icon
            if (widget.showHistoryIcon) _historyIcon(),

            /// text
            _historyItemText(item),

            /// remove icon
            if (widget.showDeleteIcon) _deleteIcon(item)
          ],
        ),
      ),
    );
  }

  Widget _backdrop(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          this._toggleOverlayHistoryList();
          widget.focusNode?.unfocus();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _listHistoryItem(InputHistoryItem item) {
    return InkWell(
      onTap: () => this._inputHistoryController.select(item.text),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: _listHistoryItemDecoration(item),
        child: Row(
          children: [
            /// history icon
            if (widget.showHistoryIcon) _historyIcon(),

            /// text
            _listHistoryItemText(item),

            /// remove icon
            if (widget.showDeleteIcon) _deleteIcon(item)
          ],
        ),
      ),
    );
  }

  Decoration? _listHistoryItemDecoration(InputHistoryItem item) {
    if (widget.listRowDecoration != null) return widget.listRowDecoration;
    if (widget.backgroundColor != null) {
      return BoxDecoration(color: _backgroundColor(item));
    }
    return null;
  }

  Widget _listHistoryItemText(InputHistoryItem item) {
    return Expanded(
      flex: 1,
      child: Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: this._historyItemText(item)),
    );
  }

  Widget _historyItemText(InputHistoryItem item) {
    return Text(
      item.textToSingleLine,
      overflow: TextOverflow.ellipsis,
      style: widget.listTextStyle ??
          TextStyle(
            color: this._textColor(item) ??
                Theme.of(context).textTheme.bodyMedium!.color,
          ),
    );
  }

  Color? _textColor(InputHistoryItem item) {
    if (item.isLock) return widget.lockTextColor;
    return widget.textColor;
  }

  Color? _backgroundColor(InputHistoryItem item) {
    if (item.isLock) return widget.lockBackgroundColor;
    return widget.backgroundColor;
  }

  Widget _historyIcon() {
    return SizedBox(
      width: 22,
      height: 22,
      child: widget.historyIconTheme ??
          Icon(
            widget.historyIcon,
            size: 18,
            color: widget.historyIconColor ?? Theme.of(context).disabledColor,
          ),
    );
  }

  Widget _deleteIcon(InputHistoryItem item) {
    if (item.isLock) return SizedBox.shrink();
    return SizedBox(
      width: 22,
      height: 22,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        color: Theme.of(context).disabledColor,
        icon: widget.deleteIconTheme ??
            Icon(
              widget.deleteIcon,
              size: 18,
              color: widget.deleteIconColor ?? Theme.of(context).disabledColor,
            ),
        onPressed: () {
          _inputHistoryController.remove(item);
        },
      ),
    );
  }

  void _onTap() {
    widget.onTap?.call();
    if (widget.textEditingController == null) return;
    final endPosition = widget.textEditingController?.selection.end;
    final textLength = widget.textEditingController?.text.length;
    if (endPosition == textLength) this._toggleOverlayHistoryList();
  }

  Widget _textField() {
    return TextFormField(
        key: widget.key,
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        readOnly: widget.readOnly,
        // ignore: deprecated_member_use
        toolbarOptions: widget.toolbarOptions,
        showCursor: widget.showCursor,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        // ignore: deprecated_member_use
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onSubmitted,
        enabled: widget.enabled,
        cursorWidth: widget.cursorWidth,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        dragStartBehavior: widget.dragStartBehavior,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        onTap: _onTap,
        buildCounter: widget.buildCounter,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics);
  }

  _deleteAll(InputHistoryController controller) async {
    final listHis = await controller.getHistory.all;
    await controller.remove(listHis.first);
    if (listHis.length != -1) {
      _deleteAll(controller);
    }
  }
}

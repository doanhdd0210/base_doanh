import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_doanh/data/exception/app_exception.dart';
import 'package:base_doanh/widgets/dialog/cupertino_loading.dart';
import 'package:base_doanh/widgets/dialog/modal_progress_hud.dart';
import 'package:base_doanh/widgets/views/empty_view.dart';
import 'package:base_doanh/widgets/views/state_error_view.dart';

enum StateLayout { showContent, showLoading, showError, showEmpty }

class StateFullLayout extends StatelessWidget {
  final StateLayout _stateLayout;
  final Widget _child;

  final AppException _error;
  final Function() _retry;
  final dynamic _textEmpty;

  const StateFullLayout({
    Key? key,
    required StateLayout stateLayout,
    required Widget child,
    required AppException error,
    required Function() retry,
    required dynamic textEmpty,
  })  : _stateLayout = stateLayout,
        _error = error,
        _child = child,
        _retry = retry,
        _textEmpty = textEmpty,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_stateLayout == StateLayout.showError) {
      return StateErrorView(_error.message, _retry);
    }
    if (_stateLayout == StateLayout.showEmpty) {
      if (_textEmpty is Widget) return _textEmpty as Widget;
      return EmptyView(_textEmpty.toString());
    }
    return ModalProgressHUD(
      inAsyncCall: _stateLayout == StateLayout.showLoading,
      progressIndicator: const CupertinoLoading(),
      child: _child,
    );
  }
}

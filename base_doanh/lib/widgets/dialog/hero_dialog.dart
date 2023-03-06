import 'package:flutter/material.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    required bool isNonBackground,
    bool dismiss = true,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        _isNonBackground = isNonBackground,
        _isDismiss = dismiss,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;
  final bool _isNonBackground;
  final bool _isDismiss;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => _isDismiss;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => _isNonBackground
      ? Colors.transparent
      : const Color.fromRGBO(0, 0, 0, 0.4);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _builder(context);
  }

  @override
  String get barrierLabel => '';
}

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/widgets/dialog/dialog_utils.dart';
import 'package:base_doanh/widgets/listener/event_bus.dart';

abstract class BaseState<T extends StatefulWidget> extends BaseSetState<T> {
  // After the first time the page is show, this value will be true
  bool layoutCreatedFirstTime = false;
  final CompositeSubscription _unAuthSubscription = CompositeSubscription();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!layoutCreatedFirstTime) {
      onFirstTimePageInit();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => afterFirstLayout(context),
    );
    _handleEventBus();
  }

  @override
  void dispose() {
    super.dispose();
    _unAuthSubscription.clear();
  }

  void afterFirstLayout(BuildContext context) {}

  Future<void> onFirstTimePageInit() async {
    layoutCreatedFirstTime = true;
  }

  void _handleEventBus() {
    eventBus.on<UnAuthEvent>().listen((event) {
      _showUnAuthDialog();
    }).addTo(_unAuthSubscription);
  }

  void _showUnAuthDialog() {
    DialogUtils.showAlert(
      content: S.current.unauthorized,
      onConfirm: () {
        //todo clear data storage and  -> move to example_view
      },
    );
  }
}

abstract class BaseSetState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }
}

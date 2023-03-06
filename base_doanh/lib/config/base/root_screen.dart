import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';
import 'package:base_doanh/widgets/listener/event_bus.dart';

abstract class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);
}

abstract class RootScreenScreen<T extends RootScreen> extends State<T>
    with WidgetsBindingObserver {
  final CompositeSubscription _unAuthSubscription = CompositeSubscription();
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    timeCounter(timeRequest: DateTime.now().millisecondsSinceEpoch);
    super.initState();
    _handleEventBus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unAuthSubscription.clear();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  static void showDialogLoginByExpiredToken() {
    if (PrefsService.getToken().isNotEmpty) {
      //Todo
      // DialogUtils.showCoralDialog(
      //   content: S.current.session_time_out,
      //   onClose: () {
      //     final context = Get.context;
      //     if (context != null) {
      //       pushToFirst(
      //         context,
      //         const LoginScreen(),
      //       );
      //     }
      //     PrefsService.saveToken('');
      //     PrefsService.saveLoginWallet('false');
      //     PrefsService.saveUserProfile('');
      //     LoginFacebook.signOutWithFacebook();
      //     LoginGoogle.handleSignOut();
      //   },
      // );
    }
  }

  void _handleEventBus() {
    eventBus.on<StartTimeCountDownByRequestAPIEvent>().listen((event) {
      timeCounter(timeRequest: event.timeRequest);
    }).addTo(_unAuthSubscription);
  }

  void timeCounter({required int timeRequest}) {
    //todo
    final int timeLockApp = 15 * 60000;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      final timeBetween = (timeRequest + timeLockApp) -
          DateTime.now().toUtc().millisecondsSinceEpoch;
      if (timeBetween <= 0) {
        timer?.cancel();
        showDialogLoginByExpiredToken();
        return;
      }
    });
  }
}

void sendEventCountDownTimeLockApp() {
  eventBus.fire(
    StartTimeCountDownByRequestAPIEvent(DateTime.now().millisecondsSinceEpoch),
  );
}

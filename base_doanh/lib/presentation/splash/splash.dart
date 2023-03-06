import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_doanh/config/routes/router.dart';
import 'package:base_doanh/domain/firebase/firebase_message/firebase_config.dart';
import 'package:base_doanh/domain/firebase/firebase_message/notification_service.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int timeAnimation = 2;
  final token = PrefsService.getToken();
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: timeAnimation),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: const Cubic(0.3, 0.5, 0.7, 1),
  );

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    super.initState();
    // _listenFirebaseMessage();
    _navigateToMain();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToMain() async {
    await Future.delayed(Duration(seconds: timeAnimation), () {
      openScreenAndRemoveUtil(context, AppRouter.main);
    });
  }

  void _listenFirebaseMessage() {
    // initDynamicLinks();
    NotificationLocalService().initNotification();
    FirebaseConfig.getInitialMessage();
    FirebaseConfig.receiveFromBackgroundState();
    FirebaseConfig.onMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage(ImageAssets.imgEmpty),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            child: FadeTransition(
              opacity: _animation,
              child: ImageAssets.svgAssets(
                ImageAssets.icSuccess,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

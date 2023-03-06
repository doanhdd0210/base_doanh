import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:base_doanh/domain/firebase/firebase_message/notification_service.dart';

class FirebaseConfig {
  static Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  static void onBackgroundPressed() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void getInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        ///TODO
      }
    });
  }

  static void receiveFromBackgroundState() {
    ///onMessageOpenedApp: A Stream which posts a RemoteMessage when
    ///the application is opened from a background state.
    FirebaseMessaging.onMessageOpenedApp.listen((value) {
      ///TODO
    });
  }

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;
      if (notification != null && Platform.isAndroid) {
        unawaited(
          NotificationLocalService().showNotification(
            id: notification.hashCode,
            title: notification.title ?? '',
            body: notification.body ?? '',
            payload: '{}',
          ),
        );
      }
    });
  }

  static Future<void> showNotificationForeground() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getTokenFcm() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  static Future<void> deleteTokenFcm() async {
    await FirebaseMessaging.instance.deleteToken();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

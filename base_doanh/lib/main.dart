import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:base_doanh/config/base/root_screen.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/routes/router.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/data/di/module.dart';
import 'package:base_doanh/domain/env/develop.dart';
import 'package:base_doanh/domain/env/model/app_constants.dart';
import 'package:base_doanh/domain/firebase/firebase_message/firebase_config.dart';
import 'package:base_doanh/domain/firebase/firebase_message/notification_service.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/screen_controller.dart';

MethodChannel trustWalletChannel = const MethodChannel('flutter/trust_wallet');

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  Get.put(AppConstants.fromJson(configDevEnv));
  await mainApp();
}

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp();
  // await FirebaseConfig.requestPermission();
  // await FirebaseConfig.showNotificationForeground();
  // FirebaseConfig.onBackgroundPressed();
  // await NotificationLocalService().createChanel();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PrefsService.init();
  //remove token to logout when open app
  await PrefsService.saveToken('');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_){
        final token = PrefsService.getToken();
        if (token.isNotEmpty){
          sendEventCountDownTimeLockApp();
        }
      },
      child: KeyboardDismisser(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context,child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            title: Get.find<AppConstants>().appName,
            theme: ThemeData(
              primaryColor: AppTheme.getInstance().primaryColor(),
              cardColor: Colors.white,
              textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
              appBarTheme: const AppBarTheme(
                color: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              dividerColor: colorDivider,
              scaffoldBackgroundColor: Colors.white,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppTheme.getInstance().primaryColor(),
                selectionColor: AppTheme.getInstance().primaryColor(),
                selectionHandleColor: AppTheme.getInstance().primaryColor(),
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: AppTheme.getInstance().accentColor()),
            ),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('en'),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splash,
          ),
        ),
      ),
    );
  }
}

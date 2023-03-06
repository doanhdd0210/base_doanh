// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again later.`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Session time out!`
  String get session_time_out {
    return Intl.message(
      'Session time out!',
      name: 'session_time_out',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Please check the internet connection and try again later.`
  String get error_network {
    return Intl.message(
      'Please check the internet connection and try again later.',
      name: 'error_network',
      desc: '',
      args: [],
    );
  }

  /// `Can’t access to the server, please try again later.`
  String get server_error {
    return Intl.message(
      'Can’t access to the server, please try again later.',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired. Please sign in.`
  String get unauthorized {
    return Intl.message(
      'Your session has expired. Please sign in.',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message(
      'Log in',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Email or username`
  String get email_or_username {
    return Intl.message(
      'Email or username',
      name: 'email_or_username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Continue with`
  String get continue_with {
    return Intl.message(
      'Continue with',
      name: 'continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with`
  String get sign_up_with {
    return Intl.message(
      'Sign up with',
      name: 'sign_up_with',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Email`
  String get continue_with_email {
    return Intl.message(
      'Continue with Email',
      name: 'continue_with_email',
      desc: '',
      args: [],
    );
  }

  /// `Have an account already?`
  String get have_an_account_already {
    return Intl.message(
      'Have an account already?',
      name: 'have_an_account_already',
      desc: '',
      args: [],
    );
  }

  /// `Press back again to exit`
  String get out_app {
    return Intl.message(
      'Press back again to exit',
      name: 'out_app',
      desc: '',
      args: [],
    );
  }

  /// `Allow to access your Camera and Photos`
  String get allow_permission {
    return Intl.message(
      'Allow to access your Camera and Photos',
      name: 'allow_permission',
      desc: '',
      args: [],
    );
  }

  /// `Go to Setting`
  String get go_to_setting {
    return Intl.message(
      'Go to Setting',
      name: 'go_to_setting',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Popular list`
  String get popular_list {
    return Intl.message(
      'Popular list',
      name: 'popular_list',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

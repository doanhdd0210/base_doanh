import 'package:shared_preferences/shared_preferences.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:base_doanh/utils/extensions/enum_ext.dart';

class PrefsService {
  static const _PREF_BIOMETRIC_TYPE = '_pref_biometric_type';
  static const _PREF_TOKEN_KEY = 'pref_token_key';
  static const _PREF_REFRESH_TOKEN = 'pref_refresh_token';
  static const _PREF_LOGIN_USERNAME = 'pref_login_username';
  static const _PREF_LOGIN_PASSWORD = 'pref_login_password';
  static const _PREF_LANGUAGE = 'pref_language';
  static const _PREF_BIOMETRIC = 'pref_biometric';

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }


  static Future<bool> saveBiometricType(BiometricDeviceType value) async {
    final prefs = await _instance;
    return prefs.setString(_PREF_BIOMETRIC_TYPE, value.getName());
  }

  static BiometricDeviceType getBiometricType() {
    return _prefsInstance?.getString(_PREF_BIOMETRIC_TYPE)?.getTypeBiometric() ??
        BiometricDeviceType.NO_CHECK;
  }

  static bool isGuest() {
    return getToken().isEmpty;
  }

  static bool isLoggedIn() {
    return getToken().isNotEmpty;
  }

  static Future<bool> saveToken(String value) async {
    final prefs = await _instance;
    return prefs.setString(_PREF_TOKEN_KEY, value);
  }

  static String getToken() {
    return _prefsInstance?.getString(_PREF_TOKEN_KEY) ?? '';
  }

  static Future<bool> saveRefreshToken(String value) async {
    final prefs = await _instance;
    return prefs.setString(_PREF_REFRESH_TOKEN, value);
  }

  static String getRefreshToken() {
    return _prefsInstance?.getString(_PREF_REFRESH_TOKEN) ?? '';
  }

  static Future<bool?> saveLoginUserName(String userName) async {
    return _prefsInstance?.setString(_PREF_LOGIN_USERNAME, userName);
  }

  static Future<bool?> saveLoginPassWord(String passWord) async {
    return _prefsInstance?.setString(_PREF_LOGIN_PASSWORD, passWord);
  }

  static String getLoginUserName() {
    return _prefsInstance?.getString(_PREF_LOGIN_USERNAME) ?? '';
  }

  static String getLoginPassWord() {
    return _prefsInstance?.getString(_PREF_LOGIN_PASSWORD) ?? '';
  }

  static Future<bool> saveLanguage(String code) async {
    final prefs = await _instance;
    return prefs.setString(_PREF_LANGUAGE, code);
  }

  static String getLanguage() {
    return _prefsInstance?.getString(_PREF_LANGUAGE) ?? VI_CODE;
  }

  static Future<void> clearAuthData() async {
    await _prefsInstance?.remove(_PREF_TOKEN_KEY);
  }

  static Future<void> clearData() async {
    await _prefsInstance?.clear();
    return;
  }

  static Future<bool> saveBiometricStateWallet(bool value) async {
    final prefs = await _instance;
    return prefs.setBool(_PREF_BIOMETRIC, value);
  }

  static bool isUseBiometricWallet() {
    return _prefsInstance?.getBool(_PREF_BIOMETRIC) ?? false;
  }

}

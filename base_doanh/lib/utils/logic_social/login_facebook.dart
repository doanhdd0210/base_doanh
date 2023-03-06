import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginFacebook {
  static Future<String> loginFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      return result.accessToken?.token ?? '';
    } else {
      return '';
    }
  }

  static Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
  }
}

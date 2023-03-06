import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginApple {
  static Future<String> loginApple() async {
    try {
      final data = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return data.identityToken ?? '';
    } catch (e) {
      return '';
    }
  }
}

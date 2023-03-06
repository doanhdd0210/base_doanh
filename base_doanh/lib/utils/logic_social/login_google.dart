import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogle {
  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
    ],
  );

  static Future<String> handleSignIn() async {
    String ggToken = '';
    try {
      final GoogleSignInAccount? google = await googleSignIn.signIn();
      await google?.authentication.then((value) {
        ggToken = value.accessToken ?? '';
      });
      return ggToken;
    } catch (error) {
      return ggToken;
    }
  }

  static Future<void> handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (error) {}
  }
}

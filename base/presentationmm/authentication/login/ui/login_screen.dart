import 'package:auto_route/auto_route.dart';
import 'package:azmod/config/routes/app_router.gr.dart';
import 'package:azmod/domain/locals/secure_store/auth_storage.dart';
import 'package:azmod/domain/model/authentication/user_model.dart';
import 'package:azmod/domain/singleton/user_singleton.dart';
import 'package:azmod/presentation/authentication/login/ui/login_screen_ipad.dart';
import 'package:azmod/presentation/authentication/login/ui/login_screen_mobile.dart.dart';
import 'package:azmod/widgets/common/screen_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginIDController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RoleType? selectedRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      _loginIDController.text = 'role2';
      _passwordController.text = '12345678';
      selectedRole = RoleType.role2;
    }
  }

  @override
  void dispose() {
    _loginIDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> onLoginSuccess(DateTime expireDate, UserModel userModel) async {
    SecureStorage.instance.setExpireDate(expireDate);
    UserSingleton.instance.userData = userModel;
    await SecureStorage.instance.setAuthData(userModel);
    if (mounted) {
      context.router.replace(const PatientsRoute());
    }
  }

  void onLoginFail(String? message) {
    _passwordController.text = '';
    if (message != null) {
      showError(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ScreenBuilder(
      ipadScreen: LoginIpadScreen(),
      mobileScreen: LoginMobileScreen(),
    );
  }
}

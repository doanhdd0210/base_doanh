import 'package:auto_route/auto_route.dart';
import 'package:azmod/config/resources/dimen.dart';
import 'package:azmod/config/resources/images.dart';
import 'package:azmod/config/routes/app_router.gr.dart';
import 'package:azmod/domain/locals/secure_store/auth_storage.dart';
import 'package:azmod/domain/model/authentication/user_model.dart';
import 'package:azmod/domain/repository/auth_repository.dart';
import 'package:azmod/domain/singleton/user_singleton.dart';
import 'package:azmod/generated/l10n.dart';
import 'package:azmod/presentation/authentication/login/cubit/login_cubit.dart';
import 'package:azmod/utils/extensions/context_ext.dart';
import 'package:azmod/utils/extensions/string_ext.dart';
import 'package:azmod/widgets/text_field/text_field_with_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginIpadScreen extends StatefulWidget {
  const LoginIpadScreen({super.key});

  @override
  State<LoginIpadScreen> createState() => _LoginIpadScreenState();
}

class _LoginIpadScreenState extends State<LoginIpadScreen> {
  final _loginIDController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RoleType? selectedRole;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (kDebugMode) {
  //     _loginIDController.text = 'role2';
  //     _passwordController.text = '12345678';
  //     selectedRole = RoleType.role2;
  //   }
  // }

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
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(context.read<AuthRepository>()),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                spaceH12,
                _buildHeaderLogo(),
                spaceH12,
                _buildInputForm(),
                spaceH12,
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      minimumSize: Size(50.w, 30.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Text(S.current.forgotPassword,
                      style: context.typography.bodyText2
                          ?.copyWith(color: context.color.primary)),
                  onPressed: () {
                    context.router.push(const ResetPasswordRoute());
                  },
                ),
                spaceH24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 386.w),
            child: TextFieldWithIcon(
              label: S.current.loginId,
              controller: _loginIDController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return S.current.requireData;
                }
                return null;
              },
              removePadding: true,
            ),
          ),
          spaceH12,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 386.w),
            child: BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (prev, next) =>
                  prev.isShowPassword != next.isShowPassword,
              builder: (context, state) {
                return TextFieldWithIcon(
                  label: S.current.password,
                  controller: _passwordController,
                  obscureText: !state.isShowPassword,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return S.current.requireData;
                    }
                    return null;
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        context.read<LoginCubit>().updateVisiblePassword();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Icon(state.isShowPassword
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  removePadding: true,
                );
              },
            ),
          ),
          spaceH12,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 386.w),
            child: DropdownButtonFormField(
              onTap: () {},
              value: selectedRole,
              decoration: InputDecoration(
                label: Text(S.current.role),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                isDense: true,
              ),
              isExpanded: true,
              onChanged: (value) {
                selectedRole = value;
              },
              style: context.typography.bodyText2
                  ?.copyWith(color: context.color.primary),
              items: RoleType.values
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.name.capitalizeFirst),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return S.current.requireData;
                }
                return null;
              },
            ),
          ),
          spaceH12,
          Builder(builder: (context) {
            return ElevatedButton(
              style: context.style.primaryButton.copyWith(
                  padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20))),
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                context.read<LoginCubit>().login(
                      loginId: _loginIDController.text.trim(),
                      password: _passwordController.text.trim(),
                      role: selectedRole!,
                      onSuccess: onLoginSuccess,
                      onFail: onLoginFail,
                    );
              },
              child: Text(S.current.login),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceH8,
            SvgPicture.asset(
              ImageAssets.zollLogSvg,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            Text(
              'an Asahi Kasei company',
              style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w300,
                  color: context.color.onSurface),
            ),
          ],
        ),
        spaceH12,
        Image.asset(
          ImageAssets.codeMateLogo,
          height: 28.h,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}

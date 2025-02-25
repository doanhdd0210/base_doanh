import 'package:azmod/domain/model/authentication/user_model.dart';
import 'package:azmod/domain/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';

part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepo) : super(const LoginState.initial());
  final AuthRepository authRepo;

  void updateVisiblePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  Future<void> login({
    required String loginId,
    required String password,
    required RoleType role,
    required Function(DateTime expireDate, UserModel user) onSuccess,
    required Function(String? message) onFail,
  }) async {
    try {
      final result = await authRepo.authenticateUser(
        password: password, role: role.value, username: loginId,
      );
      if (!result.isSuccess) {
        onFail(result.message);
      } else {
        if (result.expireDate != null && result.userData != null) {
          onSuccess(result.expireDate!, result.userData!);
        } else {
          onFail('Something went wrong, please try again later');
        }
      }
    } catch (_) {
      onFail('Something went wrong, please try again later');
    }
  }
}

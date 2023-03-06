import 'package:base_doanh/data/response/account/account_response.dart';
import 'package:base_doanh/data/response/movie_response.dart';
import 'package:base_doanh/data/result/result.dart';
import 'package:base_doanh/data/services/account_service.dart';
import 'package:base_doanh/domain/model/authenication/unauthorized_model.dart';
import 'package:base_doanh/domain/model/movie_model.dart';
import 'package:base_doanh/domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountClient _accountService;

  AccountRepositoryImpl(
    this._accountService,
  );

  @override
  Future<Result<UnauthorizedModel>> refreshToken(String refreshToken) {
    return runCatchingAsync<AccountResponse, UnauthorizedModel>(
      () => _accountService.refreshToken(refreshToken),
      (response) => UnauthorizedModel('', ''),
    );
  }

  @override
  Future<Result<List<MovieModel>>> getListMovie(String apiKey, int page) {
    return runCatchingAsync<MovieResponse, List<MovieModel>>(
      () => _accountService.getListMovie(apiKey, page),
      (response) => response.toListMovie(),
    );
  }
}

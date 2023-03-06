import 'package:base_doanh/data/result/result.dart';
import 'package:base_doanh/domain/model/authenication/unauthorized_model.dart';

mixin AccountRepository {
  Future<Result<UnauthorizedModel>> refreshToken(String refreshToken);
}

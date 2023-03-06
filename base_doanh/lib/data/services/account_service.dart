import 'package:base_doanh/data/response/movie_response.dart';
import 'package:base_doanh/utils/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:base_doanh/data/response/account/account_response.dart';

part 'account_service.g.dart';

@RestApi()
abstract class AccountClient {
  @factoryMethod
  factory AccountClient(Dio dio, {String baseUrl}) = _AccountClient;

  @POST("")
  Future<AccountResponse> refreshToken(
    @Field('refresh_token') String refreshToken,
  );

  @GET(ApiConstants.GET_LIST_MOVIE)
  Future<MovieResponse> getListMovie(
      @Query('api_key') String apiKey,
      @Query('page') int page,
      );
}

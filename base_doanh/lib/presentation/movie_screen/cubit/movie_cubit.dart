import 'package:base_doanh/domain/model/movie_model.dart';
import 'package:base_doanh/domain/repository/account_repository.dart';
import 'package:base_doanh/utils/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/base/base_cubit.dart';

part 'movie_state.dart';

class MovieCubit extends BaseCubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  AccountRepository _repository = Get.find();
  static const String API_KEY = '26763d7bf2e94098192e629eb975dab0';

  Future<List<MovieModel>> getListMovie({
    int page = ApiConstants.PAGE_BEGIN,
  }) async {
    late final List<MovieModel> data;
    final result = await _repository.getListMovie(API_KEY, page);
    result.when(
      success: (comments) {
        data = comments;
      },
      error: (e) {
        throw e;
      },
    );
    return data;
  }
}

import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';

class MovieModel {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  num popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  num voteAverage;
  num voteCount;

  MovieModel({
    this.adult = false,
    this.backdropPath = '',
    required this.genreIds,
    this.id = 0,
    this.originalLanguage = '',
    this.originalTitle = '',
    this.overview = '',
    this.popularity = 0,
    this.posterPath = '',
    this.releaseDate = '',
    this.title = '',
    this.video = false,
    this.voteAverage = 0,
    this.voteCount = 0,
  });

  DateTime get year => DateFormat(DateTimeFormat.DOB_FORMAT).parse(this.releaseDate);
}

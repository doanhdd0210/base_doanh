import 'package:json_annotation/json_annotation.dart';

part 'app_constants.g.dart';

@JsonSerializable()
class AppConstants {
  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'app_name')
  String appName;

  @JsonKey(name: 'base_url')
  String baseUrl;

  AppConstants(
    this.type,
    this.appName,
    this.baseUrl
  );

  factory AppConstants.fromJson(Map<String, dynamic> json) =>
      _$AppConstantsFromJson(json);
}

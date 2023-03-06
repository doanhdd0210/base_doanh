import 'package:json_annotation/json_annotation.dart';

part 'develop.g.dart';

@JsonLiteral('develop.json', asConst: true)
Map<String, dynamic> get configDevEnv => _$configDevEnvJsonLiteral;

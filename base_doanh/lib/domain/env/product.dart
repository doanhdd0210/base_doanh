import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonLiteral('product.json', asConst: true)
Map<String, dynamic> get configProductEnv => _$configProductEnvJsonLiteral;

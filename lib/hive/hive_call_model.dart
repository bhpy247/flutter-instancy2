import 'package:hive/hive.dart';

import '../models/common/model_data_parser.dart';

enum HiveOperationType {
  get, set
}

class HiveCallModel {
  final Box? box;
  final HiveOperationType operationType;
  final ModelDataParsingType parsingType;
  final String key;
  final dynamic value;

  const HiveCallModel({
    this.box,
    required this.operationType,
    required this.parsingType,
    required this.key,
    this.value,
  });
}
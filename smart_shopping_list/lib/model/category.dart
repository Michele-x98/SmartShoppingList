import 'package:freezed_annotation/freezed_annotation.dart';

import 'item.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String title,
    required List<Item> items,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

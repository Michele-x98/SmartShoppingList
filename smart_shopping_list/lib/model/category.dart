import 'package:freezed_annotation/freezed_annotation.dart';

import 'item.dart';

part 'category.freezed.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required String title,
    required List<Item> items,
  }) = _CategoryModel;
}

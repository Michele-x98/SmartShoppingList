import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String name,
    required num unit,
    @Default(false) bool taken,
  }) = _Item;
}

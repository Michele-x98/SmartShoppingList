import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_shopping_list/model/category.dart';

class HiveStoreService {
  late final Box _labelsBox;
  late final Box _itemsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _labelsBox = await Hive.openBox('labels');
    _itemsBox = await Hive.openBox('items');
  }

  HiveStoreService._();
  static final HiveStoreService instance = HiveStoreService._();

  List<String> getLabels() =>
      _labelsBox.get('labels', defaultValue: <String>[]);

  void saveLabels(List<String> labels) => _labelsBox.put('labels', labels);

  List<CategoryModel> getItems() {
    final items = json
        .decode(_itemsBox.get('items', defaultValue: <Map<String, dynamic>>[]));
    return items
        .map((e) => CategoryModel.fromJson(e))
        .toList()
        .cast<CategoryModel>();
  }

  void saveItems(List<CategoryModel> items) {
    final list = jsonEncode(items);
    _itemsBox.put('items', list);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/services/hive_store.dart';

import '../model/category.dart';
import '../model/item.dart';

final shoppingListProvider =
    NotifierProvider<ShoppingListProvider, List<CategoryModel>>(
  ShoppingListProvider.new,
);

class ShoppingListProvider extends Notifier<List<CategoryModel>> {
  final HiveStoreService _hiveStoreService = HiveStoreService.instance;

  @override
  List<CategoryModel> build() {
    return HiveStoreService.instance.getItems();
  }

  void addItem(String category, Item item) {
    final index = state.indexWhere((element) => element.title == category);
    if (index == -1) {
      state = [
        ...state,
        CategoryModel(title: category, items: [item])
      ];
    } else {
      state = state[index].items.contains(item)
          ? state
          : [
              ...state.sublist(0, index),
              CategoryModel(
                title: state[index].title,
                items: [...state[index].items, item],
              ),
              ...state.sublist(index + 1),
            ];
    }
    _hiveStoreService.saveItems(state);
  }

  void removeItem(String category, Item item) {
    final index = state.indexWhere((element) => element.title == category);
    if (index == -1) {
      return;
    } else {
      state = [
        ...state.sublist(0, index),
        CategoryModel(
          title: state[index].title,
          items:
              state[index].items.where((element) => element != item).toList(),
        ),
        ...state.sublist(index + 1),
      ];
    }
    _hiveStoreService.saveItems(state);
  }

  void updateItem(String category, Item newItem) {
    final index = state.indexWhere((element) => element.title == category);
    if (index == -1) {
      return;
    } else {
      state = [
        ...state.sublist(0, index),
        CategoryModel(
          title: state[index].title,
          items: state[index].items.map((e) {
            if (e.id == newItem.id) {
              return newItem;
            } else {
              return e;
            }
          }).toList(),
        ),
        ...state.sublist(index + 1),
      ];
    }
    _hiveStoreService.saveItems(state);
  }

  void removeCategory(String title) {
    state = state.where((element) => element.title != title).toList();
    _hiveStoreService.saveItems(state);
  }
}

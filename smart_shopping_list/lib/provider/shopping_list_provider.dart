import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../model/category.dart';
import '../model/item.dart';

/// generate 3 fake categories with 3 items each
final temp = [
  CategoryModel(
    title: 'kitchen',
    items: [
      Item(id: const Uuid().v4(), name: 'Pasta', unit: 1),
      Item(id: const Uuid().v4(), name: 'Tomato', unit: 1),
      Item(id: const Uuid().v4(), name: 'Oil', unit: 1),
    ],
  ),
  CategoryModel(
    title: 'bathroom',
    items: [
      Item(id: const Uuid().v4(), name: 'Shampoo', unit: 1),
      Item(id: const Uuid().v4(), name: 'Toothbrush', unit: 1),
      Item(id: const Uuid().v4(), name: 'Toothpaste', unit: 1),
    ],
  ),
  CategoryModel(
    title: 'office',
    items: [
      Item(id: const Uuid().v4(), name: 'Papers', unit: 1),
      Item(id: const Uuid().v4(), name: 'Books', unit: 1),
      Item(id: const Uuid().v4(), name: 'Alarms', unit: 1),
    ],
  ),
];

final shoppingListProvider =
    NotifierProvider<ShoppingListProvider, List<CategoryModel>>(
  ShoppingListProvider.new,
);

class ShoppingListProvider extends Notifier<List<CategoryModel>> {
  @override
  List<CategoryModel> build() {
    // get shopping list from local storage
    return temp;
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
  }

  void removeCategory(String title) {
    state = state.where((element) => element.title != title).toList();
  }
}

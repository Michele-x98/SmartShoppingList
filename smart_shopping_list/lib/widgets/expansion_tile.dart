import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/extension.dart';
import 'package:smart_shopping_list/model/category.dart';
import 'package:smart_shopping_list/provider/shopping_list_provider.dart';
import 'package:smart_shopping_list/widgets/add_item_sheets.dart';

class ExpansionTileItem extends ConsumerWidget {
  const ExpansionTileItem({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(category.title),
      onDismissed: (direction) {
        ref.read(shoppingListProvider.notifier).removeCategory(category.title);
      },
      child: ExpansionTile(
        title: Text('${category.title} (${category.items.length})'),
        shape: const RoundedRectangleBorder(),
        children: [
          ...category.items
              .map((item) => Dismissible(
                    key: Key(item.name),
                    background: ColoredBox(
                      color: Colors.red.withOpacity(0.2),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      if (category.items.length == 1) {
                        return ref
                            .read(shoppingListProvider.notifier)
                            .removeCategory(category.title);
                      }
                      ref
                          .read(shoppingListProvider.notifier)
                          .removeItem(category.title, item);
                    },
                    child: ListTile(
                      leading: Checkbox(
                        shape: const CircleBorder(),
                        value: item.taken,
                        onChanged: (value) {
                          ref.read(shoppingListProvider.notifier).updateItem(
                                category.title,
                                item.copyWith(taken: !item.taken),
                              );
                        },
                      ),
                      title: InkWell(
                        child: Text(item.name),
                        onTap: () {
                          ref.read(shoppingListProvider.notifier).updateItem(
                                category.title,
                                item.copyWith(taken: !item.taken),
                              );
                        },
                      ),
                      trailing: Text('${item.unit}'),
                    ),
                  ))
              .toList(),
          ElevatedButton(
            onPressed: () => context.showModal(
                child: AddItemSheets(category: category.title)),
            child: const Text('Add new item'),
          )
        ],
      ),
    );
  }
}

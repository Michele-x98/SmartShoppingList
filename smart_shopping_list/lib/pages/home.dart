import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/settings.dart';
import 'package:smart_shopping_list/provider/shopping_list_provider.dart';
import 'package:smart_shopping_list/services/hive_store.dart';
import 'package:smart_shopping_list/widgets/add_item_sheets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isModalOpen = false;

  bool get isModalOpen => _isModalOpen;

  set isModalOpen(bool value) {
    setState(() => _isModalOpen = value);
  }

  void openModal({String? category}) {
    if (_isModalOpen) {
      return;
    }
    isModalOpen = true;
    setState(() {});

    if (mounted) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => AddItemSheets(
          category: category,
        ),
      ).then((value) {
        if (mounted) {
          isModalOpen = false;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(shoppingListProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.deepPurple.withOpacity(0.2),
              title: const Text('Smart Home List'),
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: list.length,
        padding: const EdgeInsets.only(top: 110),
        itemBuilder: (BuildContext context, int index) {
          final category = list[index];
          return Dismissible(
            key: Key(category.title),
            onDismissed: (direction) {
              ref
                  .read(shoppingListProvider.notifier)
                  .removeCategory(category.title);
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
                            ref.read(shoppingListProvider.notifier).removeItem(
                                  category.title,
                                  item,
                                );
                          },
                          child: ListTile(
                            leading: Checkbox(
                              shape: const CircleBorder(),
                              value: item.taken,
                              onChanged: (value) {
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .updateItem(
                                      category.title,
                                      item.copyWith(taken: !item.taken),
                                    );
                              },
                            ),
                            title: InkWell(
                              child: Text(item.name),
                              onTap: () {
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .updateItem(
                                      category.title,
                                      item.copyWith(taken: !item.taken),
                                    );
                              },
                            ),
                            trailing: Text(item.unit.toString()),
                          ),
                        ))
                    .toList(),
                ElevatedButton(
                  onPressed: () => openModal(category: category.title),
                  child: const Text('Add new item'),
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 1,
          endIndent: 20,
          indent: 20,
          color: Colors.deepPurple.withOpacity(0.4),
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () => openModal(),
          elevation: 0,
          backgroundColor: Colors.deepPurple.withOpacity(0.4),
          child: Icon(
            _isModalOpen ? Icons.keyboard_arrow_down_rounded : Icons.add,
            color: Colors.white,
          ),
        );
      }),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/extension.dart';
import 'package:smart_shopping_list/pages/settings.dart';
import 'package:smart_shopping_list/provider/shopping_list_provider.dart';
import 'package:smart_shopping_list/widgets/add_item_sheets.dart';
import 'package:smart_shopping_list/widgets/expansion_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return ExpansionTileItem(category: category);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 1,
          endIndent: 20,
          indent: 20,
          color: Colors.deepPurple.withOpacity(0.4),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () => context.showModal(child: const AddItemSheets()),
            elevation: 0,
            backgroundColor: Colors.deepPurple.withOpacity(0.4),
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}

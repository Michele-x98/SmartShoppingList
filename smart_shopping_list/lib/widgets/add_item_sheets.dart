import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/model/item.dart';
import 'package:smart_shopping_list/provider/shopping_list_provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/classify_provider.dart';

class AddItemSheets extends ConsumerStatefulWidget {
  final String? category;
  const AddItemSheets({super.key, this.category});

  @override
  ConsumerState<AddItemSheets> createState() => _AddItemSheetsState();
}

class _AddItemSheetsState extends ConsumerState<AddItemSheets> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();
  String? _category;
  bool _showCategoryTextField = false;

  bool get _canSubmit =>
      _inputController.text.isNotEmpty &&
      _unitController.text.isNotEmpty &&
      num.tryParse(_unitController.text) != null &&
      num.parse(_unitController.text) > 0 &&
      (_categoryController.text.isNotEmpty || _category != null);

  @override
  void initState() {
    super.initState();
    _category = widget.category;
  }

  void _onAddItem() {
    ref.read(shoppingListProvider.notifier).addItem(
          _category ?? _categoryController.text,
          Item(
            id: const Uuid().v4(),
            name: _inputController.text,
            unit: int.parse(_unitController.text),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(classifyViewModelProvider.notifier);

    final suggestions = notifier.suggestions;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade700.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Divider(
                height: 5,
                thickness: 5,
                indent: 120,
                endIndent: 120,
                color: Colors.deepPurple.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 20),
                child: Text(
                  _category == null ? 'Add Item' : 'Add Item to $_category',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _inputController,
                              focusNode: _inputFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Enter item',
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IntrinsicWidth(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(0.4),
                                    child: IconButton(
                                      onPressed: () {
                                        final value = num.tryParse(
                                                _unitController.text) ??
                                            0;
                                        if (value > 0) {
                                          _unitController.text =
                                              (value - 1).toString();
                                        }
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.remove_outlined),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: _unitController,
                                    focusNode: _unitFocusNode,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        _unitController.text = '0';
                                      }
                                      if (num.tryParse(value) == null) {
                                        _unitController.text = '0';
                                      }
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: '0',
                                      // Remove the border
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(0.4),
                                    child: IconButton(
                                      onPressed: () {
                                        final value = num.tryParse(
                                                _unitController.text) ??
                                            0;
                                        _unitController.text =
                                            (value + 1).toString();
                                        setState(() {});
                                      },
                                      splashColor:
                                          Colors.deepPurple.withOpacity(0.2),
                                      icon: const Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 16,
                        bottom: 16,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _inputController,
                        builder: (BuildContext context, value, Widget? child) =>
                            ElevatedButton(
                          onPressed:
                              ref.watch(classifyViewModelProvider).isLoading ||
                                      _inputController.text.isEmpty
                                  ? null
                                  : () => notifier
                                      .getClassification(_inputController.text),
                          child: const Text('classify'),
                        ),
                      ),
                    ),
                    if (ref.watch(classifyViewModelProvider).isLoading) ...[
                      const CircularProgressIndicator()
                    ] else if (suggestions.isNotEmpty) ...[
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == suggestions.length) {
                              return InkWell(
                                onTap: () {
                                  _category = null;
                                  _showCategoryTextField =
                                      !_showCategoryTextField;
                                  setState(() {});
                                },
                                child: const Chip(
                                  label: Text('Custom'),
                                  shape: StadiumBorder(),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                right: 16,
                                left: index == 0 ? 16 : 0,
                              ),
                              child: InkWell(
                                enableFeedback: true,
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.blue,
                                onTap: () {
                                  _category = suggestions[index];
                                  _showCategoryTextField = false;
                                  setState(() {});
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: _category == suggestions[index]
                                        ? Border.all(
                                            color: Colors.deepPurple.shade100,
                                            width: 2,
                                          )
                                        : null,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.deepPurple.shade500,
                                        Colors.deepPurple.shade900
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(suggestions[index]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (_showCategoryTextField) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _categoryController,
                            focusNode: _categoryFocusNode,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter Category for ${_inputController.text}',
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _inputController,
                        _unitController,
                        _categoryController,
                      ]),
                      builder: (BuildContext context, Widget? child) {
                        if (!_canSubmit) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade500,
                            ),
                            onPressed: _onAddItem,
                            child: const Text('Add'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

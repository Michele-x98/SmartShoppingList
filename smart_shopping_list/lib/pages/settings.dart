import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:smart_shopping_list/services/hive_store.dart';
import 'package:smart_shopping_list/utils/extensions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ValueNotifier<List<String>> labels = ValueNotifier([]);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newLabelController = TextEditingController();
  ValueNotifier<bool> _enableSave = ValueNotifier(false);

  @override
  void initState() {
    labels.value = HiveStoreService.instance.getLabels();
    super.initState();
  }

  bool _alreadyExists(String label) {
    return labels.value
        .map((e) => e.toUpperCase())
        .toList()
        .contains(label.toUpperCase());
  }

  void _addLabel() {
    final newLabel = _newLabelController.text;
    if (newLabel.isEmpty) return;
    if (_alreadyExists(newLabel)) {
      _newLabelController.clear();
      return context.showSnackError('Label already exists');
    }
    setState(() {
      labels.value.add(newLabel);
    });
    _newLabelController.clear();
    _enableSave.value = true;
  }

  void _removeLabel(String label) {
    setState(() {
      labels.value.remove(label);
    });
    _enableSave.value = true;
  }

  void _updateLabel(int index, String newLabel) {
    labels.value[index] = newLabel;
    _enableSave.value = true;
  }

  void _saveLabels() {
    if (labels.value.isEmpty) {
      return context.showSnackError('You must have at least one label');
    }
    HiveStoreService.instance.saveLabels(labels.value);
    _enableSave.value = false;
    context.showSnackSuccess('Labels saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: GlassmorphicContainer(
          blur: 8,
          alignment: Alignment.bottomCenter,
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0.1, 1],
          ),
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0.1, 1],
          ),
          border: 0,
          borderRadius: 8,
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Classify items by label',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _newLabelController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Add a new label',
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _addLabel(),
                        child: const Text('ADD'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // wirte a Textfiled followed by a list of dismissible strings editable by the user

                Form(
                  key: _formKey,
                  child: ValueListenableBuilder(
                    valueListenable: labels,
                    builder: (BuildContext context, List<String> value,
                            Widget? child) =>
                        ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: TextFormField(
                            key: ValueKey(value[index]),
                            controller:
                                TextEditingController(text: value[index]),
                            onChanged: (value) {
                              _updateLabel(index, value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a label';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => _removeLabel(value[index]),
                            icon: const Icon(Icons.close),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _enableSave,
        builder: (BuildContext context, bool value, Widget? child) => value
            ? FloatingActionButton.extended(
                label: const Text('Save Changes'),
                onPressed: _saveLabels,
              ).animate().fadeIn()
            : const SizedBox(),
      ),
    );
  }
}

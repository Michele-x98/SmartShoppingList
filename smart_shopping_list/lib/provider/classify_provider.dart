import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/services/hive_store.dart';

final classifyViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ClassifyViewModel, List<String>>(
  ClassifyViewModel.new,
);

class ClassifyViewModel extends AutoDisposeAsyncNotifier<List<String>> {
  List<String> get suggestions => state.value ?? [];

  Future<void> getClassification(String input, {bool translate = false}) async {
    state = const AsyncValue.loading();
    final labels = HiveStoreService.instance.getLabels();
    final body = json.encode({"item": input, "candidate_labels": labels});
    try {
      final res = await http.post(
        Uri.parse('http://localhost:5000/classify'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      final items = (jsonDecode(res.body) as List<dynamic>).cast<String>();
      state = AsyncValue.data(items.reversed.toList());
    } catch (e) {
      state = const AsyncValue.data([]);
    }
  }

  @override
  FutureOr<List<String>> build() {
    return suggestions;
  }
}

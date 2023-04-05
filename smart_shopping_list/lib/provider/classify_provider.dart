import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final classifyViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ClassifyViewModel, List<String>>(
  ClassifyViewModel.new,
);

class ClassifyViewModel extends AutoDisposeAsyncNotifier<List<String>> {
  List<String> get suggestions => state.value ?? [];

  Future<void> getClassification(String input, {bool translate = false}) async {
    state = const AsyncValue.loading();
    final res = await HttpClient().getUrl(
      Uri.parse(
        'http://localhost:5000/classify?item=$input&use_translatrion=$translate',
      ),
    );
    final response = await res.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final items = (jsonDecode(responseBody) as List<dynamic>).cast<String>();
    state = AsyncValue.data(items.reversed.toList());
  }

  @override
  FutureOr<List<String>> build() {
    return suggestions;
  }
}

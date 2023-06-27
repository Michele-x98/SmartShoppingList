import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  void showModal({required Widget child}) =>
      Scaffold.of(this).showBottomSheet((context) => child);
}

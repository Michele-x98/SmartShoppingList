import 'package:flutter/material.dart';

/// Extension methods for [BuildContext].
extension BuildContextX on BuildContext {
  /// Returns an error SnackBar
  void showSnackError(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.withOpacity(0.2),
      ),
    );
  }

  /// Returns a success SnackBar
  void showSnackSuccess(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple.shade500.withOpacity(0.5),
    ));
  }
}

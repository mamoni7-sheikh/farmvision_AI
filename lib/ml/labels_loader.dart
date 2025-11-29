import 'package:flutter/services.dart' show rootBundle;

class LabelsLoader {
  /// Loads labels safely from asset file.
  /// - Removes empty lines
  /// - Removes extra spaces
  /// - Fixes Windows \r issue
  /// - Removes duplicates
  /// - Returns clean List<String>
  static Future<List<String>> loadLabels(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);

      final labels = raw
          .replaceAll('\r', '')          // Fix Windows line endings
          .split('\n')                   // Split per line
          .map((e) => e.trim())          // Remove spaces
          .where((e) => e.isNotEmpty)    // Skip empty lines
          .toSet()                       // Remove duplicates
          .toList();

      print("✔ Labels Loaded: ${labels.length}");

      return labels;
    } catch (e) {
      print(" ERROR loading labels → $e");
      return [];
    }
  }
}
